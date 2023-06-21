<powershell>
$instanceId = Invoke-RestMethod -UseBasicParsing -Uri '169.254.169.254/latest/meta-data/instance-id'
$region = Invoke-RestMethod -UseBasicParsing -Uri '169.254.169.254/latest/meta-data/placement/region'
Install-WindowsFeature -name Web-Server -IncludeManagementTools
New-Item -Path "C:\inetpub\wwwroot\Default.htm" -ItemType File -Value "$instanceId from region $region" -Force
</powershell>