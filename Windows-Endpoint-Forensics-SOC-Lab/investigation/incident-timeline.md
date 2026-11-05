# Incident Timeline — Authorized SOC Lab

**Time convention:** All times below are local **CET (UTC+1)** unless marked UTC. All entries are from Nov 5, 2026 unless explicitly indicated otherwise.

## A. Correlated investigation (early test run)

| Time | Source | Observation | Correlation |
| --- | --- | --- | --- |
| 13:54:27 | Task Scheduler ID 200 | `\SOC-Lab-Notepad` action launched | Separate earlier Scheduled Task test |
| 14:23:12 | Security ID 4624 | `SOC-LabUser`, Logon Type 10, source `192.168.149.131` | Logon ID `0x677815` |
| 14:23:17 | Task Scheduler ID 200 | Lab Notepad task action launched | Same session timeframe; task action confirmed |
| 14:23:41 | Sysmon ID 1 | `powershell.exe`, PID 12840, parent `explorer.exe`, integrity Medium | Logon ID `0x677815` matches Security 4624 |
| 14:25:02 | PowerShell ID 4104 | `Get-LocalUser | Select-Object name, Enabled` | Execution PID 12840 matches Sysmon |
| 13:23:41 UTC | Prefetch PowerShell | PowerShell run time recorded | Corresponds to 14:23:41 CET; user not recoverable from Prefetch alone |

## B. Later live-alert test run

| Time | Source | Observation | Notes |
| --- | --- | --- | --- |
| 19:37:38 | `soc-monitor.ps1` | `[ALERT] PowerShell Local User Discovery | SOC-LabUser | LOW` | Monitor detected a new matching PowerShell event |
| 19:44:42 | `soc-monitor.ps1` | `[ALERT] Scheduled Task Executed | \SOC-Lab-Notepad | INFO` | Monitor detected matching Task Scheduler action |
| After test | `alerts.log` readback | Both alert entries present | Demonstrates persistence to a text log; not a hardened audit trail |

These are **not asserted to be the same session** as the 14:23 events. The screenshots and the local monitor are not evidence of a continuous compromise between these time periods.

## C. Prior-day supporting evidence — Nov 4, 2026

- Security Event **4625**: an unsuccessful network logon for the lab account (Logon Type 3), source Kali lab IP; investigation of authentication failures.
- A later **4624 Type 10** successful RDP logon and TerminalServices Operational login/disconnect/logoff records were examined.
- Prefetch: `CMD.EXE-0BD30981.pf` held a run time **16:19:07 UTC**, aligned with a Sysmon command process observed at **17:19:07 CET**.
- The Notepad Prefetch artifact's last run time did not include later Nov 5 executions; this is an attribution/coverage limitation, not a contradiction requiring a malicious explanation.

## Correlation method

1. Align local event times with UTC timestamps; Nov 5 in Poland is CET (UTC+1).
2. Join Security 4624 and Sysmon ID 1 by `Logon ID` **and** system context.
3. Join Sysmon process creation and PowerShell Event 4104 using PID and chronology, checking for PID reuse.
4. Join scheduled-task execution (Event 200 `TaskName`/`ActionName`) and Sysmon process lineage by time and process context.
5. Treat Prefetch as supplemental: it supplies execution evidence but not a reliable user identity.
