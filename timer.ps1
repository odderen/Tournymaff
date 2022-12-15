Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName PresentationFramework
[System.Windows.Forms.Application]::EnableVisualStyles()

#hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)
$global:timeinround = 0

#create form elements
$myForm                          = New-Object system.Windows.Forms.Form
$myForm.ClientSize               = New-Object System.Drawing.Point(277,200)
$myForm.text                     = "Stopwatch"
$myForm.TopMost                  = $false
$myForm.BackColor = "white"

$lblTime                         = New-Object system.Windows.Forms.Label
$lblTime.AutoSize                = $true
$lblTime.width                   = 40
$lblTime.height                  = 10
$lblTime.location                = New-Object System.Drawing.Point(30,30)
$lblTime.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',55)


$btnStart                        = New-Object system.Windows.Forms.Button
$btnStart.text                   = "Start"
$btnStart.width                  = 105
$btnStart.height                 = 30
$btnStart.location               = New-Object System.Drawing.Point(1,128)
$btnStart.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$btnStart.BackColor ="green"

$btnPause                        = New-Object system.Windows.Forms.Button
$btnPause.text                   = "Pause"
$btnPause.width                  = 105
$btnPause.height                 = 30
$btnPause.location               = New-Object System.Drawing.Point(110,128)
$btnPause.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$btnPause.BackColor ="yellow"

$btnEdit                        = New-Object system.Windows.Forms.Button
$btnEdit.text                   = "Edit"
$btnEdit.width                  = 55
$btnEdit.height                 = 30
$btnEdit.location               = New-Object System.Drawing.Point(220,128)
$btnEdit.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$btnEdit.BackColor ="white"

$btnReset                        = New-Object system.Windows.Forms.Button
$btnReset.text                   = "Reset"
$btnReset.width                  = 274
$btnReset.height                 = 37
$btnReset.location               = New-Object System.Drawing.Point(1,160)
$btnReset.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',14)
$btnReset.BackColor ="red"

$myForm.controls.AddRange(@($lblTime,$btnStart,$btnPause,$btnReset,$btnEdit))

#initialize time to 4500
$global:currTime = 4500
$ti = New-TimeSpan -Seconds $global:currTime
$lblTime.Text = "$( '{0:d2}' -f (($ti.TotalMinutes.ToString().Split(','))[0]) ):$('{0:d2}' -f [int]$ti.Seconds)"


#actions to take each timer tick
Function Count {
	if($global:currTime -ne 0){
		$global:currTime -= 1
		$ti = New-TimeSpan -Seconds $global:currTime
		$lblTime.Text = "$( '{0:d2}' -f (($ti.TotalMinutes.ToString().Split(','))[0]) ):$('{0:d2}' -f [int]$ti.Seconds)"
	}
	elseif($global:timeinround -ne 1){
		Add-Type -AssemblyName System.speech
		$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
		$speak.Speak('Time in round!')
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(932,150)
		Start-Sleep -m 150
		[console]::beep(1047,150)
		Start-Sleep -m 150
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(699,150)
		Start-Sleep -m 150
		[console]::beep(740,150)
		Start-Sleep -m 150
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(932,150)
		Start-Sleep -m 150
		[console]::beep(1047,150)
		Start-Sleep -m 150
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(784,150)
		Start-Sleep -m 300
		[console]::beep(699,150)
		Start-Sleep -m 150
		[console]::beep(740,150)
		Start-Sleep -m 150
		[console]::beep(932,150)
		[console]::beep(784,150)
		[console]::beep(587,1200)
		Start-Sleep -m 75
		[console]::beep(932,150)
		[console]::beep(784,150)
		[console]::beep(554,1200)
		Start-Sleep -m 75
		[console]::beep(932,150)
		[console]::beep(784,150)
		[console]::beep(523,1200)
		Start-Sleep -m 150
		[console]::beep(466,150)
		[console]::beep(523,150)
		$global:timeinround = 1
		$global:currTime = 600
	}
	elseif($global:timeinround -eq 1){
		Add-Type -AssemblyName System.speech
		$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
		$speak.Speak('Round Over!')
		[console]::beep(440,500)      
		[console]::beep(440,500)
		[console]::beep(440,500)       
		[console]::beep(349,350)       
		[console]::beep(523,150)       
		[console]::beep(440,500)       
		[console]::beep(349,350)       
		[console]::beep(523,150)       
		[console]::beep(440,1000)
		[console]::beep(659,500)       
		[console]::beep(659,500)       
		[console]::beep(659,500)       
		[console]::beep(698,350)       
		[console]::beep(523,150)       
		[console]::beep(415,500)       
		[console]::beep(349,350)       
		[console]::beep(523,150)       
		[console]::beep(440,1000)
		$global:timeinround = 0
		$global:currTime = 4500
		$timer.Stop()
		$lblTime.Text = "$( '{0:d2}' -f (($ti.TotalMinutes.ToString().Split(','))[0]) ):$('{0:d2}' -f [int]$ti.Seconds)"
	}
}

#create timer
$timer=New-Object System.Windows.Forms.Timer
$timer.Interval=1000
$timer.add_Tick({Count})
$timer.Stop()

#start button
$btnStart.Add_Click({
	$timer.Start()	
})

#pause button
$btnPause.Add_Click({
	$timer.Stop()	
})

#reset button
$btnReset.Add_Click({
	$timer.Stop()
	$global:currTime = 4500
	$ti = New-TimeSpan -Seconds $global:currTime
	$global:timeinround = 0
	$lblTime.Text = "$( '{0:d2}' -f (($ti.TotalMinutes.ToString().Split(','))[0]) ):$('{0:d2}' -f [int]$ti.Seconds)"
})

#Edit button
$btnEdit.Add_Click({
$timer.Stop()	
$title = 'Edit time'
$msg   = 'Enter new time in seconds'
$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
if ($text -ne ''){
    $global:currTime = $text
	$ti = New-TimeSpan -Seconds $global:currTime
	$lblTime.Text = "$( '{0:d2}' -f (($ti.TotalMinutes.ToString().Split(','))[0]) ):$('{0:d2}' -f [int]$ti.Seconds)"
   }
 
}
)

[void]$myForm.ShowDialog()