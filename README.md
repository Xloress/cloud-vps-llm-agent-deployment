# Deployment, API Routing & Lifecycle Management of Autonomous LLM Agent on Cloud VPS

Dokumentasi arsitektur, manajemen siklus hidup sistem, dan perutean API multi-model untuk implementasi **Autonomous Agent (Hermes Agent)** pada server **Ubuntu VPS (Tencent Cloud - 2 vCPU, 4GB RAM, 60GB SSD)**.

Sistem ini beroperasi 24/7 sebagai asisten operasional cerdas yang terhubung langsung ke antarmuka komunikasi bot Telegram, penyedia model bahasa (LLM), API pencarian basis data akademik (Semantic Scholar & OpenAlex), serta basis memori lokal terstruktur.

---

## 🏛️ Arsitektur Sistem

```text
┌─────────────────┐       HTTPS / Webhook       ┌────────────────────────────────┐
│ Telegram Client │ ──────────────────────────> │ Hermes Gateway & Daemon (VPS)  │
└─────────────────┘                             └────────────────────────────────┘
                                                                │
                                      ┌─────────────────────────┴─────────────────────────┐
                                      ▼                                                   ▼
                       ┌──────────────────────────────┐                    ┌──────────────────────────────┐
                       │ Multi-Model API Routing      │                    │ Local Toolset & Execution    │
                       │ (Custom Providers & LLMs)    │                    │ (Python Kernel, Linux Shell, │
                       │ • Context Compaction         │                    │  OCR, SQLite/Memory Layers)  │
                       └──────────────────────────────┘                    └──────────────────────────────┘
```

---

## ⚙️ Karakteristik & Spesifikasi Deployment

* **Infrastruktur Server:** Ubuntu 24.04 LTS (Kernel Linux 6.8), 2 vCPU, 4 GB RAM, 60 GB NVMe SSD.
* **Protokol Komunikasi:** Telegram Bot API via TLS terenkripsi dengan penanganan sesi pesan mandiri.
* **Manajemen Sumber Daya (Resource Constraints):**
  * Optimasi footprint memori (< 1.5 GB RAM terpakai saat beban normal).
  * Mekanisme *Context Compaction* otomatis untuk mencegah degradasi jendela konteks percakapan panjang.
  * Proteksi eksekusi latar belakang (*safe sub-process monitoring*).
* **Integrasi Alat Eksternal (Extensible Toolsets):**
  * Pencarian literatur peer-reviewed secara programmatic (OpenAlex / Semantic Scholar API).
  * Ekstraksi dokumen multi-format (PDF, DOCX, XLSX, Jupyter Notebook `.ipynb`).
  * Mesin OCR lokal (*Tesseract & Poppler*) untuk membaca naskah cetak dan lembar ujian tanpa ketergantungan cloud visi berbayar.

---

## 📂 Struktur Repositori

```text
├── scripts/
│   └── system_health_check.sh       # Skrip pemantauan kesehatan CPU, RAM, & Disk server
├── configs/
│   └── architecture_spec.md         # Catatan spesifikasi modul & lifecycle hooks
└── README.md
```
