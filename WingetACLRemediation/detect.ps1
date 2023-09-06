$ErrorActionPreference = "SilentlyContinue"
$Error.Clear()

$paths = get-childitem "C:\users\*\appdata\local\microsoft\winget" -Recurse | select -ExpandProperty fullname

#recursive get-childitem will error out if the permissions on the winget state folder aren't set up correctly
if ($?){exit 0}else{exit 1}
