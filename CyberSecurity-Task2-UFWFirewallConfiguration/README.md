# Basic Firewall Configuration with UFW

A hands-on cybersecurity project demonstrating host-based firewall configuration, traffic filtering, and rule verification on Kali Linux using the Uncomplicated Firewall (UFW).

---

## Objective

The goal of this project is to configure and validate a basic host-level firewall on a Kali Linux system using UFW. The project focuses on controlling inbound network traffic by explicitly allowing trusted services and denying insecure or unnecessary ones, then verifying that the configured rules behave as intended using both native UFW status checks and external port scanning with Nmap.

This exercise simulates a real-world task performed by security professionals: hardening a system's network exposure by reducing its attack surface to only the services that are required.

---

## What Is a Firewall

A firewall is a security control that sits between a system (or network) and the traffic attempting to reach it, deciding which connections are permitted and which are blocked. It works by inspecting characteristics of incoming and outgoing traffic — such as the destination port, protocol, and source address — and comparing them against a defined set of rules.

In simple terms, a firewall acts as a checkpoint. Every connection attempt is evaluated against a rulebook, and only the traffic that matches an "allow" rule is let through; everything else is either dropped silently or actively rejected, depending on the firewall's configuration. Firewalls are a foundational layer of defense because most attacks first require some form of network access to a service running on the target machine. By closing off ports for services that are not in active use, a firewall significantly reduces the number of ways an attacker can attempt to interact with a system.

UFW is a front-end for Linux's netfilter/iptables framework. It does not replace the underlying packet filtering engine but simplifies how rules are written and managed, making firewall administration accessible without needing to write raw iptables syntax.

---

## Tools Used

| Tool | Purpose |
|---|---|
| Kali Linux | Host operating system for configuring and testing the firewall |
| UFW (Uncomplicated Firewall) | Firewall management tool used to define allow/deny rules |
| Nmap | Used externally to scan the target and confirm that blocked ports were not reachable |
| Bash | Used to write an automation script that applies all firewall rules in one execution |

---

## Project Workflow

The project was carried out in the following sequence:

1. **Baseline check** – Confirmed UFW was installed and reviewed its default status before making any changes.
2. **Rule definition** – Decided which services should be reachable (SSH, HTTPS) and which should be blocked (HTTP, Telnet), based on standard security practice.
3. **Rule application** – Applied the rules individually using UFW commands to allow or deny traffic on specific ports.
4. **Firewall activation** – Enabled UFW so the defined rules would actively filter traffic.
5. **Verification (internal)** – Used `sudo ufw status verbose` to confirm each rule was registered correctly, along with its action and direction.
6. **Verification (external)** – Ran an Nmap scan against the host from a separate vantage point to confirm that the denied port (HTTP/80) was not accessible and appeared as filtered.
7. **Automation** – Consolidated all the manual commands into a single Bash script, `ufw_configuration.sh`, so the configuration could be reproduced consistently on demand.

---

## Firewall Rules

The following rules were configured to reflect a minimal, security-conscious service exposure:

| Port | Service | Action | Justification |
|---|---|---|---|
| 22 | SSH | Allow | SSH is required for legitimate remote administration of the system. It uses encrypted communication, making it an acceptable service to expose when access is otherwise restricted and monitored. |
| 80 | HTTP | Deny | HTTP transmits data, including credentials, in plaintext. Without a specific need to serve unencrypted web traffic, this port was blocked to prevent exposure to interception and unauthorized access. |
| 443 | HTTPS | Allow | HTTPS provides encrypted web communication using TLS. It was permitted so that secure web services can still be accessed without exposing the system to the risks associated with plaintext HTTP. |
| 23 | Telnet | Deny | Telnet is a legacy remote access protocol that transmits all data, including login credentials, without any encryption. It is widely considered insecure and was blocked to eliminate this attack vector entirely. |

The underlying principle applied here is that every open port represents potential exposure. Only services with a clear operational need and an acceptable security posture (such as encrypted alternatives) were permitted.

---

## Testing Method

Two layers of verification were used to confirm the firewall was functioning as configured:

**1. Internal verification with UFW**
The command `sudo ufw status verbose` was used to list all active rules along with their direction (incoming/outgoing) and action (allow/deny). This confirmed that the rules had been registered correctly by the firewall itself.

**2. External verification with Nmap**
To validate that the rules were actually being enforced at the network level — rather than just existing in configuration — an Nmap scan was performed against the host. The scan targeted port 80, which had been explicitly denied. The result showed the port in a **filtered** state, which indicates that packets sent to that port received no response, consistent with UFW silently dropping the traffic rather than actively rejecting it. This confirmed that the firewall rule was not just configured but genuinely enforced against external probing.

Testing from an external vantage point rather than only checking local configuration is an important distinction: many misconfigurations only become apparent when traffic is tested as an outside party would experience it.

---

## Automation Script

To make the configuration reproducible and to reduce the chance of manual error, all firewall rules were consolidated into a single Bash script named `ufw_configuration.sh`. Running this script applies the full rule set in one step, which is useful when rebuilding the environment or deploying the same configuration to another machine.

**Script contents:**

```bash
#!/bin/bash

# ufw_configuration.sh
# Applies baseline UFW firewall rules for this project

echo "Enabling UFW and applying firewall rules..."

sudo ufw allow 22/tcp    # Allow SSH
sudo ufw deny 80/tcp     # Deny HTTP
sudo ufw allow 443/tcp   # Allow HTTPS
sudo ufw deny 23/tcp     # Deny Telnet

sudo ufw --force enable

echo "Firewall rules applied. Current status:"
sudo ufw status verbose
```

**Usage:**

```bash
chmod +x ufw_configuration.sh
sudo ./ufw_configuration.sh
```

The script gives the firewall configuration execute permissions, applies each rule in sequence, enables UFW, and prints the resulting status so the outcome can be confirmed immediately after execution.

---

## Results

| Check Performed | Outcome |
|---|---|
| SSH (Port 22) | Allowed and reachable, as intended |
| HTTP (Port 80) | Denied at the firewall; confirmed filtered via Nmap scan |
| HTTPS (Port 443) | Allowed and reachable, as intended |
| Telnet (Port 23) | Denied at the firewall |
| `ufw status verbose` output | Correctly reflected all four configured rules with matching actions and directions |
| External Nmap scan | Confirmed enforcement of the deny rule on port 80, showing it as filtered rather than open or closed |

The combination of internal status output and external scan results confirmed that the firewall was not only configured correctly but was actively enforcing the intended policy against real network probes.

---

## Conclusion

This project demonstrated a complete, practical workflow for configuring a host-based firewall: defining a rule policy based on security reasoning, applying it with UFW, and validating it through two independent methods. The exercise highlighted that effective firewall configuration is not just about running commands, but about understanding why each rule exists and confirming that the system behaves as expected when tested from an attacker's perspective. The resulting Bash automation script also demonstrates the ability to convert manual security tasks into repeatable, reliable processes.

---
