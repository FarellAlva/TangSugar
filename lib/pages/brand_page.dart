// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tangsugar/model/brands.dart';
import 'package:tangsugar/services/database_service.dart';
import 'detail_page.dart';

// ignore: camel_case_types
class brandPage extends StatefulWidget {
  const brandPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _brandPage createState() => _brandPage();
}

// ignore: camel_case_types
class _brandPage extends State<brandPage> {
  final DatabaseService _databaseService = DatabaseService();
  late String _searchText = '';
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TangSugar'), shadowColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 700), () {
                    setState(() {
                      _searchText = value;
                    });
                  });
                },
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  labelText: 'Search ...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                
              ),
              const SizedBox(height: 6.0),
              Expanded(
                child: StreamBuilder<List<Brands>>(
                  stream: _databaseService.getBrands(),
                  builder: (context, AsyncSnapshot<List<Brands>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Terjadi kesalahan: ${snapshot.error.toString()}'));
                    }
                    final brands = snapshot.data;
                    if (brands == null || brands.isEmpty) {
                      return const Center(child: Text('Data tidak ditemukan.'));
                    }

                    final filteredBrands = _searchText.isEmpty
                        ? brands
                        : brands
                            .where((brand) => brand.name
                                .toLowerCase()
                                .contains(_searchText.toLowerCase()))
                            .toList();

                    if (filteredBrands.isEmpty) {
                      return const Center(child: Text('Brand tidak ditemukan.'));
                    }

                    return ListView.builder(
                      itemCount: filteredBrands.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(brand: filteredBrands[index]),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        filteredBrands[index].logoUrl),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          filteredBrands[index].name,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Total Product: ${filteredBrands[index].totalproduct.toString()}',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
