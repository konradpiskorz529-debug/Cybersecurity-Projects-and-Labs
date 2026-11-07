# Cybersecurity Projects & Labs

**Hands-on Cybersecurity Portfolio | SOC Analysis • Digital Forensics • Detection Engineering • SIEM • Network Security**

Welcome to my cybersecurity portfolio!

This repository showcases hands-on projects focused on security monitoring, incident investigation, threat detection, log analysis, and network infrastructure protection.

The projects demonstrate practical experience with SIEM solutions, Windows and Linux environments, security event analysis, digital forensics, and defensive security techniques.

---

## Featured Projects

### 1. Windows Endpoint Forensics & SOC Detection Lab

**Security Monitoring | Incident Investigation | Detection Engineering**

A hands-on security laboratory designed to simulate, detect, and investigate suspicious Windows endpoint activity in an isolated virtual environment.

**Key activities:**

- Simulated RDP logins, PowerShell reconnaissance, and scheduled-task persistence.
- Investigated Windows Security, Sysmon, and PowerShell event logs.
- Correlated multiple event sources to reconstruct user activity.
- Analyzed forensic artifacts, including Prefetch, PSReadLine history, and scheduled tasks.
- Developed and validated two Sigma detection rules.
- Built a custom PowerShell monitoring script that generated and recorded alerts.
- Documented findings in an incident investigation report.

**Technologies:** Windows 11, Kali Linux, VMware Fusion, Sysmon, PowerShell, Sigma CLI, PECmd

**MITRE ATT&CK:** T1087.001, T1053.005

[Explore the Full Project](https://github.com/konradpiskorz529-debug/Cybersecurity-Projects-and-Labs/tree/main/Windows-Endpoint-Forensics-SOC-Lab)

---

### 2. Elastic Stack SIEM & Log Analysis Lab

**SIEM | Linux Log Analysis | SSH Authentication Monitoring**

A practical security monitoring laboratory designed to centralize Linux system logs and investigate suspicious SSH authentication activity using the Elastic Stack.

**Key activities:**

- Deployed and configured Elasticsearch and Kibana using Docker Compose.
- Installed and configured Filebeat to collect Linux SSH authentication logs from systemd-journald.
- Established an SSH tunnel to securely forward logs between Kali Linux and Elasticsearch.
- Generated controlled failed SSH authentication attempts.
- Used Kibana Discover and KQL to filter and investigate authentication events.
- Created an SSH monitoring dashboard with a time-based visualization and detailed event table.
- Documented findings in a SOC-style investigation report.

**Investigation highlights:**

- Identified four failed SSH authentication attempts within approximately 27 seconds.
- Analyzed event timestamps, targeted accounts, and source IP information.
- Investigated repeated authentication failures as a simulated brute-force-like activity.

**Technologies:** Elasticsearch, Kibana, Filebeat, Docker, Kali Linux, Linux, KQL, SSH

[Explore the Full Project](https://github.com/konradpiskorz529-debug/Cybersecurity-Projects-and-Labs/tree/main/Elastic-SIEM-Lab)

---

## Other Cybersecurity Projects

### 1. Wazuh SIEM/XDR - Security Monitoring & Active Response

Deployment and configuration of a security monitoring environment using Wazuh and Docker.

**Key activities:**

- Configured SIEM/XDR monitoring.
- Implemented File Integrity Monitoring (FIM).
- Tested brute-force attack detection using Kali Linux.
- Explored automated threat mitigation through Active Response.

**Technologies:** Wazuh, Docker, Kali Linux, Linux, SIEM/XDR

[View Project Report](https://github.com/konradpiskorz529-debug/Cybersecurity-Projects-and-Labs/blob/main/Projekt-koncowy2-wazuh%20%281%29.pdf)

### 2. Network Segmentation & Firewall Security

Designed and implemented a segmented network architecture with dedicated security zones.

**Key activities:**

- Configured WAN, LAN, and DMZ network segments.
- Implemented firewall policies using UFW.
- Applied default-deny security principles.
- Configured routing and NAT/DNAT.
- Tested network connectivity and ICMP filtering.

**Technologies:** Linux, UFW, TCP/IP, NAT, Routing, Firewalls

[View Project Report](https://github.com/konradpiskorz529-debug/Cybersecurity-Projects-and-Labs/blob/main/Projekt-Koncowy2.pdf)

### 3. WireGuard VPN - Secure Remote Access

Implementation of a secure remote-access VPN using WireGuard and Zero Trust-inspired network access principles.

**Key activities:**

- Configured encrypted VPN tunnels.
- Implemented cryptographic key-based authentication.
- Applied strict network isolation and access controls.
- Configured firewall policies and NAT/Masquerade.
- Analyzed network packets and connection issues using tcpdump.

**Technologies:** WireGuard, Linux, iptables, Netplan, tcpdump, VPN

[View Project Report](https://github.com/konradpiskorz529-debug/Cybersecurity-Projects-and-Labs/blob/main/Projekt_kocncowy_VPN.pdf)

---

## Technical Skills Demonstrated

| **Area** | **Technologies & Concepts** |
|---|---|
| SIEM & Security Monitoring | Elastic Stack, Wazuh, Filebeat, Sysmon, Windows Event Logs |
| Log Analysis | Kibana Discover, KQL, Elasticsearch, Linux journald, SSH Authentication Logs |
| Detection Engineering | Sigma Rules, PowerShell, Event Correlation |
| Incident Investigation | SOC Triage, Log Correlation, Security Event Investigation, MITRE ATT&CK |
| Digital Forensics | Prefetch, PECmd, PSReadLine History, Windows Artifacts |
| Network Security | Firewalls, VPN, NAT, Network Segmentation, SSH |
| Operating Systems | Windows, Linux, Kali Linux |
| Tools & Infrastructure | VMware Fusion, Docker, Docker Compose, Wireshark, tcpdump |

---

## Learning Objectives

These projects focus on developing practical cybersecurity skills, particularly in:

- Security Operations Center (SOC) workflows and log analysis.
- SIEM deployment and centralized security monitoring.
- Threat detection and security event investigation.
- Incident investigation and documentation.
- Digital forensics and endpoint monitoring.
- Network security configuration.
- Defensive security testing and automation.

## Disclaimer

All attack simulations and security testing activities were performed in authorized laboratory environments for educational purposes. Detection results reflect controlled testing and do not represent confirmed real-world security incidents.

---

*This portfolio is continuously evolving as I expand my practical cybersecurity knowledge and skills.*
