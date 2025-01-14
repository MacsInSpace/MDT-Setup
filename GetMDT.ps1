[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

$Location = $env:temp


# Uninstall

$SoftwareName="Windows Assessment and Deployment Kit"
$SoftwareALTName="Microsoft Deployment Toolkit"
$MyApp = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  |
    Get-ItemProperty |
        Where-Object {$_.DisplayName -like "*$SoftwareName*" -or $_.DisplayName -like "*$SoftwareALTName*"} |
            Select-Object -Property DisplayName, UninstallString, DisplayVersion

ForEach ($App in $MyApp) {


    If ($App.UninstallString) {
        Write-Host Uninstalling $SoftwareName...

        $uninst = $App.UninstallString
        & cmd /c $uninst /quiet /norestart
    }

}

# ADK Get URL

$ADKURL = ((Invoke-WebRequest -UseBasicParsing -Uri "https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install").Links | 
Where-Object {($_.href -like "https://go.microsoft.com/fwlink/?linkid=*") -and ($_.outerHTML -like "*Download the Windows ADK*")}).href

# ADK Download

Write-Host "MDT ADK link is $ADKURL"
Start-BitsTransfer -Source $ADKURL -Destination "$Location\ADK.exe" -Priority high

# ADK INSTALL
# For a complete list of all available features run $Location\ADK.exe /list
Write-Host "Installing ADK
    For a complete list of all available features run $Location\ADK.exe /list"
Start-Process $Location\ADK.exe -ArgumentList "/features OptionId.DeploymentTools OptionId.ICDConfigurationDesigner OptionId.ImagingAndConfigurationDesigner OptionId.UserStateMigrationTool /q" -Wait


# ADK WinPE Get URL

$ADKPEURL = ((Invoke-WebRequest -UseBasicParsing -Uri "https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install").Links | 
Where-Object {($_.href -like "https://go.microsoft.com/fwlink/?linkid=*") -and ($_.outerHTML -like "*Download the Windows PE add-on for the Windows ADK*")}).href

# ADK WinPE Download

Write-Host "MDT ADK Win PE link is $ADKPEURL"
Start-BitsTransfer -Source $ADKPEURL -Destination "$Location\ADKPE.exe" -Priority high

# ADK WinPE INSTALL

Write-Host "Installing ADKPE"
Start-Process $Location\ADKPE.exe -ArgumentList "/features + /q" -Wait


# MDT Get URL

# $pagelink = ((Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/mdtdownload").Links | 
# Where-Object {($_.href -like "*confirmation.aspx?id=*") -and ($_.class -like "*download-button*")}).href

# $MDTURL = ((Invoke-WebRequest -UseBasicParsing -Uri "https://www.microsoft.com/en-us/download/$pagelink").Links | 
# Where-Object {$_.href -like "*MicrosoftDeploymentToolkit*x64.msi*"}).href | Select-Object -first 1

# Thanks Nathan Stockton for finding this one when MS changed it....

$response = Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/mdtdownload"
$html = $response

$findDownloadObject = [regex]::Match($html.Content, '"downloadFile":(.*?)]')
$downloadObject = ($findDownloadObject.Groups[1].Value+"]") | ConvertFrom-Json

if ($downloadObject.url) {
    $MDTURL = $downloadObject.url
    Write-Host $MDTURL
} else {
    Write-Host "Couldn't find download location"
}

# MDT Download

Write-Host "MDT link is $MDTURL"
Start-BitsTransfer -Source $MDTURL -Destination "$Location\MicrosoftDeploymentToolkit_x64.msi" -Priority high

# MDT INSTALL

Write-Host "Installing MDT"
Start-Process msiexec -ArgumentList "/i $Location\MicrosoftDeploymentToolkit_x64.msi /qn" -Wait
