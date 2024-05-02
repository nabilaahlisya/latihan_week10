import 'dart:convert';

void main() {
  // Data transkrip mahasiswa dalam format JSON
  String transkripJson = '''
  {
    "nama": "Nabila Ahlisya",
    "npm": "22082010017",
    "mata kuliah": [
      {
        "kode_mk": "MK001",
        "nama_mk": "E Bussiness",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode_mk": "MK002",
        "nama_mk": "Pemograman Mobile",
        "sks": 3,
        "nilai": "B+"
      },
      {
        "kode_mk": "MK003",
        "nama_mk": "Statistika Komputasi",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode_mk": "MK004",
        "nama_mk": "Kepemimpinan",
        "sks": 2,
        "nilai": "A"
      },
      {
        "kode_mk": "MK005",
        "nama_mk": "Bahasa Inggris",
        "sks": 2,
        "nilai": "A"
      }
    ]
  }
  ''';

  // Parse JSON ke dalam bentuk Map
  Map<String, dynamic> transkrip = json.decode(transkripJson);

  // Menampilkan rincian transkrip nilai
  print('Rincian Transkrip Nilai:');
  for (var mataKuliah in transkrip['mata kuliah']) {
    print('Mata Kuliah: ${mataKuliah['nama_mk']}');
    print('Kode MK: ${mataKuliah['kode_mk']}');
    print('SKS: ${mataKuliah['sks']}');
    print('Nilai: ${mataKuliah['nilai']}');
    print('');
  }

  // Menghitung IPK
  double ipk = hitungIPK(List<Map<String, dynamic>>.from(transkrip['mata kuliah']));

  // Menampilkan hasil IPK di debug console
  print('IPK: ${ipk.toStringAsFixed(2)}');
}

// Fungsi untuk menghitung IPK
double hitungIPK(List<Map<String, dynamic>> transkripNilai) {
  double totalNilai = 0;
  int totalSks = 0;

  for (var mataKuliah in transkripNilai) {
    int sks = mataKuliah['sks'];
    totalSks += sks;

    String nilai = mataKuliah['nilai'];
    double nilaiAngka = konversiNilaiKeAngka(nilai);

    totalNilai += nilaiAngka * sks;
  }

  return totalNilai / totalSks;
}

// Fungsi untuk mengonversi nilai huruf ke nilai angka
double konversiNilaiKeAngka(String nilaiHuruf) {
  switch (nilaiHuruf) {
    case 'A':
      return 4.0;
    case 'A-':
      return 3.7;
    case 'B+':
      return 3.3;
    case 'B':
      return 3.0;
    case 'B-':
      return 2.7;
    case 'C+':
      return 2.3;
    case 'C':
      return 2.0;
    case 'C-':
      return 1.7;
    case 'D':
      return 1.0;
    default:
      throw Exception('Nilai tidak valid: $nilaiHuruf');
  }
}
