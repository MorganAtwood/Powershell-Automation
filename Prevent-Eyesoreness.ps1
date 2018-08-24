#Morgan Atwood
#Date: 8/24/2018
#This is designed to prevent eye soreness from long computer screen exposure


$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch

#function

function Message {
    $msgBoxInput = [System.Windows.MessageBox]::Show('You Personal Message Here','Title','YesNo')
        switch  ($msgBoxInput) {

          'Yes' {

           Start-Sleep -m 1
           main
          }

          'No' {

          #Return to main
          main
        }
    }
}

function main {
# Start and Reset time
$StopWatch.Restart()

    while($StopWatch.IsRunning -eq $true)
    {

    #Converting to Minutes
    $min = $StopWatch.ElapsedMilliseconds / 60000
        #Every 20 minutes
        if ($min -ge 20 ){
            Message
        }

    } 

}

main
