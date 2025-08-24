# data-analyst-user-behavior-test
Analisis perilaku pengguna untuk technical test Data Analyst, meliputi query SQL, skrip Python, dan visualisasi.

## Deskripsi
Repositori ini berisi dokumentasi, kode, dan hasil untuk technical test Data Analyst. Dataset yang digunakan adalah `users_data`, `transactions_data`, dan `cards_data`. Analisis dilakukan untuk memperoleh insight yang berguna melalui beberapa bagian, antara lain query SQL, pembuatan dashboard, dan presentasi.

## Struktur Repo
- `code/` : SQL & Python  
  - `python/` : Preprocessing data
  - `sql/` : Query SQL untuk analisis  
- `results/` : Output analisis atau visualisasi  
- `presentation/` : File presentasi yang merangkum analisis  
- `README.md` : Penjelasan repo & cara menjalankan

## Dataset
Detail mengenai dataset dan proses pemrosesan sebelum digunakan dijelaskan lebih lanjut di file presentasi.

## Cara Menjalankan
1. Lakukan preprocessing dataset menggunakan Python
2. Upload CSV ke MySQL menggunakan `LOAD INFILE` untuk membuat tabel
3. Jalankan query SQL di MySQL untuk analisis data
4. Untuk pembuatan dashboard, gunakan hasil preprocessing dan beberapa tabel hasil export (dataset transaksi terlalu besar untuk diproses secara penuh)
5. File presentasi terletak di folder `presentation/`

## Dashboard
- Dashboard dibuat menggunakan **Looker Studio**  
- Link dashboard bisa ditambahkan di README jika sudah tersedia

## Kontak
- Nama: Sania Rizka R.
- Email: saniarizka21@gmail.com
