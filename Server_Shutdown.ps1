#Morgan Atwood 08/25/2016

# Hostnames TXT Location - Edit this line to fit your install path
$hostnamestxt = "C:\Scripts\Server_SD_Script\hosts.txt"



$servers = get-content "$hostnamestxt"


# Main Menu Function
Function Main_Menu {
	  Write-Host " Welcome to the MorganAtwood.info Server Shutdown/Reboot Script!                 " -foregroundcolor white -backgroundcolor Green
	  Write-Host "                                                                              " -foregroundcolor black -backgroundcolor white
	  Write-Host " This script will allow you to mass shutdown/reboot and check the status of   " -foregroundcolor blue -backgroundcolor white
	  Write-Host " all servers found in the hosts.txt                                           " -foregroundcolor blue -backgroundcolor white
	  Write-Host "                                                                              " -foregroundcolor blue -backgroundcolor white
	  Write-Host " "
	  Write-Host " Current location of the hosts.txt file: $hostnamestxt" -foregroundcolor black -backgroundcolor green
	  $choices = [Management.Automation.Host.ChoiceDescription[]] ( `
      (new-Object Management.Automation.Host.ChoiceDescription "&1 List of Servers","List of Servers"),
	  (new-Object Management.Automation.Host.ChoiceDescription "&2 Edit Hosts.txt","Edit Hosts.txt"),	  
      (new-Object Management.Automation.Host.ChoiceDescription "&3 Check Server Status","Check Server Status"),
  	  (new-Object Management.Automation.Host.ChoiceDescription "&4 Shutdown/Reboot Servers","Shutdown/Reboot Servers."),
	  (new-Object Management.Automation.Host.ChoiceDescription "&Exit.","Exit"));
	$answer = $host.ui.PromptForChoice("Server Shutdown-Reboot Tool", "Which action would you like to perform?", $choices, 4)
if ($answer -eq 0) {
  Write-Host "Servers in host.txt:" -foregroundcolor white -backgroundcolor blue
  Write-Host "---------------------------"
  $servers
  Write-Host "---------------------------"
  Pause
  cls
  Main_Menu
} elseif ($answer -eq 1) {
    notepad.exe hosts.txt
  Write-Host "Updating $hostnamestxt...            " -foregroundcolor white -backgroundcolor blue
  Pause
  $servers = get-content "$hostnamestxt"
  cls
  Main_Menu
} elseif ($answer -eq 2) {
    Server_Status_Check
  Pause
  cls
  Main_Menu
} elseif ($answer -eq 3) {
  Server_Reboot_Shutdown_Menu
  cls
  Main_Menu
} elseif ($answer -eq 4) {

  Write-Host " "
  Write-Host "Exiting Application...Goodbye!" -foregroundcolor white -backgroundcolor blue
  Write-Host " "
} 

}

# Pause Function
Function Pause {
  Write-Host "Press Any Key To Continue..." -foregroundcolor gray -backgroundcolor blue
  $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") >$null
  }

# Server_Reboot_Shutdown_Menu - Prompts for Shutdown or Reboot
Function Server_Reboot_Shutdown_Menu {
	$choices1 = [Management.Automation.Host.ChoiceDescription[]] ( `
    (new-Object Management.Automation.Host.ChoiceDescription "&Reboot Servers","Reboot Servers"),
    (new-Object Management.Automation.Host.ChoiceDescription "&Shutdown Servers","Shutdown Servers"),
	(new-Object Management.Automation.Host.ChoiceDescription "&Exit to Main Menu","&Exit to Main Menu"));
	$answer1 = $host.ui.PromptForChoice("Server Reboot/Shutdown", "Which action would you like to perform?", $choices1, 2)
	if ($answer1 -eq 0) {
		Server_Reboot
		} elseif ($answer1 -eq 1) {
        Server_Shutdown
		} elseif ($answer1 -eq 2) {
        
		}
}

# Server_Shutdown Function - Pings and then Shuts Down All Servers in hosts.txt
Function Server_Shutdown {
    Write-Host "                                                                "
    Write-Host "                                                                " -foregroundcolor black -backgroundcolor red
    Write-Host " CAUTION! All host names in the host.txt file will be SHUTDOWN! " -foregroundcolor black -backgroundcolor red
    Write-Host "                                                                " -foregroundcolor black -backgroundcolor red
	$choices2 = [Management.Automation.Host.ChoiceDescription[]] ( `
    (new-Object Management.Automation.Host.ChoiceDescription "&Yes","Yes"),
	(new-Object Management.Automation.Host.ChoiceDescription "&No","No"));
	$answer2 = $host.ui.PromptForChoice("Server Shutdown", "Are you sure you want to continue?", $choices2, 1)
	if ($answer2 -eq 0) {
		write-host "Server Shutdown begin..." -foregroundcolor white -backgroundcolor blue
		Write-Host "---------------------------"
		$shutdown_reason = Read-Host "Server shutdown reason/comment"
        foreach($server in $servers){
			ping -n 2 $server >$null
			if($lastexitcode -eq 0){
				write-host "Shutting Down $server..." -foregroundcolor black -backgroundcolor green
				shutdown /s /f /m \\$server /d p:1:1 /t 01 /c "$shutdown_reason"
			} else {
				write-host "$server is OFFLINE/UNREACHABLE" -foregroundcolor black -backgroundcolor red
				}
			}
			Write-Host "---------------------------"
			Pause
		} elseif ($answer2 -eq 1) {

			} 
}

# Server_Reboot Function - Pings and then Shuts Down All Servers in hosts.txt
Function Server_Reboot {
    Write-Host "                                                                "
    Write-Host "                                                                " -foregroundcolor black -backgroundcolor red
    Write-Host " CAUTION! All host names in the host.txt file will be REBOOTED! " -foregroundcolor black -backgroundcolor red
    Write-Host "                                                                " -foregroundcolor black -backgroundcolor red
	$choices3 = [Management.Automation.Host.ChoiceDescription[]] ( `
    (new-Object Management.Automation.Host.ChoiceDescription "&Yes","Yes"),
	(new-Object Management.Automation.Host.ChoiceDescription "&No","No"));
	$answer3 = $host.ui.PromptForChoice("Server Reboot", "Are you sure you want to continue?", $choices3, 1)
	if ($answer3 -eq 0) {
		write-host "Server Reboot begin..." -foregroundcolor white -backgroundcolor blue
		Write-Host "---------------------------"
        $reboot_reason = Read-Host "Server reboot reason/comment"
		foreach($server in $servers){
			ping -n 2 $server >$null
			if($lastexitcode -eq 0){
				write-host "Rebooting $server..." -foregroundcolor black -backgroundcolor green
				shutdown /r /f /m \\$server /d p:1:1 /t 01 /c "$reboot_reason"
			} else {
				write-host "$server is OFFLINE/UNREACHABLE" -foregroundcolor black -backgroundcolor red
				}
			}
			Write-Host "---------------------------"
			Pause
		} elseif ($answer3 -eq 1) {

			} 
}

# Server_Status_Check Function - Pings Servers from hosts.txt and then shows Online/Offline
Function Server_Status_Check {
write-host "Checking Status of Servers..." -foregroundcolor white -backgroundcolor blue
Write-Host "---------------------------"
foreach($server in $servers){
		ping -n 3 $server >$null
		if($lastexitcode -eq 0) {
			write-host "$server is ONLINE" -foregroundcolor black -backgroundcolor green
		} else {
			write-host "$server is OFFLINE/UNREACHABLE" -foregroundcolor black -backgroundcolor red
		}
	}
	Write-Host "---------------------------"
}

cls
Main_Menu
