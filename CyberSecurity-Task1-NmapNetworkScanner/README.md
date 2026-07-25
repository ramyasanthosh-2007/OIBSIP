# 🛡️ Task 1 – Basic Network Scanning with Nmap

!\[Nmap](https://img.shields.io/badge/Tool-Nmap-blue)
!\[Kali Linux](https://img.shields.io/badge/OS-Kali%20Linux-557C94)
!\[Target](https://img.shields.io/badge/Target-Metasploitable2-orange)
!\[Internship](https://img.shields.io/badge/Internship-Oasis%20Infobyte-9146FF)
!\[Status](https://img.shields.io/badge/Status-Completed-brightgreen)
!\[License](https://img.shields.io/badge/License-MIT-lightgrey)

\---

## 📖 1. Project Overview

This repository documents a hands-on network reconnaissance exercise completed as **Task 1** of the **Oasis Infobyte Security Analyst Internship**. The objective was to scan a locally hosted, intentionally vulnerable virtual machine using **Nmap**, identify its open ports and running services, determine its operating system, and analyze the security implications of the findings.

The scan was performed entirely within an isolated virtual lab, using **Kali Linux** as the attacking machine and **Metasploitable2** as the target — a deliberately vulnerable VM built specifically for security training. This project reflects the reconnaissance phase of a real-world penetration test, documented to a professional reporting standard.

\---

## 🎯 2. Objectives

* Set up an isolated local lab consisting of an attacker VM and a target VM
* Perform a basic Nmap port scan to identify open ports
* Perform a service/version detection scan to fingerprint running software
* Perform OS detection to identify the target's operating system
* Analyze each open port for its associated security risk
* Document the entire process to a professional, reproducible standard

\---

## 🧰 3. Technologies \& Tools Used

|Tool / Technology|Purpose|
|-|-|
|Kali Linux|Attacker machine, running Nmap|
|Metasploitable2|Intentionally vulnerable target VM|
|Oracle VirtualBox|Virtualization platform hosting both VMs|
|Nmap 7.95|Network scanning and service enumeration|
|Markdown|Documentation format|

\---

## 🖥️ 4. Lab Environment

|Component|Detail|
|-|-|
|Attacker OS|Kali Linux (VirtualBox VM)|
|Target OS|Metasploitable2 (VirtualBox VM)|
|Target IP|`192.168.56.101`|
|Network Mode|VirtualBox Host-Only Adapter|
|Internet Exposure|None — fully isolated lab network|

\---

## 🌐 5. Network Topology

```
 ┌────────────────────────────────────────────────────────────┐
 │                      Host Machine                          │
 │                                                              │
 │   ┌──────────────────────────────────────────────────┐     │
 │   │        VirtualBox Host-Only Network               │     │
 │   │              (192.168.56.0/24)                     │     │
 │   │                                                     │     │
 │   │   ┌───────────────────┐      ┌───────────────────┐│     │
 │   │   │   Kali Linux VM   │      │  Metasploitable2  ││     │
 │   │   │   (Attacker)      │─────▶│  VM (Target)      ││     │
 │   │   │                   │ scan │  192.168.56.101   ││     │
 │   │   └───────────────────┘      └───────────────────┘│     │
 │   │                                                     │     │
 │   └──────────────────────────────────────────────────┘     │
 │                                                              │
 │           No route to internet or external network          │
 └────────────────────────────────────────────────────────────┘
```

Both virtual machines communicate exclusively over a VirtualBox Host-Only adapter, which has no route to the internet or any external network — ensuring the scan traffic never leaves the isolated lab.

\---

## ⚙️ 6. Installation \& Setup

**1. Install Nmap (if not already present):**

```bash
sudo apt update
sudo apt install nmap -y
nmap --version
```

**2. Configure the isolated lab network in VirtualBox:**

* Go to `File → Host Network Manager → Create` to add a Host-Only adapter
* For both VMs: `Settings → Network → Attached to: Host-only Adapter`

**3. Boot both VMs and verify connectivity:**

```bash
ping -c 4 192.168.56.101
```

\---

## ⚖️ 7. Ethical Considerations

> ⚠️ This scan was performed \*\*exclusively\*\* against a virtual machine that I personally own and control, running on an isolated VirtualBox Host-Only network with no route to the internet or any third-party system.

Scanning any system without explicit authorization is illegal in most jurisdictions, regardless of intent. No external, production, or third-party system was scanned at any point during this exercise. This repository exists purely for educational and professional portfolio purposes.

\---

## 🖧 8. Nmap Commands Used

### Basic Scan

```bash
nmap 192.168.56.101
```

### Service Version Scan

```bash
nmap -sV 192.168.56.101
```

### OS Detection Scan

```bash
sudo nmap -O 192.168.56.101
```

\---

## 🧾 9. Explanation of Each Command

|Command|What It Does|
|-|-|
|`nmap 192.168.56.101`|Scans the 1,000 most common TCP ports using default timing and probing, returning a quick overview of which ports are open, closed, or filtered.|
|`nmap -sV 192.168.56.101`|For every open port, sends protocol-specific probes and compares the response against Nmap's fingerprint database to identify the exact software and version running — critical for identifying known vulnerabilities.|
|`sudo nmap -O 192.168.56.101`|Analyzes subtle characteristics of the target's TCP/IP stack (e.g., TTL, window size, packet ordering) to fingerprint the operating system. Requires root privileges to craft raw packets.|

\---

## 📊 10. Results Summary

**Host Discovery:** Target confirmed alive with 0% packet loss (avg RTT ≈ 2 ms).

**Basic Scan:** 23 open TCP ports identified, including FTP, SSH, Telnet, SMTP, DNS, HTTP, RPC, NetBIOS/SMB, database, and remote-shell services.

**Service Version Scan:** Every open port was mapped to a specific software version, revealing several outdated and high-risk services — including an FTP daemon version with a publicly documented backdoor and a port explicitly identified by Nmap as a pre-existing root shell listener.

**OS Detection:** The target was fingerprinted as running **Linux kernel 2.6.9 – 2.6.33** (general purpose device), consistent with Metasploitable2's known Ubuntu 8.04-based build.

Full raw output for all three scans is available in [`results/nmap\_scan\_results.txt`](results/nmap_scan_results.txt). Per-port risk analysis is available in [`results/port\_analysis.md`](results/port_analysis.md), and individually logged findings with severity ratings are available in [`results/findings\_template.md`](results/findings_template.md).

\---

## ❓ 11. Why Network Scanning Matters

Every open or misconfigured service on a network represents a potential entry point for an attacker. Network scanning is the foundation of both offensive security (identifying what an attacker would find first) and defensive security (auditing an environment before someone else does). Without this reconnaissance step, there is no reliable way to know what is actually running, exposed, or outdated across a network — making it the essential first phase of any security assessment.

\---

## 🔎 12. What is Nmap?

**Nmap (Network Mapper)** is an open-source tool used to discover live hosts, open ports, and running services on a network by sending crafted packets and analyzing the responses. It answers three core reconnaissance questions:

1. Is the host alive?
2. Which ports are open on that host?
3. What software, version, and operating system are running behind those open ports?

Nmap is one of the most widely used tools in the security industry for exactly this reason — it turns an unknown network into a documented, analyzable attack surface.

\---

## 🔐 13. Security Best Practices

* Disable any service that is not explicitly required for the host's function
* Replace plaintext protocols (Telnet, unencrypted FTP) with encrypted equivalents (SSH, SFTP)
* Restrict database and administrative ports to internal-only or localhost access
* Keep all exposed service versions patched and monitor CVE feeds for the software in use
* Enforce strong, unique credentials on every exposed service — never rely on defaults
* Re-scan periodically to confirm that previously identified issues remain resolved

\---

## 📁 14. Project Folder Structure

```
OIBSIP/

└── CyberSecurity-Task1-NmapNetworkScanner/

&#x20;   ├── README.md

&#x20;   ├── nmap\_scan\_results.txt

&#x20;   └── Screenshots/

&#x20;       ├── ping.png

&#x20;       ├── nmap.png

&#x20;       ├── servicescan.png

&#x20;       └── os\_scan.png

\---

## 🖼️ 15. Screenshots

*(Insert your actual terminal screenshots below — do not substitute placeholder images.)*

|Scan Type|Screenshot|
|-|-|
|Host Discovery / Ping Test|`screenshots/ping.png`|
|Basic Port Scan|`screenshots/nmap.png`|
|Service Version Scan|`screenshots/servicescan.png`|
|OS Detection Scan|`screenshots/os\_scan.png`|

\---

## 🏁 16. Conclusion

This project demonstrates a complete and ethically scoped network reconnaissance workflow — from lab setup through scanning, service fingerprinting, and risk documentation — using Nmap against a self-hosted vulnerable target. It reflects the reconnaissance phase of a real penetration testing engagement and establishes the foundation for further security assessment work in this portfolio.

\---

## 📚 17. References

* [Nmap Official Documentation](https://nmap.org/docs.html)
* [Nmap Reference Guide](https://nmap.org/book/man.html)
* [Kali Linux Official Documentation](https://www.kali.org/docs/)
* [Metasploitable2 Documentation (Rapid7)](https://docs.rapid7.com/metasploit/metasploitable-2/)

\---

## 



