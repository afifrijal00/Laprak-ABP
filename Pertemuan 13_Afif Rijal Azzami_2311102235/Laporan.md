<div style="font-family: 'Times New Roman', Times, serif;">

<div align="center">
  <br />

  <h1>LAPORAN PRAKTIKUM <br>
  APLIKASI BERBASIS PLATFORM
  </h1>

  <br />

  <h3>TUGAS PERTEMUAN - 13<br>
    Praktikum Flutter — Implementasi Provider dan Notifikasi pada Flutter
  </h3>

  <br />

  <img width="182" height="182" alt="Logo Telkom University Purwokerto" src="https://github.com/user-attachments/assets/8937914f-d19f-4e65-b983-c927c8559522" />

  <br />
  <br />
  <br />

  <h3>Disusun Oleh :</h3>

  <p>
    <strong>Afif Rijal Azzami</strong><br>
    <strong>2311102235</strong><br>
    <strong>S1 IF-11-04</strong>
  </p>

  <br />

  <h3>Dosen Pengampu :</h3>

  <p>
    <strong>Cahyo Prihantoro, S.Kom., M.Eng.</strong>
  </p>

  <br />

  <h3>LABORATORIUM HIGH PERFORMANCE
  <br>FAKULTAS INFORMATIKA <br>UNIVERSITAS TELKOM PURWOKERTO <br>2026</h3>
</div>

<hr>

## 1. Penjelasan Singkat

Pada tugas **Pertemuan 13** ini, praktikum berfokus pada penerapan **State Management Provider** dan **Local Notifications** pada framework Flutter. Aplikasi yang dibangun adalah sebuah aplikasi sederhana berupa *counter* (penghitung) yang menampilkan nilai angka, di mana setiap kali angka tersebut bertambah, akan muncul notifikasi lokal pada perangkat.

Konsep utama yang diterapkan:

1. **State Management (Provider)** : Menggunakan package `provider` dengan kelas `ChangeNotifier` untuk memisahkan logika bisnis (state) dari tampilan (UI). Provider menyimpan dan mengelola nilai counter secara reaktif.
2. **Local Notifications** : Menggunakan package `flutter_local_notifications` untuk memunculkan notifikasi pop-up (push notification) di perangkat pengguna secara langsung tanpa server pihak ketiga. Notifikasi muncul dengan judul "Counter Update" dan pesan berisi nilai counter terbaru setiap kali tombol tambah ditekan.
3. **Desain Sederhana & Fungsional** : Antarmuka dibangun secara sederhana menggunakan Material Design, menampilkan identitas mahasiswa (Nama dan NIM), nilai counter di tengah layar, dan tombol aksi untuk menambah nilai.

---

## 2. Penjelasan Singkat Tiap Widget

Berikut adalah penjelasan widget utama yang digunakan dalam proyek ini:

1. **`MyApp`** (`StatelessWidget`):
   - Merupakan root widget dari aplikasi. Di dalam fungsi `main()`, `MyApp` dibungkus menggunakan `ChangeNotifierProvider` agar state dari `CounterProvider` dapat diakses oleh seluruh widget di dalam pohon aplikasi (widget tree).

2. **`CounterProvider`** (`ChangeNotifier`):
   - Kelas yang bertanggung jawab mengelola state angka (`_counter`). Terdapat fungsi `incrementCounter()` yang menaikkan nilai counter, memanggil `notifyListeners()` untuk memperbarui UI secara otomatis, dan kemudian memanggil `_showNotification()` untuk memunculkan notifikasi nilai angka terbaru ke layar HP.

3. **`MyHomePage`** (`StatelessWidget`):
   - Halaman utama aplikasi yang mengkonsumsi data dari Provider menggunakan `Provider.of<CounterProvider>(context)`.
   - Menampilkan teks identitas mahasiswa (Arnanda Setya Nosa Putra - 2311102180).
   - Menampilkan teks angka counter yang reaktif terhadap perubahan state.
   - Menggunakan `FloatingActionButton` dengan ikon tambah (`+`) yang akan mengeksekusi metode `incrementCounter()` dari Provider ketika ditekan.

---

## 3. Langkah-langkah Pembuatan Aplikasi

### Langkah 1 — Inisialisasi Project Flutter

Buat project Flutter baru di dalam direktori proyek:
```bash
flutter create provider_notif_app
```

---

### Langkah 2 — Tambahkan Dependencies di `pubspec.yaml`

Tambahkan library eksternal berikut untuk mengaktifkan fitur provider state management dan notifikasi lokal pada file `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  flutter_local_notifications: ^22.0.0
```

Setelah itu, jalankan perintah untuk mengunduh package:
```bash
flutter pub get
```

---

### Langkah 3 — Konfigurasi Izin Sistem Android

