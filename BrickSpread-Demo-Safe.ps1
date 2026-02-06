# =============================================================================
# BRICK SPREAD - SAFE EDUCATIONAL DEMO
# =============================================================================
# For academic use only. This script SIMULATES the behavior of destructive
# "bricker" malware WITHOUT modifying or deleting any real files or systems.
# Use only in isolated lab VMs for coursework demonstration.
# =============================================================================

$LogPath = "C:\BrickSpread-Demo-Log.txt"

function Write-DemoLog {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Write-Host $line
    Add-Content -Path $LogPath -Value $line -ErrorAction SilentlyContinue
}

# -----------------------------------------------------------------------------
# 1. SIMULATED "SYSTEM BRICK" (no actual deletion)
# -----------------------------------------------------------------------------
Write-DemoLog "=== DEMO: Simulated system brick (no files are actually deleted) ==="
Write-DemoLog "[SIMULATED] Would execute: Remove-Item C:\Windows\System32 -Recurse -Force"
Write-DemoLog "[SIMULATED] Would execute: Remove all files on C:\"
Write-DemoLog "In real malware, the system would now be unusable. In this demo, nothing was changed."

# -----------------------------------------------------------------------------
# 2. NETWORK DISCOVERY (read-only - just finds other machines)
# -----------------------------------------------------------------------------
Write-DemoLog "=== DEMO: Network discovery (scanning for devices) ==="

try {
    # Get this machine's IPv4 address and infer subnet
    $MyIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" } | Select-Object -First 1).IPAddress
    if (-not $MyIP) {
        Write-DemoLog "Could not detect local IP. Using 192.168.1.0/24 for demo."
        $SubnetBase = "192.168.1"
    } else {
        $SubnetBase = ($MyIP -split '\.')[0..2] -join '.'
    }

    Write-DemoLog "Local subnet base: $SubnetBase.x"

    $DiscoveredHosts = @()
    # Scan first 20 addresses in subnet (safe, read-only ping)
    foreach ($i in 1..20) {
        $TargetIP = "$SubnetBase.$i"
        if ($TargetIP -eq $MyIP) { continue }
        if (Test-Connection -ComputerName $TargetIP -Count 1 -Quiet -ErrorAction SilentlyContinue) {
            Write-DemoLog "  Found reachable host: $TargetIP"
            $DiscoveredHosts += $TargetIP
        }
    }

    Write-DemoLog "Total hosts discovered: $($DiscoveredHosts.Count)"

    # -------------------------------------------------------------------------
    # 3. SIMULATED "SPREAD" (no remote execution - only logging)
    # -------------------------------------------------------------------------
    Write-DemoLog "=== DEMO: Simulated spread (no payload is sent or executed) ==="
    foreach ($IP in $DiscoveredHosts) {
        Write-DemoLog "[SIMULATED] Would copy script to \\$IP\C$\bricker.ps1"
        Write-DemoLog "[SIMULATED] Would execute remotely on $IP (Invoke-Command / PsExec-style)"
        Write-DemoLog "  -> In real malware, device $IP would be bricked. In this demo, no action was taken."
    }
} catch {
    Write-DemoLog "Network discovery error (OK in isolated lab): $($_.Exception.Message)"
}

Write-DemoLog "=== Demo complete. Log saved to: $LogPath ==="
Write-Host ""
Write-Host "No systems were modified. This was a safe simulation only." -ForegroundColor Green
