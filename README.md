# Panduan Lengkap Deployment Autonomous AI Agent & Multi-Model Routing pada Cloud VPS

[![Linux](https://img.shields.io/badge/OS-Ubuntu%2024.04%20LTS-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Kernel](https://img.shields.io/badge/Kernel-Linux%206.8.0-blue?logo=linux&logoColor=white)]()
[![Hardware](https://img.shields.io/badge/Hardware-2%20vCPU%20%7C%204GB%20RAM%20%7C%2060GB%20SSD-informational)]()
[![Proxy](https://img.shields.io/badge/Proxy-9Router%20Port%2020128-success)]()
[![Status](https://img.shields.io/badge/Status-Production%20Verified-brightgreen)]()

Repositori ini memuat **panduan komprehensif, arsitektur infrastruktur, analisis biaya (*cost efficiency*), serta tutorial instalasi *step-by-step* dari nol** untuk membangun dan menjalankan sistem **Autonomous LLM Agent (Hermes Agent)** pada server **Cloud VPS**.

Sistem ini didesain agar dapat melayani asisten cerdas pribadi yang aktif 24/7 melalui bot Telegram, terintegrasi dengan gateway proxy perutean multi-model lokal (**9Router**), memiliki basis data memori persisten di SSD lokal, serta mampu mengakses alat eksternal (ekstraksi berkas dokumen, mesin OCR lokal, dan pencarian basis data jurnal ilmiah).

---

## 💡 Mengapa Menggunakan Cloud VPS Dibandingkan Laptop Pribadi?

Banyak pemula yang ragu apakah sebaiknya menjalankan agent AI di laptop pribadi atau menyewa server Cloud VPS. Berikut adalah analisis perbandingan teknis dan finansialnya:

### 1. Tabel Perbandingan: Cloud VPS vs Laptop Lokal

| Parameter Evaluasi | Menjalankan di Laptop Lokal | Menjalankan di Cloud VPS (Lighthouse / Hetzner) |
|:---|:---|:---|
| **Ketersediaan (*Uptime*)** | Terbatas (Agent mati jika laptop di-shutdown, sleep, atau dibawa bepergian) | **Aktif 24/7/365 Nonstop** di data center dengan jaminan uptime 99.9% |
| **Konektivitas Jaringan** | Bergantung pada Wi-Fi/Hotspot (IP berubah-ubah, sering RTO) | **IP Publik Statis & Bandwidth Dedicated** (kecepatan unduh/unggah gigabit) |
| **Beban & Masa Pakai Hardware** | Baterai cepat aus, suhu CPU/GPU panas jika daemon standby terus | **Beban komputasi dipindahkan ke server**, laptop tetap dingin dan awet |
| **Konsumsi Daya Listrik** | Laptop menyedot listrik rumah 45W–150W non-stop 24 jam | **Nol tagihan listrik rumah tambahan** |
| **Akses Multi-Device** | Bot Telegram hanya merespons jika laptop menyala | **Bisa diakses dari mana saja** (lewat HP Android/iOS, tablet, atau laptop) |

### 2. Analisis Estimasi Biaya (*Cost Comparison*)

Menyewa VPS hemat daya (seperti Tencent Cloud Lighthouse atau Hetzner Cloud) saat ini jauh lebih ekonomis dibandingkan depresiasi baterai laptop:

* **Biaya VPS 2 vCPU / 4 GB RAM / 60 GB SSD:**
  * Biaya sewa: Sekitar **Rp 65.000 – Rp 120.000 / bulan** (atau ~$4 – $8 USD/bulan).
  * Kuota lalu lintas data: Rata-rata 1.000 GB – 1.500 GB / bulan (sangat berlebih untuk kebutuhan teks dan bot).
* **Biaya Listrik & Baterai Laptop Standby 24 Jam:**
  * Konsumsi daya rata-rata laptop gaming/kerja (standby + daemon): $\approx 45\text{ Watt} \times 24\text{ jam} \times 30\text{ hari} \approx 32,4\text{ kWh}$.
  * Biaya listrik PLN (tarif R-1/1300VA): $\approx \text{Rp } 47.000 / \text{bulan}$.
  * Risiko penggantian baterai laptop yang drop akibat dicolok terus menerus: $\approx \text{Rp } 600.000 – \text{Rp } 1.200.000$.
* **Kesimpulan:** Dengan menyewa VPS, Anda mendapatkan keandalan server kelas industri 24 jam dengan selisih biaya yang sangat kecil dan efisien.

---

## 🧠 Model Kecerdasan Buatan (LLM) yang Digunakan

Salah satu keunggulan arsitektur ini adalah **pemisahan antara server eksekusi dan server inferensi model**. VPS bertindak sebagai *otak penggerak (runtime agent)*, sedangkan beban inferensi dialihkan ke endpoint perutean cerdas melalui **9Router** pada port `127.0.0.1:20128`.

### 1. Karakteristik Model Utama:
* **DeepSeek V4 / V3 Flash (Uncensored / Fast Tier):**
  * Model bahasa berkecepatan tinggi dengan efisiensi token luar biasa.
  * Sangat responsif dalam mengeksekusi instruksi *tool-calling* (menjalankan perintah terminal, membaca file, menulis script, dan kalkulasi).
  * Menawarkan jendela konteks (*context window*) yang luas dengan latensi *Time-to-First-Token* (TTFT) di bawah 1 detik.
* **Integrasi Multi-Model (Failover Routing):**
  * Berkat **9Router**, sistem terhubung ke katalog lebih dari 5.000 model AI dari puluhan penyedia (OpenAI, Google Gemini, Groq, Cerebras, Kimi, Minimax).
  * Jika penyedia utama mengalami gangguan atau *rate limit*, 9Router secara cerdas mengalihkan permintaan ke model cadangan tanpa membuat bot mengalami *crash*.

---

## 💰 Analisis Biaya Token Model AI, Daftar Penyedia & Simulasi Pengeluaran Bulanan

Salah satu pertimbangan krusial bagi pemula maupun pengembang adalah **berapa biaya token API yang harus dikeluarkan setiap bulan untuk mengoperasikan AI Agent ini secara aktif?**

Melalui gateway proxy **9Router**, sistem ini dapat terhubung ke berbagai penyedia model terkemuka di dunia (*multi-provider*). Berikut adalah rincian harga pasar resmi per 1 juta token (1M tokens) dan simulasi perhitungan biaya operasional per bulannya.

---

### 1. Tabel Perbandingan Harga Model Populer (Tarif per 1 Juta Token)

> *Catatan: 1 Juta Token setara dengan sekitar 750.000 kata (setara dengan membaca atau menulis ~1.500 halaman naskah).*

| Nama Model AI | Penyedia Resmi / Provider | Harga Input (per 1M Token) | Harga Output (per 1M Token) | Keunggulan & Kasus Penggunaan Utama |
|:---|:---|:---:|:---:|:---|
| **DeepSeek V3 / V4 Flash** *(Model Utama Repo Ini)* | DeepSeek Official / OMOP | **$0.14** (~Rp 2.200) | **$0.28** (~Rp 4.400) | **Super Ekonomis & Cepat:** Sangat cerdas dalam coding, tool-calling terminal, dan jendela konteks luas. |
| **Google Gemini 1.5 Flash** | Google Cloud / AI Studio | **$0.075** (~Rp 1.200) | **$0.30** (~Rp 4.700) | **Latensi Terendah & Multimodal:** Ideal untuk pemrosesan teks cepat dan ekstraksi berkas besar. |
| **Meta Llama 3.3 70B** | Groq / Cerebras / Together | **$0.59** (~Rp 9.400) | **$0.79** (~Rp 12.600) | **Kecepatan Ekstrem (Inference Engine LPUs):** Respon nyaris seketika (*instant streaming*). |
| **OpenAI GPT-4o Mini** | OpenAI Official | **$0.15** (~Rp 2.400) | **$0.60** (~Rp 9.600) | **Standar Industri Berimbang:** Sangat konsisten dalam format output JSON/YAML. |
| **OpenAI GPT-4o (Omni Flagship)** | OpenAI Official | **$2.50** (~Rp 40.000) | **$10.00** (~Rp 160.000) | **Reasoning Kelas Berat:** Untuk pemecahan soal logika rumit dan perancangan paper ilmiah kompleks. |
| **Anthropic Claude 3.5 Sonnet** | Anthropic / AWS Bedrock | **$3.00** (~Rp 48.000) | **$15.00** (~Rp 240.000) | **Kualitas Bahasa & Coding Tertinggi:** Standar tertinggi industri untuk arsitektur software. |

---

### 2. Simulasi Perhitungan Biaya Bulanan (Estimasi Nyata Pemakaian Aktif)

Misalkan sistem beroperasi setiap hari untuk melayani tugas kuliah, penulisan script, diskusi teknis, dan manajemen server Telegram:

#### Skenario Beban Pemakaian Harian (Intensive Student / Developer Usage):
* **Rata-rata Percakapan Harian:** 30 kali interaksi intensif per hari (chat tanya jawab + eksekusi tool terminal/script).
* **Konsumsi Token Harian:**
  * Token Masukan (*Input Prompt + Context Memory*): $\approx 400.000\text{ token / hari}$.
  * Token Keluaran (*Output Response & Code Generation*): $\approx 50.000\text{ token / hari}$.
* **Akumulasi Konsumsi per Bulan (30 Hari):**
  * Total Input: $400.000 \times 30 = \mathbf{12\text{ Juta Token Input / bulan}}$.
  * Total Output: $50.000 \times 30 = \mathbf{1,5\text{ Juta Token Output / bulan}}$.

---

### 3. Rekapitulasi Total Biaya Bulanan (Sewa VPS + Token Model AI)

#### Pilihan A: Menggunakan DeepSeek V4/V3 Flash *(Konfigurasi Standar Rekomendasi)*
1. **Biaya Token AI (DeepSeek Flash):**
   * Biaya Input: $12\text{ M} \times \$0.14 = \$1.68$
   * Biaya Output: $1.5\text{ M} \times \$0.28 = \$0.42$
   * **Subtotal Token:** $\$2.10\text{ USD}$ (atau **$\approx \text{Rp } 33.600 / \text{bulan}$**).
2. **Biaya Server VPS (Tencent Cloud / Hetzner 2 vCPU 4GB):**
   * **Subtotal VPS:** $\approx \text{Rp } 85.000 / \text{bulan}$.
3. **TOTAL PENGELUARAN BULANAN (Pilihan A):**
   $$\text{Total} = \text{Rp } 85.000 + \text{Rp } 33.600 = \mathbf{\approx \text{Rp } 118.600\text{ / bulan}}$$
   *(Dengan biaya sekitar Rp 118 ribu per bulan, Anda memiliki asisten AI cerdas berkapasitas tinggi yang melayani Anda 24 jam nonstop di Telegram).*

#### Pilihan B: Menggunakan Model Premium Flagship (GPT-4o / Claude 3.5 Sonnet)
1. **Biaya Token AI (GPT-4o Mini untuk tugas rutin + Claude 3.5 Sonnet untuk tugas berat):**
   * Menggunakan strategi *hybrid routing*: 80% query ditangani model cepat dan 20% query diarahkan ke model flagship.
   * **Subtotal Token:** $\approx \$8.50\text{ USD}$ (**$\approx \text{Rp } 136.000 / \text{bulan}$**).
2. **Biaya Server VPS:** $\approx \text{Rp } 85.000 / \text{bulan}$.
3. **TOTAL PENGELUARAN BULANAN (Pilihan B):**
   $$\text{Total} = \text{Rp } 85.000 + \text{Rp } 136.000 = \mathbf{\approx \text{Rp } 221.000\text{ / bulan}}$$

---

### 4. Tips Efisiensi Anggaran bagi Pemula

1. **Manfaatkan Fitur *Context Compaction* Hermes:**  
   Aktifkan fitur kompresi riwayat sesi (`compression.enabled: true` dengan ambang `0.85`) agar token obrolan lama otomatis diringkas menjadi rangkuman padat. Ini menghemat hingga **40–50% biaya token input**.
2. **Routing Model Berjenjang via 9Router:**  
   Gunakan model gratis atau ultra-murah (seperti Gemini 1.5 Flash atau DeepSeek Flash) untuk tugas sehari-hari, dan alihkan ke model penalaran tinggi (*reasoning models*) hanya saat memecahkan kalkulasi teknik rumit.
3. **Isolasi Memori Lokal:**  
   Karena memori fakta disimpan dalam file lokal (`USER.md` dan `MEMORY.md`), Anda tidak perlu membayar biaya basis data vektor pihak ketiga (*Zero Vector DB SaaS Cost*).


---

## 🏛️ Arsitektur Sistem

```text
                                  ┌──────────────────────────────┐
                                  │      Klien Pengguna          │
                                  │   (Aplikasi Telegram / HP)   │
                                  └──────────────┬───────────────┘
                                                 │ TLS / HTTPS Webhook
                                                 ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│ UBUNTU CLOUD VPS SERVER (2 vCPU, 4GB RAM, 60GB SSD)                                             │
│                                                                                                 │
│  ┌────────────────────────────────────────────────────────┐                                     │
│  │  Hermes Agent Gateway & Process Daemon                 │                                     │
│  │  • Session State & Event Loop                          │                                     │
│  │  • Context Compaction Engine (Threshold: 85%)          │                                     │
│  │  • Dual-tier Persistent Memory (USER.md / MEMORY.md)   │                                     │
│  └───────────────────────────┬────────────────────────────┘                                     │
│                              │ HTTP Localhost Routing                                           │
│                              ▼                                                                  │
│  ┌────────────────────────────────────────────────────────┐                                     │
│  │  9Router Local Unified Proxy Gateway (Port: 20128)     │                                     │
│  │  • Multi-Provider Endpoint Abstraction                 │                                     │
│  │  • Dynamic Model Failover & Rate-Limit Handling        │                                     │
│  │  • Centralized Catalog Sync (>5.000 Model Terdaftar)   │                                     │
│  └──────────────┬────────────────────────────┬────────────┘                                     │
│                 │                            │                                                  │
└─────────────────┼────────────────────────────┼──────────────────────────────────────────────────┘
                  │ HTTPS Outbound             │ HTTPS Outbound
                  ▼                            ▼
   ┌──────────────────────────────┐    ┌──────────────────────────────┐
   │ AI Model Provider Endpoints  │    │ Academic Research APIs       │
   │ (OpenAI, Gemini, Groq,       │    │ • OpenAlex API               │
   │  Cerebras, OMOP/DeepSeek)    │    │ • Semantic Scholar API       │
   └──────────────────────────────┘    └──────────────────────────────┘
```

---

## 📖 Tutorial Instalasi Lengkap dari Nol (Step-by-Step untuk Pemula)

Panduan berikut dirancang agar siapa saja dengan sistem operasi **Ubuntu 22.04 / 24.04 LTS** dapat menduplikasi sistem ini secara mandiri:

### Langkah 1: Persiapan Server VPS & Update Paket
Masuk ke terminal VPS Anda melalui SSH:
```bash
ssh ubuntu@IP_VPS_ANDA
```
Perbarui repositori sistem dan pasang dependensi esensial:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git build-essential python3 python3-pip python3-venv poppler-utils tesseract-ocr
```

### Langkah 2: Instalasi Node.js Lingkungan Gateway
Gateway dan proxy perutean membutuhkan Node.js (direkomendasikan Node.js LTS v20 atau v22):
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v   # Pastikan output v20.x.x
```

### Langkah 3: Instalasi & Konfigurasi 9Router Local Gateway
Pasang paket 9Router secara global untuk menyatukan seluruh API model AI:
```bash
sudo npm install -g 9router

# Jalankan 9Router pada port 20128 di latar belakang (background)
nohup 9router -p 20128 --skip-update > ~/9router.log 2>&1 &
```
Periksa apakah 9Router sudah aktif berjalan:
```bash
ss -tuln | grep 20128
# Jika muncul ':20128', gateway proxy telah aktif!
```

### Langkah 4: Setup Hermes Autonomous Agent
Pasang dan inisialisasi lingkungan Hermes Agent di direktori home:
```bash
# Clone atau inisialisasi lingkungan Hermes
mkdir -p ~/.hermes
cd ~/.hermes

# Unduh template konfigurasi dari repositori ini
wget https://raw.githubusercontent.com/Xloress/cloud-vps-llm-agent-deployment/main/configs/config_template.yaml -O ~/.hermes/config.yaml
```

Edit file `~/.hermes/config.yaml` menggunakan editor teks (misal: `nano ~/.hermes/config.yaml`) dan masukkan API Key penyedia Anda pada bagian:
```yaml
model:
  default: "Omop/deepseek-v4.1-flash-UNSENSORED"
  provider: "custom"
  base_url: "http://127.0.0.1:20128/v1"
  api_key: "MASUKKAN_API_KEY_ANDA_DI_SINI"
```

### Langkah 5: Menghubungkan ke Bot Telegram
Agar agent dapat diakses dari smartphone Anda:
1. Buka Telegram dan hubungi `@BotFather` untuk membuat bot baru (`/newbot`).
2. Dapatkan **HTTP API Bot Token** dari BotFather.
3. Hubungkan token tersebut ke profil Hermes:
```bash
hermes platform connect telegram
# Masukkan token bot Telegram Anda saat diminta
```

Jalankan gateway agent di latar belakang:
```bash
nohup hermes gateway run > ~/hermes_gateway.log 2>&1 &
```

Sekarang bot Telegram Anda sudah hidup 24/7 dan didukung oleh mesin Linux VPS!

---

## 📂 Struktur Repositori

```text
├── configs/
│   ├── config_template.yaml         # Template konfigurasi produksi Hermes Agent (sanitized)
│   └── 9router_spec.md              # Spesifikasi teknis & perutean gateway 9Router
├── scripts/
│   └── system_health_check.sh       # Skrip diagnostik otomatis kesehatan VPS & Daemon
└── README.md
```

---

## 🛠️ Pemantauan & Diagnostik Sistem

Untuk memeriksa apakah seluruh sistem berjalan normal, repositori ini telah dilengkapi dengan skrip diagnostik otomatis `scripts/system_health_check.sh`.

Jalankan perintah ini kapan saja untuk melihat kesehatan server Anda:
```bash
bash scripts/system_health_check.sh
```

### Contoh Hasil Audit Nyata Sistem:
```text
=================================================================
   AUTONOMOUS AGENT & VPS CLOUD INFRASTRUCTURE HEALTH AUDIT      
   Host: VM-0-12-ubuntu | Date: 2026-11-11 20:43:33 CST     
=================================================================

[1] Sistem Operasi & Kernel:
Linux 6.8.0-138-generic x86_64 GNU/Linux
Description:	Ubuntu 24.04.5 LTS

[2] Beban Komputasi CPU & Uptime:
 20:43:33 up 4 days,  7:37,  0 user,  load average: 0.10, 0.11, 0.09

[3] Pemanfaatan Memori RAM (Target: < 2.0 GB used):
               total        used        free      shared  buff/cache   available
Mem:           3.6Gi       1.1Gi       1.1Gi       1.8Mi       1.7Gi       2.5Gi
Swap:          1.9Gi        48Mi       1.9Gi

[4] Kapasitas Penyimpanan SSD NVMe (Target: < 50% usage):
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda2        59G   15G   42G  26% /

[5] Pemeriksaan Status Proses Latar Belakang (Daemons):
  [✓] 9Router Local Gateway : RUNNING (PID: 1448989, Port: 20128)
  [✓] Hermes Agent Gateway  : RUNNING (PID: 1449022)

[6] Pemeriksaan Konektivitas Soket Jaringan:
  [✓] Soket Gateway 9Router (Port 20128) aktif merespons koneksi lokal.

=================================================================
 [✓] Diagnostik infrastruktur selesai dijalankan tanpa anomali.
=================================================================
```

---

## 🛡️ Keamanan & Perlindungan Privasi

* **Sanitized Configurations:** Seluruh file repositori ini bebas dari kata sandi, token bot, maupun API key rahasia.
* **Localhost Socket Binding:** Port 9Router (`20128`) terikat secara lokal (`127.0.0.1`), sehingga tidak dapat diakses atau disusupi dari jaringan publik internet tanpa melalui otentikasi SSH tunneling.
