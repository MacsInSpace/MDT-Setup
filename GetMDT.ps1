# Gets the latest links For MDT, the ADK and the WinPE

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

$Location = $env:temp

$ADKURL = ((Invoke-WebRequest -UseBasicParsing -Uri "https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install").Links | 
Where-Object {($_.href -like "https://go.microsoft.com/fwlink/?linkid=*") -and ($_.outerHTML -like "*Download the Windows ADK*")}).href

Write-Host "MDT ADK link is $ADKURL"
Start-BitsTransfer -Source $ADKURL -Destination "$Location\ADK.msi" -Priority high


$ADKPEURL = ((Invoke-WebRequest -UseBasicParsing -Uri "https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install").Links | 
Where-Object {($_.href -like "https://go.microsoft.com/fwlink/?linkid=*") -and ($_.outerHTML -like "*Download the Windows PE add-on for the Windows ADK*")}).href

Write-Host "MDT ADK Win PE link is $ADKPEURL"
Start-BitsTransfer -Source $ADKPEURL -Destination "$Location\ADKPE.msi" -Priority high

$pagelink = ((Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/mdtdownload").Links | 
Where-Object {($_.href -like "*confirmation.aspx?id=*") -and ($_.class -like "*download-button*")}).href

$MDTURL = ((Invoke-WebRequest -UseBasicParsing -Uri "https://www.microsoft.com/en-us/download/$pagelink").Links | 
Where-Object {$_.href -like "*MicrosoftDeploymentToolkit_x64.msi*"}).href | Select-Object -first 1

Write-Host "MDT link is $MDTURL"
Start-BitsTransfer -Source $MDTURL -Destination "$Location\MicrosoftDeploymentToolkit_x64.msi" -Priority high
