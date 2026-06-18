import 'package:flutter/material.dart';

void main() {
  runApp(const PraktikumModulApp());
}

class PraktikumModulApp extends StatelessWidget {
  const PraktikumModulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Praktikum 4-5',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const TugasScreen(),
      // Menonaktifkan banner debug untuk tampilan production
      debugShowCheckedModeBanner: false,
    );
  }
}

class TugasScreen extends StatelessWidget {
  const TugasScreen({super.key});

  // DATA ARRAY YANG AMAN (Immutable Data Structure)
  // Menghindari modifikasi data dari memori secara ilegal.
  // Data simulasi menggunakan layanan cuci sepatu.
  final List<String> arrayLayanan = const [
    "Layanan Cuci: Deep Clean",
    "Layanan Cuci: Fast Clean",
    "Layanan Tambahan: Unyellowing",
    "Layanan Tambahan: Leather Care"
  ];

  final List<String> arrayStatus = const [
    "Menunggu Pembayaran",
    "Sedang Dicuci",
    "Siap Diambil"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul 4-5: Implementasi Widget UI'),
        backgroundColor: Colors.blueGrey[900],
      ),
      // SingleChildScrollView digunakan agar layar
      // tidak mengalami overflow saat digulir
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==========================================
            // 1. CONTAINER
            // ==========================================
            const JudulSection(judul: "1. Container (Kotak Berwarna)"),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Ini adalah Container",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // ==========================================
            // 2. STACK
            // ==========================================
            const JudulSection(judul: "2. Stack (Tampilan Bertumpuk)"),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5
                        )
                      ],
                    ),
                  ),
                  const Text(
                    "Teks di Atas Kotak",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ==========================================
            // 3. GRIDVIEW (Minimal 6 Item)
            // ==========================================
            const JudulSection(judul: "3. GridView (6 Item Grid)"),
            GridView.count(
              shrinkWrap: true, // Wajib agar tidak error di dalam Column
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(6, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Grid ${index + 1}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 25),

            // ==========================================
            // 4. LISTVIEW (3 Item A, B, C)
            // ==========================================
            const JudulSection(judul: "4. ListView Statis (A, B, C)"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ListTile(
                    leading: CircleAvatar(child: Text("A")),
                    title: Text("Item Data A"),
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Text("B")),
                    title: Text("Item Data B"),
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Text("C")),
                    title: Text("Item Data C"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ==========================================
            // 5. LISTVIEW.BUILDER (Dari Data Array)
            // ==========================================
            const JudulSection(judul: "5. ListView.builder (Dari Array)"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: arrayLayanan.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.cleaning_services),
                    title: Text(arrayLayanan[index]),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),

            // ==========================================
            // 6. LISTVIEW.SEPARATED (Garis Pembatas)
            // ==========================================
            const JudulSection(judul: "6. ListView.separated (Dengan Garis)"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: arrayStatus.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.redAccent,
                    thickness: 1.5,
                  );
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(arrayStatus[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 40), // Spasi bawah agar rapi
          ],
        ),
      ),
    );
  }
}

// Widget Bantuan untuk Judul agar kode lebih DRY (Don't Repeat Yourself)
class JudulSection extends StatelessWidget {
  final String judul;
  const JudulSection({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        judul,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}