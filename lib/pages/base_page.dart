import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tangsugar/model/brands.dart';
import 'package:tangsugar/model/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tangsugar/pages/barcode_page.dart';

import 'package:tangsugar/pages/history_page.dart';
import 'package:tangsugar/pages/brand_page.dart';
import 'package:tangsugar/pages/analisis.dart';
import 'package:tangsugar/providers/api_provider.dart';

class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  double _totalSugar = 0;
  bool _exceedLimit = false;
  List<String>? _imageUrls;
  final String brand = 'Toko/Minimarket';

  @override
  void initState() {
    _imageUrls = [];
    super.initState();
    _calculateTotalSugar();
    // Panggil fungsi total sugar setiap waktu yang ditentukan
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _calculateTotalSugar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to, TangSugar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            tooltip: 'Test API',
            onPressed: () {
              ref.refresh(fetchDataProvider.future).then((data) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data: ${data['message']}')),
                  );
                }
              }).catchError((error) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Konsumsi Gula Hari Ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_totalSugar gr',
                  style: TextStyle(
                    color: _exceedLimit ? Colors.red : Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200, // Sesuaikan dengan tinggi gambar
            child: PageView.builder(
              itemCount: _imageUrls?.length,
              itemBuilder: (context, index) {
                return _buildNetworkImage(_imageUrls![index]);
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const brandPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                  83, 78, 177, 213), // Set latar belakang transparan
              elevation: 0,
              shadowColor: Colors.transparent,
              fixedSize: const Size(100, 50),
              side: const BorderSide(
                  color: Color.fromARGB(255, 128, 47, 120),
                  width: 2), // Tambahkan border
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    Text('Cari produk/brand'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.transparent, // Set latar belakang transparan
              elevation: 0,
              fixedSize: const Size(100, 50),
              shadowColor: Colors.transparent, // Hilangkan elevasi
              side: const BorderSide(
                  color: Colors.blue, width: 2), // Tambahkan border
            ),
            child: const SizedBox(
              width: double.infinity,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.history),
                SizedBox(width: 10),
                Text('History'),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SugarAnalysisPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.transparent, // Set background to transparent
              elevation: 0, // Remove elevation
              shadowColor:
                  Colors.transparent, // Set shadow color to transparent
              fixedSize: const Size(100, 50), // Set button size
              side:
                  const BorderSide(color: Colors.blue, width: 2), // Add border
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Analisis asupan gula'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final brandToPass = Brands(
                name: 'Cari Barcode Produk',
                logoUrl: '',
                totalproduct: 0,
                id: 'AATOKOSERBAADA',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Barco
                  
                    brand: brandToPass,
                    index: 0,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent, // Set latar belakang transparan
              elevation: 0,
              fixedSize: const Size(100, 50), // Hilangkan elevasi
              side: const BorderSide(
                  color: Colors.blue, width: 2), // Tambahkan border
            ),
            child: const SizedBox(
              width: double.infinity,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.camera),
                SizedBox(width: 10),
                Text('Cari barcode'),
              ]),
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

  Widget _buildNetworkImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> _calculateTotalSugar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyJsonList = prefs.getStringList('history') ?? [];
    List<Products> historyProducts = historyJsonList
        .map((json) => Products.fromJson(jsonDecode(json), id: ''))
        .toList();

    double totalSugar = 0;
    for (var product in historyProducts) {
      totalSugar += product.sugar;
    }

    if (totalSugar <= 50) {
      setState(() {
        _totalSugar = totalSugar;
        _exceedLimit = false;
        _imageUrls = ['lib/assets/image1.png', 'lib/assets/image2.png'];
      });
    } else {
      setState(() {
        _totalSugar = totalSugar;
        _exceedLimit = true;
        _imageUrls = ['lib/assets/image3.png', 'lib/assets/image4.png'];
      });
    }
  }
}
