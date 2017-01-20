
## Morgan Atwood 5/5/2016
# This program is designed to show you computers serial number
#



$computers = Get-Content C:\Users\atwoodm\Desktop\computerlist.txt
$computers | foreach { Get-WmiObject -ComputerName $computers -Class Win32_BIOS | Select -Property PSComputerName,SerialNumber} | Out-File C:\Users\atwoodm\Desktop\computerlist_complete.txt