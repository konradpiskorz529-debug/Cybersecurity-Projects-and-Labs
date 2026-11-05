# SOC L1 Investigation Report — Windows Endpoint Activity

**Case ID:** SOC-LAB-2026-11-05-001  
**Date:** 2026-11-05  
**Environment:** Isolated Windows 11 ARM64 and Kali Linux virtual machines  
**Case status:** Closed — **authorized laboratory activity**  
**Security incident confirmed?** No  
**Incident priority:** Informational / Low (lab context)  
**MITRE ATT&CK:** T1087.001 (Local Account Discovery); T1053.005 (Scheduled Task)

## 1. Executive summary

A local SOC monitoring script detected two known test behaviors on a Windows 11 virtual machine: a PowerShell local-account enumeration command and execution of a scheduled task configured to launch Notepad when the lab user logged on. Both detections were expected outcomes of deliberately conducted exercises.

An earlier investigation on the same day demonstrated a correlated sequence involving an RDP logon, PowerShell process creation, and the `Get-LocalUser` script block. Task Scheduler and Sysmon records were also examined to confirm the scheduled-task execution mechanism. Additional filesystem artifacts (PSReadLine history and Prefetch) supported historical analysis.

**Disposition:** Correct detections of simulated behavior; **benign authorized activity**, with **no evidence in the reviewed material of malicious compromise, privilege escalation, or destructive action**. No SOC L2 escalation was necessary for this pre-authorized lab. In a real organization, lack of such authorization would warrant contextual investigation.

## 2. Scope and initial alerts

The monitoring script polled PowerShell/Operational Event ID 4104 and TaskScheduler/Operational Event ID 200 every five seconds. The following output was observed in the console and later in `alerts.log`:

| Time (CET) | Detection | Severity | Supporting observation |
| --- | --- | --- | --- |
| 2026-11-05 19:37:38 | PowerShell Local User Discovery | LOW | Alert emitted for `SOC-LabUser` |
| 2026-11-05 19:44:42 | Scheduled Task Executed | INFO | Alert emitted for `\SOC-Lab-Notepad` |

The 19:37/19:44 alerts were **new test executions**. Detailed process and logon correlation screenshots below are from an **earlier 14:23 test**, not proven to be the same session as the evening alerts. This separation matters when reporting evidence.

## 3. Findings

### Finding A — Remote interactive logon and PowerShell discovery

- **2026-11-05 14:23:12 CET — Security Event 4624:** account `SOC-LabUser`, **Logon Type 10** (RemoteInteractive), source IP `192.168.149.131` (lab Kali VM), **Logon ID `0x677815`**.
- **2026-11-05 14:23:41 CET — Sysmon Event 1:** `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`, **PID `12840`**, `ParentImage` `C:\Windows\explorer.exe`, user `SOC-LabUser`, **Logon ID `0x677815`**, integrity **Medium**.
- **2026-11-05 14:25:02 CET — PowerShell Event 4104:** script block contained `Get-LocalUser | Select-Object name, Enabled`; the event XML's execution PID was **`12840`**, consistent with the preceding Sysmon process.
- **PSReadLine:** command history for the lab user included the same command. A history file does not ordinarily prove the command execution time.
- **Prefetch:** `POWERSHELL.EXE-CA1AE517.pf` contained a run time of **2026-11-05 13:23:41 UTC**, consistent with the Sysmon creation time at **14:23:41 CET**. Its `Run count` was **19**, but it cannot assign those executions to a user.

**Interpretation:** In the 14:23 session, the common Logon ID links the RDP logon and PowerShell process. The common PID and time sequence link that process with the script block. This is evidence of local user discovery by the authorized lab user, not evidence of compromise.

### Finding B — Scheduled Task execution mechanism

The exported `\SOC-Lab-Notepad` task definition specified:

- `LogonTrigger` for `SOC-LabUser`.
- `LogonType` `InteractiveToken` (dependent on an interactive logon).
- Action `C:\Windows\System32\notepad.exe`.
- Recorded creator field identifying the lab administrator account (not included here).

Task Scheduler Operational **Event 200** displayed matching `TaskName` and `ActionName` (observed **13:54:27** and **14:23:17 CET**), and a fresh test yielded an **INFO** alert at **19:44:42 CET**. Earlier Sysmon Event 1 analysis showed a Notepad process whose parent was `svchost.exe -k netsvcs -p -s Schedule`; a subsequent Notepad process was observed with the first Notepad as its parent.

**Interpretation:** An authorized logon-triggered scheduled task performed the expected benign action. It models the **T1053.005** persistence mechanism; no malicious payload was used.

### Finding C — Complementary artifacts and limits

- `CMD.EXE` Prefetch recorded **Run count 9**, and `POWERSHELL.EXE` Prefetch recorded **Run count 19**. These are recorded run counts within the particular artifacts, not per-user totals.
- `NOTEPAD.EXE` Prefetch recorded **Run count 3** with last time from **2026-11-04**, rather than the Nov 5 execution captured by Task Scheduler and Sysmon. This mismatch does **not** invalidate more direct telemetry; the Windows 11 packaged Notepad and Prefetch collection can differ by executable and invocation path.
- The configured scheduled task XML corroborates **what should run and when**; Event 200 and Sysmon corroborate **that an action was started / process created**.

## 4. Classification and triage outcome

| Question | Assessment |
| --- | --- |
| Was the alert technically a match? | **Yes** — the expected lab behavior was detected in both cases |
| Is the behavior potentially relevant to attackers? | **Yes** — discovery and scheduled-task execution are mapped to ATT&CK |
| Is this a real malicious incident? | **Not supported** — authorized simulation, benign Notepad action, no evidence of compromise |
| Escalate to SOC L2? | **No** for this authorized exercise; for an unapproved task or unusual RDP source, investigate and escalate per policy |
| Recommended case closure | **True-positive detection of benign test activity** / expected laboratory alert |

**Terminology:** A 'true-positive detection' here means the detector matched the behavior it was designed to match. It does **not** mean that an actual attack occurred.

## 5. Recommended defensive improvements

1. Centralize Windows Security, PowerShell and Sysmon logs in a SIEM and retain event timestamps and record IDs.
2. Add context-rich scheduled-task detections: task creation/change, unusual executable paths, unexpected accounts, and parent-child behavior; avoid relying only on the known `SOC-Lab-Notepad` name.
3. Tune account-discovery detection based on account role, source host, and follow-on actions to reduce false positives.
4. Validate Sigma backends and field mappings; Sigma CLI syntax validation alone is not an end-to-end SIEM test.
5. Improve collection quality (EVTX exports, hashes, timestamps, provenance, redacted screenshots) for future cases.
6. Keep RDP isolated in the lab; remove or disable test accounts and rules when the exercise is complete.

## 6. Evidence and integrity notes

This portfolio report is based on **observed console/event-viewer screenshots and user-reported output**. Original `.evtx` source files were not supplied here, and no formal forensic evidence acquisition or chain-of-custody documentation was performed. The timeline is therefore a **well-supported training reconstruction**, not an independently authenticated incident record.

See [timeline](incident-timeline.md), [evidence index](../evidence/README.md), and [detection testing](../docs/detection-testing.md).
