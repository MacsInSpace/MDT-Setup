[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

$ISOs = "E:\ISOs"

$URL = @()
$URL = @("https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016","Srv2016"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019","Srv2019"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022","Srv2022"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-10-enterprise","Win10"),
("https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise","Win11") 

if (Test-Path -Path $ISOs) { 
    Write-Host "ISOs path exists"
    } else {
    mkdir $ISOs
    Write-Host "ISOs path now exists"
}

ForEach ($link in $URL) {
    if (Test-Path -Path "$ISOs\$($link[1])") { 
        Write-Host $ISOs\$($link[1])" path exists"
        } else {
        mkdir "$ISOs\$($link[1])"
        Write-Host "$ISOs\$($link[1]) path now exists"
    }
        if (Test-Path -Path "$ISOs\$($link[1])\mount") { 
        Write-Host "$ISOs\$($link[1])\mount path exists"
        } else {
        mkdir "$ISOs\$($link[1])\mount"
        Write-Host "$ISOs\$($link[1])\mount path now exists"
    }
        if (Test-Path -Path "$ISOs\$($link[1])\source") { 
        Write-Host "$ISOs\$($link[1])\source path exists"
        } else {
        mkdir "$ISOs\$($link[1])\source"
        Write-Host "$ISOs\$($link[1])\source path now exists"
    }
        if (Test-Path -Path "$ISOs\$($link[1])\updatecab") { 
        Write-Host "$ISOs\$($link[1])\updatecab path exists"
        } else {
        mkdir "$ISOs\$($link[1])\updatecab"
        Write-Host "$ISOs\$($link[1])\updatecab path now exists"
    }
    $OSURL = (((Invoke-WebRequest -UseBasicParsing -Uri $($link[0])).Links | 
        Where-Object {($_.href -like "https://go.microsoft.com/fwlink/p/?linkID=*&culture=en-us&country=US")`
            -and ($_.outerHTML -like "*Download Windows*")`
            -and ($_.outerHTML -notlike "*Azure*")`
            -and ($_.outerHTML -notlike "*32-bit*")`
            -and ($_.outerHTML -notlike "*LTSC*")`
            -and ($_.outerHTML -notlike "*VHD*")
        }).href)

        Write-Host "Downloading $($link[1])..."
        Start-BitsTransfer -Source $OSURL -Destination "$ISOs\$($link[1])\$($link[1])_Eval.iso" -Priority high
    Write-Host "Downloading of Eval ISO $($link[1]) complete."
}

Write-Host "Eval ISO downloads complete."

