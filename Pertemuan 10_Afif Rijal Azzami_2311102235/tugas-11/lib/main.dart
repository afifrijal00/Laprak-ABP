import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/mahasiswa_screen.dart';
import 'screens/detail_mahasiswa_screen.dart';
import 'models/mahasiswa_model.dart';
import 'screens/statistik_mahasiswa_screen.dart';

// Deklarasi Variabel Global yang dapat diakses oleh file lain
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final List<String> logNotifikasi = []; // List penyimpan log riwayat aktivitas

// Pre-populasi data mahasiswa untuk Arnanda Setya Nosa Putra
final List<Mahasiswa> dataMahasiswa = [
  Mahasiswa(
    nama: "Arnanda Setya Nosa Putra",
    nim: "2311102180",
    jurusan: "Teknik Informatika",
    ipk: 4.0,
    tgllahir: DateTime(2005, 1, 1),
    gender: true,
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );

  // Minta izin notifikasi untuk Android 13 ke atas (API 33+)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas 11 - Arnanda Setya Nosa Putra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7F5AF0),
          secondary: Color(0xFF2CB67D),
          background: Color(0xFF0F0E17),
          surface: Color(0xFF16161A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // routing halaman
        '/': (context) => const MainNavigation(),
        '/detail': (context) => const DetailPage(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CrudMahasiswaPage(
            data: dataMahasiswa,
          ), // kirim dataMahasiswa ke halaman crud
          const RiwayatLogPage(),
          StatistikPage(
            data: dataMahasiswa,
          ), // kirim dataMahasiswa ke halaman statistik
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: const Color(0xFF242629), width: 1.5),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF16161A),
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF2CB67D),
          unselectedItemColor: const Color(0xFF94A1B2),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded), 
              activeIcon: Icon(Icons.people_alt_rounded, color: Color(0xFF2CB67D)),
              label: 'Mahasiswa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_rounded),
              activeIcon: Icon(Icons.history_edu_rounded, color: Color(0xFF2CB67D)),
              label: 'Riwayat Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_rounded),
              activeIcon: Icon(Icons.analytics_rounded, color: Color(0xFF2CB67D)),
              label: 'Statistik',
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET HALAMAN MENU KEDUA: LOG RIWAYAT NOTIFIKASI
class RiwayatLogPage extends StatelessWidget {
  const RiwayatLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        title: const Text(
          'Riwayat - Arnanda S. N. P.',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F5AF0), Color(0xFF2CB67D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: logNotifikasi.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded, size: 64, color: Color(0xFF94A1B2)),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat aktivitas sistem.',
                    style: TextStyle(color: Color(0xFF94A1B2), fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: logNotifikasi.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF16161A),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF242629)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0x1A2CB67D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.circle_notifications_rounded,
                        color: Color(0xFF2CB67D),
                        size: 24,
                      ),
                    ),
                    title: Text(
                      logNotifikasi[index],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
