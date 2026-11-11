# 9Router Multi-Provider Unified Proxy Specification

Dokumentasi integrasi gateway perutean model AI lokal (**9Router**) yang beroperasi pada port lokal `20128`.

## 📌 Fungsi dan Peran Utama
1. **Unified Endpoint Abstraction:**
   Menggabungkan berbagai penyedia model AI (OpenAI, Gemini, Groq, Cerebras, DeepSeek/OMOP, Kimi, Minimax, SiliconFlow) ke dalam satu endpoint standar OpenAI-compatible (`http://127.0.0.1:20128/v1`).
2. **Katalog Model Terpadu:**
   Menyinkronkan katalog model multi-provider (>5.000 model terdaftar) dengan failover otomatis ke model cadangan jika penyedia utama mengalami *rate limit* atau *downtime*.
3. **Optimasi Latensi & Keamanan:**
   Berjalan lokal di dalam VPS (localhost binding), meminimalisir overhead jaringan, serta mengelola autentikasi berbasis Bearer Token dan header routing terpusat.
