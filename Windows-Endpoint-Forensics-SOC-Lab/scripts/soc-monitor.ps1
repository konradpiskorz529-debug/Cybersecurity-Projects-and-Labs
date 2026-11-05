# SOC Lab monitoring prototype - training use only.
# Reconstructed from the version tested during the lab; it does not execute Sigma YAML.
# Requires local Windows event logs and a lab account named SOC-LabUser.
# Starts at the most recent record for each channel; previous events are intentionally skipped.

$psLog = 'Microsoft-Windows-PowerShell/Operational'
$taskLog = 'Microsoft-Windows-TaskScheduler/Operational'
$alertFile = 'C:\SOC-Lab\Detections\alerts.log'

$labSid = ([System.Security.Principal.NTAccount]"$env:COMPUTERNAME\SOC-LabUser").Translate(
    [System.Security.Principal.SecurityIdentifier]
).Value

$lastPsId = [long](Get-WinEvent -LogName $psLog -MaxEvents 1).RecordId
$lastTaskId = [long](Get-WinEvent -LogName $taskLog -MaxEvents 1).RecordId

Write-Host "SOC LAB - Monitoring started" -ForegroundColor Green
Write-Host "Watching PowerShell 4104 and Task Scheduler 200"
Write-Host "Press Ctrl+C to stop."

while ($true) {
    $psEvents = Get-WinEvent -FilterHashtable @{
        LogName = $psLog
        Id = 4104
    } -MaxEvents 200 -ErrorAction SilentlyContinue |
    Where-Object { $_.RecordId -gt $lastPsId } |
    Sort-Object RecordId

    foreach ($event in $psEvents) {
        if ($event.UserId -and
            $event.UserId.Value -eq $labSid -and
            $event.Message -match 'Get-LocalUser') {

            $alert = "[ALERT] $($event.TimeCreated) | PowerShell Local User Discovery | SOC-LabUser | LOW"
            Write-Host $alert -ForegroundColor Red
            Add-Content -Path $alertFile -Value $alert
        }
        $lastPsId = [Math]::Max($lastPsId, [long]$event.RecordId)
    }

    $taskEvents = Get-WinEvent -FilterHashtable @{
        LogName = $taskLog
        Id = 200
    } -MaxEvents 200 -ErrorAction SilentlyContinue |
    Where-Object { $_.RecordId -gt $lastTaskId } |
    Sort-Object RecordId

    foreach ($event in $taskEvents) {
        $taskName = [string]$event.Properties[0].Value
        $actionName = [string]$event.Properties[1].Value

        if ($taskName -eq '\SOC-Lab-Notepad' -and
            $actionName -like '*\notepad.exe') {

            $alert = "[ALERT] $($event.TimeCreated) | Scheduled Task Executed | $taskName | INFO"
            Write-Host $alert -ForegroundColor Yellow
            Add-Content -Path $alertFile -Value $alert
        }
        $lastTaskId = [Math]::Max($lastTaskId, [long]$event.RecordId)
    }

    Start-Sleep -Seconds 5
}
