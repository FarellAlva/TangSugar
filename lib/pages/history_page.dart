// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tangsugar/providers/history_provider.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final historyList = ref.watch(historyProvider);
    final historyNotifier = ref.read(historyProvider.notifier);
    double totalSugar = historyNotifier.totalSugar;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Riwayat'),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showInfoDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Total konsumsi gula: $totalSugar gr',
              style: const TextStyle(fontSize: 18),
            ),
            const Text(
              'Rekomendasi konsumsi gula harian: 50 gr',
              style: TextStyle(fontSize: 14),
            ),
            if (totalSugar > 50)
              const Text(
                'Warning: Konsumsi gula telah melewati batas harian',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            historyList.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada produk dalam riwayat',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        final product = historyList[index];
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sugar: ${product.sugar} gram',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'Weight: ${product.weight} ml',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.clear_outlined),
                                      onPressed: () {
                                        ref
                                            .read(historyProvider.notifier)
                                            .removeFromHistory(index);
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
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: _buildDeleteButton(),
    );
  }

  Widget _buildDeleteButton() {
    return FloatingActionButton(
      onPressed: () {
        ref.read(historyProvider.notifier).clearHistory();
      },
      tooltip: 'Delete All History',
      child: const Icon(Icons.delete),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('History'),
          content: const Text(
              'Riwayat akan diperbarui setiap hari secara otomatis.'),
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
  }
}
