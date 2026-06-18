import 'package:flutter/material.dart';
import '../models/mahasiswa_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // menangkap data (object) yang dikirim melalui argumen rute
    final Mahasiswa mhs =
        ModalRoute.of(context)!.settings.arguments as Mahasiswa;

    // mengubah boolean gender menjadi teks
    String genderTeks = mhs.gender ? "Laki-laki" : "Perempuan";
    // format tanggal lahir
    String tglLahirTeks =
        "${mhs.tgllahir.day}-${mhs.tgllahir.month}-${mhs.tgllahir.year}";

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17), // Premium dark background
      appBar: AppBar(
        title: const Text(
          'Detail Mahasiswa',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F5AF0), Color(0xFF5B3BB4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Card(
            color: const Color(0xFF16161A), // Sleek card background
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: const Color(0xFF7F5AF0).withOpacity(0.3), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7F5AF0), Color(0xFF2CB67D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7F5AF0).withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        mhs.nama.isNotEmpty ? mhs.nama.substring(0, 1).toUpperCase() : 'M',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    mhs.nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2CB67D).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'NIM: ${mhs.nim}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2CB67D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFF242629), thickness: 1.5),
                  const SizedBox(height: 16),
                  
                  // Info Details
                  _buildDetailRow(
                    context,
                    icon: Icons.school_rounded,
                    label: 'Program Studi',
                    value: mhs.jurusan,
                    iconColor: const Color(0xFF7F5AF0),
                  ),
                  const SizedBox(height: 18),
                  _buildDetailRow(
                    context,
                    icon: Icons.star_rounded,
                    label: 'Indeks Prestasi Kumulatif (IPK)',
                    value: mhs.ipk.toString(),
                    iconColor: Colors.amber,
                  ),
                  const SizedBox(height: 18),
                  _buildDetailRow(
                    context,
                    icon: Icons.cake_rounded,
                    label: 'Tanggal Lahir',
                    value: tglLahirTeks,
                    iconColor: Colors.pinkAccent,
                  ),
                  const SizedBox(height: 18),
                  _buildDetailRow(
                    context,
                    icon: Icons.wc_rounded,
                    label: 'Jenis Kelamin',
                    value: genderTeks,
                    iconColor: Colors.cyan,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A1B2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
