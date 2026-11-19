Get-CimInstance Win32_Service |
Where-Object {

    $_.PathName -and

    # Not quoted
    $_.PathName -notmatch '^"' -and

    # Contains a space
    $_.PathName -match '\s' -and

    # Must have .exe after a space
    $_.PathName -match '\s.*\.exe' -and

    # Ignore Windows services
    $_.PathName -notmatch '^C:\\Windows\\'

} |
Select-Object Name,
DisplayName,
StartName,
StartMode,
PathName |
Format-List