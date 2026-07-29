# Common Network Security Threats

## Introduction

Organizations and individuals now depend on interconnected networks for nearly every critical function, from financial transactions to healthcare records and industrial operations. This dependence has made network security a defining challenge of the digital era, as cyber attacks have grown steadily in both frequency and sophistication, evolving from isolated incidents into coordinated campaigns run by organized criminal groups and, at times, state-sponsored actors. High-profile incidents such as the 2016 Dyn DNS attack and the 2018 GitHub DDoS attack demonstrate how a single well-executed attack can disrupt access to major online services for millions of users within minutes. For organizations, weak network security can result in direct financial loss, regulatory penalties, and lasting reputational harm, while individuals face risks such as identity theft and financial fraud. Network security exists to protect the confidentiality, integrity, and availability of information as it moves across systems, combining technical controls, monitoring, and policy to detect and stop malicious activity before it causes lasting damage. Understanding how common network-based threats operate is the essential first step toward building resilient defenses, which is the focus of this report.

## Threat 1: DoS and DDoS Attacks

### What is a DoS Attack?

A Denial-of-Service (DoS) attack attempts to make a system or service unavailable to legitimate users by exhausting a limited resource, such as bandwidth, CPU cycles, memory, or connection capacity, using traffic from a single source.

### What is a DDoS Attack?

A Distributed Denial-of-Service (DDoS) attack achieves the same goal, but the traffic originates from many distributed sources simultaneously, typically a botnet of compromised devices. This makes DDoS attacks far harder to stop than a single-source DoS attack, since blocking one IP address has little effect.

### How the Attack Works

1. **Reconnaissance** – The attacker studies the target's infrastructure to identify capacity limits or exploitable protocols.
2. **Botnet assembly** – Vulnerable devices, often IoT products such as routers and DVRs still using default credentials, are infected with malware and enslaved into a botnet.
3. **Command and control** – Infected devices await instructions from a control server on when and what to attack.
4. **Amplification (optional)** – Attackers send small spoofed requests to misconfigured public servers, such as DNS or Memcached instances, which reply with responses many times larger, directed at the victim.
5. **Service collapse** – The target's servers or bandwidth become saturated, causing outages for legitimate users.

### Real-world Example

In October 2016, the Mirai botnet, built from compromised IoT devices running factory-default passwords, was used to flood Dyn, a major DNS provider, with DDoS traffic. Because dozens of major platforms, including Twitter, GitHub, Netflix, and PayPal, relied on Dyn for DNS resolution, those services became unreachable for hours across the United States and parts of Europe even though none were directly targeted (Krebs, 2016). A second example is the February 2018 attack on GitHub, which peaked at a then-record 1.35 Tbps. Attackers exploited internet-exposed Memcached servers by spoofing GitHub's IP address in small requests, causing the servers to send back responses tens of thousands of times larger, all directed at GitHub (CISA, 2023).

### Impact

- **Financial loss**: Lost revenue during outages, plus incident response and mitigation costs.
- **Service downtime**: Core services can be unreachable for hours, disrupting transactions and operations.
- **Reputation damage**: Repeated or prolonged outages erode customer trust, particularly for infrastructure providers.
- **Operational disruption**: Teams are diverted to incident response, and dependent third-party services may suffer cascading failures.

### Mitigation Strategies

1. **Traffic scrubbing and CDNs**: Routing traffic through a specialized anti-DDoS provider filters malicious packets at the network edge before they reach origin servers, leveraging global capacity that a single organization cannot match.
2. **Rate limiting and connection throttling**: Capping the requests accepted from a single IP or session within a given window prevents any one source from consuming a disproportionate share of resources.
3. **Securing amplification-prone services**: Restricting or disabling unauthenticated UDP access on services like DNS resolvers, NTP, and Memcached removes the reflectors that amplification attacks depend on.

## Threat 2: Man-in-the-Middle (MITM)

### Definition

A Man-in-the-Middle attack occurs when an attacker secretly intercepts, and potentially alters, communication between two parties who believe they are communicating directly, capturing sensitive data such as credentials or session tokens.

### How It Works

MITM attacks exploit weaknesses in network trust or encryption verification, using techniques such as ARP spoofing on local networks, rogue Wi-Fi access points mimicking trusted hotspots, or forged SSL/TLS certificates that trick a device into trusting a fraudulent certificate authority.

### Attack Workflow

