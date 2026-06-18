import 'package:flutter/material.dart';
import '../models/mahasiswa_model.dart';

class StatistikPage extends StatefulWidget {
  final List<Mahasiswa> data;
  const StatistikPage({super.key, required this.data});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  String? _selectedJurusan;

  final List<String> _daftarJurusan = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Software Engineering',
    'Sains Data',
    'Teknik Telekomunikasi',
    'Teknik Elektro',
    'Teknik Biomedis',
    'Teknik Industri',
    'Teknik Logistik',
    'Desain Komunikasi Visual',
    'Desain Produk',
    'Teknologi Pangan',
  ];

  @override
  void initState() {
    super.initState();
    _selectedJurusan = _daftarJurusan[0];
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data global (Data mahasiswa dari semua jurusan)
    int totalGlobal = widget.data.length; // data total mahasiswa
    double rataIpkGlobal = totalGlobal == 0
        ? 0
        : widget.data.map((m) => m.ipk).reduce((a, b) => a + b) / totalGlobal;

    // mengambil data sesuai filter jurusan yang dipilih
    List<Mahasiswa> dataFilter =
        widget.data.where((m) => m.jurusan == _selectedJurusan).toList();

    int totalFilter = dataFilter.length; // data jumlah mahasiswa
    int lakiLaki = dataFilter.where((m) => m.gender).length; // data jumlah mahasiswa laki-laki
    int perempuan = totalFilter - lakiLaki; // data jumlah mahasiswa perempuan
    double rataIpkFilter = totalFilter == 0
        ? 0
        : dataFilter.map((m) => m.ipk).reduce((a, b) => a + b) / totalFilter;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17), // Premium dark background
      appBar: AppBar(
        title: const Text(
          "Statistik - Arnanda S. N. P.",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2CB67D), Color(0xFF1E8256)], // Distinct green/teal gradient for stats
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // bagian ringkasan data global
            const Row(
              children: [
                Icon(Icons.analytics_outlined, color: Color(0xFF2CB67D), size: 24),
                SizedBox(width: 8),
                Text(
                  "Ringkasan Global",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCardSmall(
                    "Total Mahasiswa",
                    "$totalGlobal",
                    Icons.group_rounded,
                    const Color(0xFF7F5AF0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCardSmall(
                    "Rata-Rata IPK",
                    rataIpkGlobal.toStringAsFixed(2),
                    Icons.school_rounded,
                    Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Color(0xFF242629), thickness: 1.5),
            ),

            // bagian data sesuai filter jurusan
            const Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: Color(0xFF7F5AF0), size: 24),
                SizedBox(width: 8),
                Text(
                  "Filter Program Studi",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: const Color(0xFF16161A), // Dropdown menu background color
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedJurusan,
                dropdownColor: const Color(0xFF16161A),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF16161A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF242629)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF242629)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7F5AF0), width: 1.5),
                  ),
                  prefixIcon: const Icon(Icons.category_rounded, color: Color(0xFF94A1B2)),
                ),
                items: _daftarJurusan
                    .map((j) => DropdownMenuItem(
                          value: j,
                          child: Text(
                            j,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedJurusan = val!),
              ),
            ),

            const SizedBox(height: 24),
            _buildStatCard(
              "Jumlah Mahasiswa",
              "$totalFilter",
              Icons.people_alt_rounded,
              const Color(0xFF7F5AF0),
            ),
            _buildStatCard(
              "Laki-Laki",
              "$lakiLaki",
              Icons.male_rounded,
              Colors.cyan,
            ),
            _buildStatCard(
              "Perempuan",
              "$perempuan",
              Icons.female_rounded,
              Colors.pinkAccent,
            ),
            _buildStatCard(
              "Rata-Rata IPK",
              rataIpkFilter.toStringAsFixed(2),
              Icons.school_rounded,
              Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  // widget untuk data sesuai filter jurusan
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: const Color(0xFF16161A),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2), width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title, 
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            color: Color(0xFF94A1B2),
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // widget kecil untuk data global
  Widget _buildStatCardSmall(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: const Color(0xFF16161A),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title, 
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12, 
                color: Color(0xFF94A1B2),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
