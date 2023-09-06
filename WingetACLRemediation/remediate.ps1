$ACL_error_state = $true
function fix-WingetACL{

    $Error.Clear()
    $ErrorActionPreference = "SilentlyContinue"
    $SYSTEM = ([wmi]"win32_SID.SID='S-1-5-18'").referenceddomainname + "\" +([wmi]"win32_SID.SID='S-1-5-18'").accountname
    $ADMINISTRATORS = ([wmi]"win32_SID.SID='S-1-5-32-544'").referenceddomainname + "\" +([wmi]"win32_SID.SID='S-1-5-32-544'").accountname
    $paths = get-childitem "C:\users\*\appdata\local\microsoft\winget" -Recurse | select -ExpandProperty fullname

    ForEach ($path in $paths) {

        $Acl = Get-Acl $path

        $Ar_system = New-Object System.Security.AccessControl.FileSystemAccessRule($SYSTEM, "FullControl", "Allow")
        $Ar_administrators = New-Object System.Security.AccessControl.FileSystemAccessRule($ADMINISTRATORS, "FullControl", "Allow")

        $Acl.AddAccessRule($Ar_system)
        $Acl.AddAccessRule($Ar_administrators)

        Set-Acl -Path $path -AclObject $Acl

    }
    #if there is anything in the state folders we don't have access to, there will be an error
    if($error) {return $true} else {return $false}
}


while ($ACL_error_state) {
    #do it while we have errors
    $ACL_error_state = fix-WingetACL
}