1. **Positioning** – The attacker gains a vantage point on the communication path, such as joining the same local network or embedding software on the victim's device.
2. **Interception** – Traffic is redirected through the attacker's system instead of its intended destination.
3. **Certificate substitution** – For encrypted traffic, the attacker presents a forged certificate the victim's device has been made to trust, allowing decryption and re-encryption of the session.
4. **Data capture** – Credentials, financial details, or session cookies are recorded.
5. **Forwarding** – Traffic is passed on to its real destination so the victim notices no disruption.

### Real-world Example

In 2015, Lenovo was found to have shipped consumer laptops preloaded with adware called Superfish, which installed a self-signed root certificate and generated forged certificates on the fly to intercept HTTPS sessions and inject advertisements (Goodin, 2015). Because the private key used to generate these certificates was identical across every affected device, anyone who extracted it could intercept encrypted traffic on any Superfish-equipped laptop, including over public Wi-Fi. Users reported forged certificates appearing for sensitive sites, including banking portals, and the incident led to security advisories and a subsequent regulatory settlement.

### Impact

- **Credential theft**: Login and banking details can be captured in real time.
- **Confidentiality breach**: Sensitive communications may be exposed without either party's knowledge.
- **Erosion of trust in encryption**: Compromised root certificates undermine the entire trust model HTTPS depends on.
- **Regulatory consequences**: Organizations deploying or enabling MITM-capable software may face investigations and penalties.

### Mitigation Strategies

1. **Enforcing HTTPS with HSTS**: HTTP Strict Transport Security ensures browsers only connect over encrypted channels and refuse to downgrade to plaintext.
2. **Certificate pinning**: Applications can be configured to accept only specific known-good certificates, preventing acceptance of a fraudulent one even if signed by a trusted root.
3. **Avoiding untrusted networks and using VPNs**: Encrypting traffic through a reputable VPN on public Wi-Fi prevents a locally positioned attacker from reading or altering it.

## Threat 3: IP Spoofing

### Definition

IP spoofing is the practice of forging a packet's source IP address so it appears to originate from a trusted or different host, used to bypass IP-based authentication, hide an attack's origin, or redirect a third-party server's responses toward a victim.

### Packet Manipulation Process

1. The attacker sets a packet's source IP field to a trusted or victim address rather than their own.
2. The forged packet is sent to a service, such as an open DNS resolver or Memcached server, which cannot verify the listed source.
3. The receiving server sends its response to the spoofed address instead of the true sender.
4. In amplification attacks, the response is deliberately far larger than the request, so a small spoofed query produces a large flood directed at the victim.
5. Because the victim's address appears in the packet headers, tracing the attack back to the true attacker becomes significantly harder.

### Real-world Example

The 2018 GitHub attack also illustrates IP spoofing directly: attackers spoofed GitHub's IP address and sent forged requests to vulnerable Memcached servers exposed on the public internet, which responded with packets up to fifty thousand times larger than the request, all directed at GitHub instead of the true sender (CISA, 2023). This and similar reflection campaigns using DNS and NTP servers show how the lack of source-address verification across parts of the internet continues to enable large-scale spoofing.

### Impact

- **Amplified DDoS attacks**: Spoofing underlies most reflection and amplification attacks, letting attackers generate traffic volumes far beyond their own resources.
- **Bypassed access controls**: Systems trusting source IP alone can be tricked into granting access to an impersonated host.
- **Attribution difficulty**: Falsified source addresses make tracing an attack to its true origin significantly harder.
- **Collateral damage**: Servers whose responses are hijacked may suffer resource exhaustion or reputational harm as unwitting attack infrastructure.

### Mitigation Strategies

1. **Ingress and egress filtering (BCP 38)**: Network operators can verify that outgoing packets carry a source address that legitimately belongs to their network, stopping spoofed packets before they leave.
2. **Securing amplification-prone services**: Restricting public access to DNS resolvers, NTP, and Memcached, and requiring authentication where possible, removes the reflectors spoofed traffic depends on.
3. **Anti-spoofing detection at the network edge**: Firewalls and intrusion detection systems can flag packets with source addresses inconsistent with the expected routing path, enabling earlier detection.

## Threat 4: DNS Poisoning / DNS Spoofing

### Definition

DNS poisoning, or DNS spoofing, inserts false information into a DNS resolver's cache or routing path, redirecting users to a malicious server when they attempt to reach a legitimate domain, without any visible change to the URL they typed.

### How DNS Cache Poisoning Works

1. **Target identification** – The attacker selects a DNS resolver to corrupt.
2. **Forged response injection** – Forged DNS responses matching the expected transaction parameters are sent, attempting to arrive before the legitimate authoritative reply.
3. **Cache acceptance** – If accepted, the false mapping is cached, poisoning results for every client using that resolver until the entry expires.
4. **Traffic redirection** – Users querying the poisoned resolver are silently sent to an attacker-controlled address.
5. **Exploitation** – The attacker's server, often a convincing phishing replica, harvests credentials or other sensitive data.

