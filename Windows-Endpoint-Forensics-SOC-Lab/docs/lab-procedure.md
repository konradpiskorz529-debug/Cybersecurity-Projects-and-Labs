# Lab Setup — Environment and Procedures

This is a summary of the **completed isolated exercise**, not a production deployment guide.

## Environment

- macOS host with VMware Fusion.
- Kali Linux VM connected to the same private virtual network as a Windows 11 ARM64 VM.
- Windows security policy configured to audit successful/failed logons and process creation.
- Sysmon installed and configured for process creations, network connections and process termination.
- Windows PowerShell Script Block Logging enabled; Task Scheduler task history enabled.

## Tested behavior

1. RDP authentication: attempted access from Kali and reviewed Windows Security 4625/4624.
2. System discovery: performed `whoami /all`, `whoami /priv`, and `Get-LocalUser` under a lab account.
3. Process analysis: correlated Sysmon Event 1 with parent executable and session attributes.
4. Scheduled task persistence demonstration: authorized `\SOC-Lab-Notepad` task triggered Notepad on logon; reviewed Task Scheduler ID 200 and Sysmon events.
5. Forensic review: checked PSReadLine command history, copied `.pf` files, parsed Prefetch using Eric Zimmerman's PECmd, and exported the scheduled-task XML.
6. Detection development: wrote Sigma rules, tested the conditions with `Get-WinEvent`, validated with Sigma CLI and generated local monitor alerts.

## Notes

- Snapshot(s) were taken during the lab; they are not published here.
- The lab was isolated from the internet when transferring PECmd and rule files via the host.
- Avoid publishing actual user SID values, host-specific secrets or sensitive data.
- After completion, turn off unnecessary RDP access, firewall exceptions and test accounts.