1. Buka file `android/app/src/main/AndroidManifest.xml`, tambahkan izin untuk memposting notifikasi (diperlukan untuk Android 13 ke atas) tepat di bawah tag `<manifest>`:
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
   ```

2. Buka file `android/app/build.gradle.kts`, tingkatkan `minSdk` minimal `21` dan aktifkan fitur desugaring agar kompatibel dengan library notifikasi:
   ```kotlin
   defaultConfig {
       minSdk = 21
   }
   
   compileOptions {
       isCoreLibraryDesugaringEnabled = true
   }
   
   dependencies {
       coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
   }
   ```

---

### Langkah 4 — Implementasi Source Code (`lib/main.dart`)

Berikut adalah seluruh *source code* (kode sumber) dari aplikasi yang memuat logika State Management, inisialisasi Notifikasi Lokal, serta antarmuka (UI), yang diimplementasikan pada berkas `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 1. Inisialisasi plugin notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Setup Notifikasi Lokal
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );

  // Request permission for Android 13+
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  runApp(
    // 3. Setup Provider di root aplikasi
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}

// Provider Class untuk State Management
class CounterProvider extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners(); // Update UI
    _showNotification(_counter); // Tampilkan notifikasi
  }

  // Method untuk menampilkan notifikasi lokal
  Future<void> _showNotification(int currentCounter) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'counter_channel_id',
      'Counter Notifications',
      channelDescription: 'Notifikasi setiap kali counter bertambah',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'Counter Update',
      body: 'Nilai counter saat ini: $currentCounter',
      notificationDetails: platformChannelSpecifics,
      payload: 'counter_payload',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider & Notifikasi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. Mengakses data provider
    final counterProvider = Provider.of<CounterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Provider & Notification Task'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Menampilkan Informasi Mahasiswa
            const Text(
              'Nama: Arnanda setya nosa putra',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'NIM: 2311102180',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const Text(
              'Nilai counter saat ini:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '${counterProvider.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 5. Memicu aksi tambah counter dari Provider
          counterProvider.incrementCounter();
        },
        tooltip: 'Tambah',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 4. Struktur File Proyek

Struktur folder akhir dari project aplikasi ini adalah sebagai berikut:

```text
Tugas-12-13/
├── android/
│   └── app/
│       ├── src/main/AndroidManifest.xml     ← konfigurasi izin notifikasi
│       └── build.gradle.kts                 ← konfigurasi dependencies Android
├── lib/
│   └── main.dart                            ← Entrypoint, HomePage, CounterProvider, & Logika Notif
└── pubspec.yaml                             ← dependencies proyek
```

---

## 5. Cara Menjalankan Aplikasi

1. Aktifkan **USB Debugging** pada smartphone Android Anda dan hubungkan ke laptop menggunakan kabel data.
2. Buka terminal pada folder proyek.
3. Pastikan perangkat Anda terdeteksi dengan perintah:
   ```bash
   flutter devices
   ```
4. Jalankan aplikasi ke perangkat target:
   ```bash
   flutter run -d android
   ```
5. Saat aplikasi terbuka untuk pertama kali, berikan izin ketika muncul pop-up izin untuk mengirimkan notifikasi.

---

## 6. Screenshot Hasil Tampilan

*(Tangkapan layar (screenshot) hasil pengujian diletakkan pada folder `SS`)*

<br>

<div align="center">

| No | Deskripsi Tampilan | File Gambar |
|:---:|:---|:---|
| 1 | Izin Aktifkan Notifikasi (Awal Dibuka) | <img src="SS/izin untuk aktifkan notifikasi.jpeg" width="250" /> |
| 2 | Tampilan Awal Aplikasi | <img src="SS/tampilan awal aplikasi.jpeg" width="250" /> |
| 3 | Klik Counter Pertama (Notifikasi Muncul) | <img src="SS/klik counter pertama.jpeg" width="250" /> |
| 4 | Klik Counter Kedua (Notifikasi Update) | <img src="SS/klik counter kedua.jpeg" width="250" /> |
</div>

<br>

---

## 7. Kesimpulan

Pada praktikum Pertemuan 13 ini, telah berhasil diimplementasikan:
1. **Penggunaan State Management Provider** melalui pemanfaatan kelas `ChangeNotifier` untuk memisahkan logika nilai counter dari UI dengan rapi, sehingga pembaruan UI menjadi reaktif dan efisien.
2. **Penyajian Notifikasi Lokal** secara instan menggunakan channel notifikasi yang dikonfigurasi melalui `flutter_local_notifications` tanpa memerlukan server eksternal seperti Firebase. Notifikasi dipicu langsung dari aksi di dalam Provider.
3. **Pengelolaan Konfigurasi Android Modern** dengan mengaktifkan fitur `coreLibraryDesugaringEnabled` pada Gradle dan menambahkan *permission* Android modern (`POST_NOTIFICATIONS`) agar aplikasi berjalan optimal pada OS terbaru.

</div>
