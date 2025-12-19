// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tangsugar/model/brands.dart';
import 'package:tangsugar/model/products.dart';
import 'package:tangsugar/providers/database_provider.dart';
import 'package:tangsugar/providers/history_provider.dart';

class DetailPage extends ConsumerStatefulWidget {
  final Brands brand;

  // ignore: use_key_in_widget_constructors
  const DetailPage({Key? key, required this.brand});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  late TextEditingController _searchController;
  String _searchText = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue =
        ref.watch(brandProductsProvider(widget.brand.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Produk ${widget.brand.name}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search... (Try: "no sugar")',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 700), () {
                  setState(() {
                    _searchText = value;
                  });
                });
              },
            ),
          ),
          Expanded(
            child: productsAsyncValue.when(
              data: (brandProducts) {
                if (brandProducts.isEmpty) {
                  return Center(
                    child: Text('Produk tidak ada untuk ${widget.brand.name}'),
                  );
                }

                final filteredProducts = brandProducts
                    .where((product) =>
                        product.foodname
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()) ||
                        product.deskripsi
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final Products product = filteredProducts[index];
                    double result = product.sugar / product.weight * 100;
                    String sugarIndex;
                    Color boxColor;
                    if (result == 0) {
                      sugarIndex = 'A';
                      boxColor = Colors.green;
                    } else if (result <= 4) {
                      sugarIndex = 'B';
                      boxColor = const Color.fromARGB(255, 4, 211, 183);
                    } else if (result <= 8) {
                      sugarIndex = 'C';
                      boxColor = Colors.orange;
                    } else {
                      sugarIndex = 'D';
                      boxColor = Colors.red;
                    }

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          product.pict,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                        title: Text(
                          product.foodname,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.deskripsi,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sugar: ${product.sugar} gram',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text('Weight: ${product.weight} ml',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    ref
                                        .read(historyProvider.notifier)
                                        .addToHistory(product);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Produk Ditambahkan'),
                                          content: const Text(
                                              'Produk ditambahkan ke history'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: boxColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Nilai gula: $sugarIndex',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildQuestionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildQuestionButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Text('Skor Indeks Gula'),
              content: Container(
                decoration: BoxDecoration(
                  color: Colors
                      .blueGrey, // Atur warna latar belakang konten sesuai preferensi Anda
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.5),
                  child: Image.asset('lib/assets/image5.png'),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      tooltip: 'Index Gula',
      child: const Icon(Icons.question_mark_sharp),
    );
  }
}
