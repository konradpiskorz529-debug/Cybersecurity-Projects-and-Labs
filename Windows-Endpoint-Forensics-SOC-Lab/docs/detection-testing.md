# Detection Validation & Replay Notes

## Distinct tests

- **Rule condition tests:** `Get-WinEvent` was used to filter PowerShell Event 4104 for `Get-LocalUser`, and Task Scheduler Event 200 for `TaskName` `\SOC-Lab-Notepad` and an action ending in `\notepad.exe`.
- **Live monitor tests:** the independently authored PowerShell script emitted a red LOW alert and a yellow INFO alert. Both were recovered from `alerts.log` afterward.
- **Sigma validation:** two locally saved YAML rules were checked with `sigma check "$HOME/Desktop/Detections"` on macOS, using Sigma CLI **4.0.0**. Reported outcome: **0 errors / 0 condition errors / 0 issues**.

> These are **three different tests**. The live monitor checks matching conditions in its own code; it does **not** parse Sigma rule files. Sigma CLI check validates a rule set, but does not prove SIEM execution or low false-positive rates.

## Replaying locally (in the isolated Windows VM)

Prerequisites: PowerShell 5.1 Script Block Logging enabled, TaskScheduler/Operational enabled, Sysmon optional for additional analysis, administrator visibility into logs, and an existing lab-only user `SOC-LabUser`. Use **only** your own VM.

Copy [`scripts/soc-monitor.ps1`](../scripts/soc-monitor.ps1) to `C:\SOC-Lab\Detections\soc-monitor.ps1` and ensure `C:\SOC-Lab\Detections` exists. Start a new Windows PowerShell session, then in that session (only if needed):

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
& 'C:\SOC-Lab\Detections\soc-monitor.ps1'
```

The monitor initializes at each channel's latest record and then polls every 5 seconds. Use an **ordinary** PowerShell console under `SOC-LabUser` to execute:

```powershell
Get-LocalUser | Select-Object Name, Enabled
```

If `\SOC-Lab-Notepad` is already configured with an at-logon trigger, a **new** lab user logon can generate its Event 200. Do not create or execute untrusted scheduled task payloads. Review alerts with:

```powershell
Get-Content 'C:\SOC-Lab\Detections\alerts.log'
```

Stop the monitor with `Ctrl+C`. Its log is not tamper-resistant; it is a learning aid, not a production audit store.

## Monitor limitations

- Fetches only up to 200 newest events per channel in each polling cycle, so high-volume periods can drop matching records.
- State is volatile; each restart starts fresh from the latest record and does not backfill missed events.
- Assumes `.Properties[0]` and `.Properties[1]` contain Task Scheduler 200 `TaskName` and `ActionName`, respectively.
- Relies on fixed test user, file path and process names; those choices are intentional for the lab.
- The Sigma PowerShell rule matches `Get-LocalUser` across accounts, while the local monitor additionally restricts matches to `SOC-LabUser`'s SID.
- Requires access to local event logs and the expected PowerShell channel.