A related technique involves hijacking Border Gateway Protocol (BGP) routing announcements rather than the DNS cache directly, redirecting which network path traffic to a legitimate DNS provider takes.

### Real-world Example

In April 2018, users of the cryptocurrency wallet MyEtherWallet were affected when attackers executed a BGP hijack against Amazon's DNS infrastructure, rerouting traffic intended for its Route 53 service to a server in Russia hosting a phishing replica of the site (NIST, 2020). Over roughly two hours, victims who submitted credentials to the fake site had funds worth about $150,000 stolen, even though MyEtherWallet's own platform was never breached; the compromise occurred entirely at the routing and name-resolution layer.

### Impact

- **Credential and financial theft**: Victims redirected to convincing fake sites often submit credentials or private keys directly to attackers.
- **Wide reach through cache poisoning**: A single successful poisoning of a widely used resolver can silently redirect every client relying on it.
- **Loss of trust in domain integrity**: Users who learn a legitimate domain served malicious content may remain wary even after the vulnerability is fixed.
- **Detection difficulty**: Since the displayed URL remains unchanged, victims typically have no visible indication of redirection.

### Mitigation Strategies

1. **Deploying DNSSEC**: DNS Security Extensions allow resolvers to cryptographically verify that responses genuinely originate from the authoritative source, rejecting forged records.
2. **Enforcing HSTS and certificate transparency monitoring**: Requiring browsers to accept only valid, expected certificates, combined with monitoring certificate transparency logs, helps detect phishing pages even if DNS redirection succeeds.
3. **BGP route monitoring and RPKI validation**: Resource Public Key Infrastructure lets operators cryptographically validate that route announcements originate from the legitimate address holder, while route monitoring alerts organizations to unauthorized announcements in near real time.

## Comparison Table

| Threat | Attack Vector | Who is at Risk | Difficulty to Execute | Ease of Mitigation |
|---|---|---|---|---|
| DoS / DDoS | Traffic floods via botnets or amplification | Internet-facing services; DNS providers and hosting platforms | Low to moderate | Moderate — requires CDN/scrubbing capacity and monitoring |
| Man-in-the-Middle | Rogue Wi-Fi, ARP spoofing, or forged certificates | Users on public networks; weak certificate validation | Moderate | Moderate to high — HSTS and pinning are effective |
| IP Spoofing | Forged source IP addresses | Networks lacking egress filtering; open reflector services | Low to moderate | Moderate — requires provider-level filtering (BCP 38) |
| DNS Poisoning / Spoofing | Cache poisoning or BGP route hijacking | Organizations relying on standard DNS; resolver users | Moderate to high | Moderate — DNSSEC/RPKI adoption remains incomplete |

## Conclusion

Three takeaways stand out for network administrators. First, layered defense is essential: no single control fully addresses DoS, MITM, spoofing, or DNS-based threats, so filtering, cryptographic verification, and monitoring must work together. Second, much of the underlying risk stems from foundational protocols, including BGP, DNS, and UDP-based services, that were not designed with strong authentication, making adoption of DNSSEC, RPKI, and BCP 38 filtering essential to closing structural gaps. Third, preparation determines impact more than attacker sophistication, as shown by GitHub's rapid recovery from a record-scale DDoS attack through pre-arranged mitigation partnerships. Administrators who invest in proactive architecture, monitoring, and incident response planning are far better positioned when these common threats reach their networks.

## References

CISA. (2023). *Understanding denial-of-service attacks*. Cybersecurity and Infrastructure Security Agency. https://www.cisa.gov/news-events/news/understanding-denial-service-attacks

MITRE ATT&CK. (n.d.). *Network denial of service, Technique T1498*. MITRE Corporation. https://attack.mitre.org/techniques/T1498/

NIST. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). National Institute of Standards and Technology. https://doi.org/10.6028/NIST.SP.800-53r5

Krebs, B. (2016, October 21). *Hacked cameras, DVRs powered today's massive internet outage*. Krebs on Security. https://krebsonsecurity.com/2016/10/hacked-cameras-dvrs-powered-todays-massive-internet-outage/

SANS Institute. (2019). *Understanding DNS security: DNSSEC and beyond*. SANS Institute Reading Room.

Goodin, D. (2015, February 19). *Lenovo PCs ship with man-in-the-middle adware that breaks HTTPS connections*. Ars Technica.

---

*This report was prepared as part of the Oasis Infobyte Cyber Security Internship, Task 4: Network Security Threats Report.*
