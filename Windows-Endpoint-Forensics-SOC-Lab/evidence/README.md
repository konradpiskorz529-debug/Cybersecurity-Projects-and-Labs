# Evidence Index

The `screenshots/` directory contains selected **real screenshots supplied during the lab**, with a few crops to keep them focused and avoid publishing an identifiable host account in the macOS terminal prompt.

| File | What it illustrates |
| --- | --- |
| `alerts-log.png` | Two recorded local SOC monitor alerts after the live tests |
| `sigma-validation.png` | Sigma CLI 4.0.0 check result (0 errors, 0 condition errors, 0 issues); macOS prompt cropped |
| `powershell-4104.png` | PowerShell Event 4104 containing a lab account-discovery script block |
| `sysmon-powershell.png` | Sysmon Event 1 for PowerShell process (PID, logon ID, parent process) |
| `prefetch-powershell.png` | PECmd readout showing run count and historical run times |
| `task-200.png` | Task Scheduler Event 200 filtering with two laboratory task executions |

## Source/attribution caution

- Files here are **visual illustrations** retained from the step-by-step lab. They are not original raw `.evtx` data.
- `alert-sample.txt` is a **transcription** from the on-screen `alerts.log`, not the original log byte stream.
- Screenshots may still contain lab-only usernames, local IPs, file paths and machine details. Inspect them before public release.
- Original Event IDs and timestamps in the report are based on those displayed during the exercise; no formal integrity chain was established.
