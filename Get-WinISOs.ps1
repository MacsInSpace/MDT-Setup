[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

$Location = $env:temp

$URL = @()
$URL = @("https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016","srv2016"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019","srv2019"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022","srv2022"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-10-enterprise","Win10"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise","Win11") 


ForEach ($link in $URL) {
$OSURL = (((Invoke-WebRequest -UseBasicParsing -Uri $($link[0])).Links | 
Where-Object {($_.href -like "https://go.microsoft.com/fwlink/p/?linkID=*&culture=en-us&country=US")`
    -and ($_.outerHTML -like "*Download Windows*")`
    -and ($_.outerHTML -notlike "*Azure*")`
    -and ($_.outerHTML -notlike "*32-bit*")`
    -and ($_.outerHTML -notlike "*LTSC*")`
    -and ($_.outerHTML -notlike "*VHD*")}).href)
Write-Host "$($link[1]) = $OSURL
"
Write-Host "Downloading $($link[1])..."
Start-BitsTransfer -Source $OSURL -Destination "$Location\$($link[1]).iso" -Priority high
"ISO $($link[1]) complete."
}

Write-Host "ISO downloads complete."

