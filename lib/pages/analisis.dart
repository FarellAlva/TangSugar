import 'package:flutter/material.dart';

class SugarAnalysisPage extends StatefulWidget {
  const SugarAnalysisPage({super.key});

  @override
  State<SugarAnalysisPage> createState() => _SugarAnalysisPageState();
}

class _SugarAnalysisPageState extends State<SugarAnalysisPage> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  String get monthYear => '${_monthName(_currentMonth.month)} ${_currentMonth.year}';

  String _monthName(int m) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return names[m - 1];
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Asupan Gula'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousMonth,
                ),
                Text(
                  monthYear,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const Center(
                  child: Text(
                    '60 gr',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Asupan gula tidak melebihi batas', // Placeholder message based on sugar intake
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Konsumsi gula harian:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                // Assuming 30 days in a month
                itemBuilder: (context, index) {
                  // Placeholder values for daily consumption history
                  final date = DateTime(_currentMonth.year, _currentMonth.month, index + 1);
                  final totalSugar = (index + 1) * 10; // Example calculation
                  return _buildDayBox(date, totalSugar);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBox(DateTime date, int totalSugar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.day} ${_monthName(date.month)} ${date.year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Total Sugar: $totalSugar gr',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
