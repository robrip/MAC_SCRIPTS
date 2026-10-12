# 🧠 **ROBRip CIDR Analyzer v3**  

### **Terminal‑Only CIDR Normalizer, Sorter, Risk Analyzer & Private‑Range Sentinel**

**ROBRip CIDR Analyzer v3** is a high‑speed, terminal‑only IP/CIDR analysis tool for macOS.  
It ingests a raw list of IPs and CIDRs, normalizes them, sorts them, groups them into blocks, and produces a detailed risk‑scored summary — including **critical private‑range detection** for entries that should *never* appear in external datasets.

This script is designed for security engineers, network analysts, and anyone who needs fast, offline, zero‑dependency CIDR intelligence.

---

## ⚡ **What This Script Does**

### 🔄 1. Normalizes Input  
Every line is processed:

- If it contains a CIDR (`x.x.x.x/24`) → kept as‑is  
- If it’s a bare IP (`x.x.x.x`) → converted to `/32`  

Example from the script:  
> `if echo "$LINE" | grep -q "/"; then echo "$LINE"; else echo "$LINE/32"; fi` 

---

### 📚 2. Sorts All Entries  
Entries are sorted numerically by octet, ensuring clean grouping:

> `sort -t. -k1,1n -k2,2n -k3,3n -k4,4n` 

---

### 🧩 3. Computes Network Blocks  
For each entry, the script:

- Converts IP → integer  
- Computes netmask  
- Derives the canonical network address  
- Reconstructs the normalized CIDR  

Example:  
> `NETWORK=$(( INT & NETMASK ))` 

---

### 📊 4. Builds Per‑CIDR Summaries  
Each CIDR block includes:

- Total IPs  
- Usable IPs  
- Count of IPs observed in the dataset  
- Severity score (Low → Critical)  
- Flashing warning icon for dangerous ranges  
- Color‑coded output for readability

Severity logic is based on usable IP count.

---

### 🚨 5. Detects Private Ranges (Critical Flag)  
If a CIDR falls into:

- `10.0.0.0/8`  
- `172.16.0.0/12`  
- `192.168.0.0/16`  

It is **automatically escalated to Critical**, regardless of size.

From the script:  
> `🚨 PRIVATE RANGE DETECTED — SHOULD NOT APPEAR HERE 🚨` 

This is extremely useful for threat intel feeds, external scans, or any dataset where private ranges indicate contamination or misconfiguration.

---

### 📑 6. Produces a Summary Footer  
At the end, you get:

- Total CIDRs  
- Total usable IPs  
- Count of dangerous blocks  
- Highest‑risk CIDR  
- Highest usable IP count  

Example:  
> `echo -e "   • Total CIDRs: $TOTAL_CIDRS"` 

---

## 🖥️ **Usage**

### **Input File Format**
A plain text file containing:

```
8.8.8.8
1.1.1.0/24
192.168.1.10
10.0.0.0/8
```

Bare IPs are automatically converted to `/32`.

---

### **Run the Analyzer**

```bash
chmod +x ip_cleaner_v4_terminal_only_editing.sh
./ip_cleaner_v4_terminal_only_editing.sh my_ips.txt
```

If no file is provided, the script exits with:

> `Error: Provide a valid file of IPs + CIDRs` 

---

## 🧪 **Example Output (Conceptual)**

```
🧩  8.8.8.0/24
   • IPs in this block:        12
   • Usable IPs:              254
   • Risk: ████░ (High)
   This CIDR contains 256 ⚠️ total IPs.
```

Private ranges produce a flashing warning and a critical banner.

---

## 🛡️ **Why This Tool Exists**

This script is built for:

- Threat intelligence ingestion  
- External scan validation  
- CIDR hygiene checks  
- Rapid forensic triage  
- Detecting private‑range contamination  
- Sorting chaotic IP lists into meaningful blocks  

It is intentionally **terminal‑only**, **dependency‑free**, and **fast**.

---

## 🎨 Branding

Part of the **CLAUDEWAD / ROBRip** suite — neon‑loud, forensic, unapologetically diagnostic.

---

## 📄 License

ROBRip OpenSource