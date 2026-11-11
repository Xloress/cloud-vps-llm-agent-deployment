# Deployment, API Routing & Lifecycle Management of Autonomous LLM Agent on Cloud VPS

Dokumentasi arsitektur, konfigurasi perutean multi-penyedia API (*Multi-Provider Routing*), dan pemantauan sistem produksi untuk **Autonomous Agent (Hermes Agent)** yang di-deploy pada server **Ubuntu VPS (Tencent Cloud - 2 vCPU, 4GB RAM, 60GB SSD)**.

Sistem ini beroperasi 24/7 sebagai asisten operasional cerdas dengan integrasi langsung ke antarmuka bot Telegram, gateway proxy model lokal (**9Router**), API basis data literatur akademik (Semantic Scholar & OpenAlex), serta basis memori lokal terstruktur.

---

## 🏛️ Arsitektur Infrastruktur Sistem

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

## ⚙️ Spesifikasi & Karakteristik Teknis VPS

* **Spesifikasi Server:** Ubuntu 24.04 LTS (Kernel Linux 6.8), 2 vCPU x86_64, 4 GB RAM, 60 GB NVMe SSD.
* **Alokasi Sumber Daya (*Resource Budget*):**
  * Penggunaan RAM operasional normal: $\approx 1,2\text{ GB} - 1,5\text{ GB}$ (sisa memori bebas $\approx 2,4\text{ GB}$).
  * Kapasitas penyimpanan terpakai: $\approx 15\text{ GB}$ ($26\%$ dari total kuota SSD 60 GB).
* **Komponen Gateway:**
  1. **9Router Local Daemon (`/usr/lib/node_modules/9router`):**
     * Berjalan sebagai proses *background* lokal pada port `127.0.0.1:20128`.
     * Menyediakan antarmuka tunggal berstandar OpenAI `/v1/chat/completions` dengan kemampuan pengalihan rute dinamis (*intelligent routing*) antar penyedia API.
  2. **Hermes Core Gateway:**
     * Menjalankan daemon sesi interaktif terisolasi, sandboxing eksekusi terminal lokal, dan perlindungan loop perintah (*tool loop guardrails*).

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

## 🛠️ Diagnostik & Pemantauan Sistem

Repositori ini menyertakan skrip audit kesehatan server otomatis di `scripts/system_health_check.sh` yang memeriksa 6 parameter operasional:
1. Versi sistem operasi dan rilis kernel Linux.
2. Beban rata-rata CPU (*load average*) dan durasi *uptime*.
3. Pemanfaatan memori RAM dan ruang swap.
4. Utilisasi partisi penyimpanan SSD NVMe.
5. Status keaktifan proses daemon `9router` dan `hermes gateway`.
6. Pemindaian konektivitas soket jaringan lokal pada port `20128`.

Cara menjalankan diagnostik mandiri:
```bash
bash scripts/system_health_check.sh
```
