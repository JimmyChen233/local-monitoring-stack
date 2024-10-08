# Define the log file path
$logFilePath = "C:\path\to\your\backup-log.txt"

# Define the possible values for bkplevel and status
$bkplevelOptions = @(1, 2, 4, 1024, 2048, 8192, $null)
$statusOptions = @(1, 2, 3, 4)

# Function to generate random log content
function Generate-BackupLog {
    # Randomly select values for each argument
    $bkplevel = $bkplevelOptions | Get-Random
    $attempt = Get-Random -Minimum 1 -Maximum 100  # Random number greater than 1 for attempt
    $status = $statusOptions | Get-Random
    $job = Get-Random -Minimum 1000 -Maximum 9999  # Random job ID

    # Write the log content to the file
    $logContent = @"
-bkplevel
$bkplevel
-attempt
$attempt
-status
$status
-job
$job
"@

    # Write to log file (overwrite mode)
    Set-Content -Path $logFilePath -Value $logContent
    Write-Host "Log updated at $(Get-Date)"
}

# Generate log file every 5 minutes in an infinite loop
while ($true) {
    Generate-BackupLog
    Start-Sleep -Seconds 300  # Sleep for 5 minutes
}
