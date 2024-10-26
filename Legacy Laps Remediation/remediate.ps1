$guid = "{EA8CB806-C109-4700-96B4-F1F268E5036C}"

$fingerprint_path = "c:\programdata\legacy_laps_fingerprint"
$fingerprint_filepath = "c:\programdata\legacy_laps_fingerprint\readme.txt"

$exists = get-winevent -ListLog 'Microsoft-Windows-LAPS/Operational' -ErrorAction SilentlyContinue
$test = test-path $fingerprint_path
if (!$exists){
    $OSInfo = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | select productname,displayversion
    $message = "Incompatible Operating System: " + $OSInfo.ProductName + " " + $OSInfo.DisplayVersion
    
    if (!$test){
        mkdir $fingerprint_path
        "This folder exists to mark the device for the WMI Filter called Comptuter DOES NOT Support Windows Laps.`nThis allows us to pinpoint machines for installing the LAPS CSE and apply GPO to write LAPS PAssword to AD.`nDevices that don't have this are writing LAPS password to Intune and receive policy from Intune." | Out-File $fingerprint_filepath -Force
    } # fingerprinting device for WMI Filter to allow the legacy laps GPO
    Write-Output $message
    Exit 1
} else {
    msiexec /X $guid /QN
    Start-Sleep -Seconds 120
    gpupdate /force | Out-Null
    if($test){remove-item $fingerprint_path -Recurse -Force}
    Exit 0
}

