import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/mahasiswa_model.dart';
import '../main.dart';

class CrudMahasiswaPage extends StatefulWidget {
  final List<Mahasiswa> data;
  const CrudMahasiswaPage({super.key, required this.data});

  @override
  State<CrudMahasiswaPage> createState() => _CrudMahasiswaPageState();
}

class _CrudMahasiswaPageState extends State<CrudMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _ipkController = TextEditingController();

  String? _jurusanTerpilih;
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

  DateTime? _tglLahirTerpilih;
  bool _genderTerpilih = true;

  // Memunculkan Notifikasi & Mencatat ke Riwayat Log
  Future<void> _tampilkanNotifikasi(String judul, String pesan) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'crud_channel',
      'Notifikasi CRUD',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    // Tembakkan notifikasi ke sistem bar Android
    await flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: judul,
      body: pesan,
      notificationDetails: platformDetails,
    );

    // Tambahkan ke Log Riwayat
    String waktu =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    logNotifikasi.insert(
      0,
      "[$waktu] $judul: $pesan",
    ); // menyisipkan log baru di urutan paling atas
  }

  // Dialog Form (Tambah & Edit Data)
  void _tampilFormDialog({int? index}) {
    if (index != null) {
      // Mode Edit: Isi form dengan data lama yang dipilih
      _namaController.text = widget.data[index].nama;
      _nimController.text = widget.data[index].nim;
      _ipkController.text = widget.data[index].ipk.toString();
      _jurusanTerpilih = widget.data[index].jurusan;
      _tglLahirTerpilih = widget.data[index].tgllahir;
      _genderTerpilih = widget.data[index].gender;

      _namaController.selection = TextSelection.fromPosition(
        TextPosition(offset: _namaController.text.length),
      );
      _nimController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nimController.text.length),
      );
      _ipkController.selection = TextSelection.fromPosition(
        TextPosition(offset: _ipkController.text.length),
      );
    } else {
      // MODE CREATE: Kosongkan Form
      _namaController.clear();
      _nimController.clear();
      _ipkController.clear();
      _jurusanTerpilih = null;
      _tglLahirTerpilih = null;
      _genderTerpilih = true;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: const Color(0xFF16161A),
            canvasColor: const Color(0xFF16161A), // for dropdown menu
          ),
          child: AlertDialog(
            backgroundColor: const Color(0xFF16161A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFF242629)),
            ),
            title: Text(
              index == null ? 'Tambah Mahasiswa' : 'Edit Mahasiswa',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _namaController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        labelStyle: TextStyle(color: Color(0xFF94A1B2)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF242629)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7F5AF0)),
                        ),
                      ),
                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nimController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        labelStyle: TextStyle(color: Color(0xFF94A1B2)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF242629)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7F5AF0)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _jurusanTerpilih,
                      dropdownColor: const Color(0xFF16161A),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Program Studi',
                        labelStyle: TextStyle(color: Color(0xFF94A1B2)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF242629)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7F5AF0)),
                        ),
                      ),
                      items: _daftarJurusan
                          .map((j) => DropdownMenuItem(
                                value: j,
                                child: Text(j, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => _jurusanTerpilih = val),
                      validator: (val) => val == null ? 'Pilih jurusan' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _ipkController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'IPK',
                        labelStyle: TextStyle(color: Color(0xFF94A1B2)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF242629)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7F5AF0)),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _tglLahirTerpilih == null
                                ? 'Tanggal Lahir'
                                : 'Tanggal Lahir: ${_tglLahirTerpilih!.day}/${_tglLahirTerpilih!.month}/${_tglLahirTerpilih!.year}',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _tglLahirTerpilih ?? DateTime.now(),
                              firstDate: DateTime(1990),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Color(0xFF7F5AF0),
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF16161A),
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setDialogState(() => _tglLahirTerpilih = picked);
                            }
                          },
                          child: const Text(
                            'Pilih',
                            style: TextStyle(color: Color(0xFF7F5AF0), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Jenis Kelamin',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: _genderTerpilih,
                          activeColor: const Color(0xFF7F5AF0),
                          onChanged: (val) =>
                              setDialogState(() => _genderTerpilih = val!),
                        ),
                        const Text('Laki-laki', style: TextStyle(color: Colors.white)),
                        Radio<bool>(
                          value: false,
                          groupValue: _genderTerpilih,
                          activeColor: const Color(0xFF7F5AF0),
                          onChanged: (val) =>
                              setDialogState(() => _genderTerpilih = val!),
                        ),
                        const Text('Perempuan', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Color(0xFF94A1B2))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F5AF0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _tglLahirTerpilih != null) {
                    setState(() {
                      final mhsBaru = Mahasiswa(
                        nama: _namaController.text,
                        nim: _nimController.text,
                        jurusan: _jurusanTerpilih!,
                        ipk: double.parse(_ipkController.text),
                        tgllahir: _tglLahirTerpilih!,
                        gender: _genderTerpilih,
                      );

                      if (index == null) {
                        // notifikasi ketika Create Data
                        widget.data.add(mhsBaru);
                        _tampilkanNotifikasi(
                          "Data Berhasil Ditambah!",
                          "Mahasiswa ${_namaController.text} ditambahkan.",
                        );
                      } else {
                        // notifikasi ketika Edit/Update Data
                        widget.data[index] = mhsBaru;
                        _tampilkanNotifikasi(
                          "Data Berhasil Diperbarui!",
                          "Data ${_namaController.text} telah diubah.",
                        );
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog Form (Delete Data)
  void _hapusData(int index) {
    String namaDihapus = widget.data[index].nama;
    setState(() {
      widget.data.removeAt(index);
    });
    // notifikasi ketika delete Data
    _tampilkanNotifikasi(
      "Data Dihapus",
      "Data mahasiswa bernama $namaDihapus dihapus dari sistem.",
    );
  }

  // Function Dialog Konfirmasi Sebelum Hapus
  void _konfirmasiHapus(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16161A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF242629)),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 10),
            Text('Konfirmasi Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data dari mahasiswa bernama ${widget.data[index].nama}?',
          style: const TextStyle(color: Color(0xFF94A1B2)),
        ),
        actions: [
          // pilihan 1: Batal (Tutup dialog tanpa menghapus)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF94A1B2))),
          ),
          // pilihan 2: Ya (Tutup dialog lalu jalankan proses hapus)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context); // tutup dialog konfirmasi terlebih dahulu
              _hapusData(index); // jalankan fungsi hapus data & notifikasi
            },
            child: const Text(
              'Ya, Hapus',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17), // Premium dark background
      appBar: AppBar(
        title: const Text(
          'Mahasiswa - Arnanda S. N. P.',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
      body: widget.data.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline_rounded, size: 64, color: Color(0xFF94A1B2)),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada data mahasiswa.',
                    style: TextStyle(color: Color(0xFF94A1B2), fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                final mhs = widget.data[index];
                // Use gender-based or just general accent color
                final accentColor = mhs.gender ? const Color(0xFF7F5AF0) : Colors.pinkAccent;

                return Card(
                  color: const Color(0xFF16161A),
                  elevation: 3,
                  shadowColor: Colors.black.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFF242629), width: 1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      // Left vertical colored accent bar
                      Container(
                        width: 6,
                        height: 76,
                        color: accentColor,
                      ),
                      const SizedBox(width: 14),
                      // Main info
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/detail', arguments: mhs);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    mhs.gender ? Icons.male_rounded : Icons.female_rounded,
                                    color: accentColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mhs.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'NIM: ${mhs.nim}',
                                        style: const TextStyle(
                                          color: Color(0xFF94A1B2),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Actions
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Color(0xFF2CB67D)),
                            onPressed: () => _tampilFormDialog(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _konfirmasiHapus(index),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilFormDialog(),
        backgroundColor: const Color(0xFF2CB67D),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
