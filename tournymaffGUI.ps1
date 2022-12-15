Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Drawing;
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Tournymaff'
$main_form.WindowState = 'Maximized'
$main_form.AutoSize = $true
$Main_Form.BringToFront()
$main_Form.BackColor = "sandybrown"
#Players
Class Player {
    [string]$Name
    [float]$Point = 0
    [array]$Played
}

class byeopp {
    [string]$Name
    [float]$Point = 0
    [array]$Played
}

$global:location=Get-Location
$global:Players = @()
$global:byeopps = @()
$global:i = 1
$global:IndexStart = 0
$global:IndexEnd = 3
$global:RoundNR = 1
$byeopp1 = New-Object -TypeName byeopp -Property @{Name = "Empty"; point = 0; played = 0}
$global:byeopps += $byeopp1 
$global:byeopps += $byeopp1
$global:byeopps += $byeopp1
#Label
$Label = New-Object System.Windows.Forms.label
$Label.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Label.Size = New-Object System.Drawing.Size(300,800)
$Label.AutoSize = $true
$Label.Location  = New-Object System.Drawing.Point(1000,10)
$Label.Text=$null
$Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
$Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$main_form.Controls.Add($Label)

$CurrentPairings = New-Object System.Windows.Forms.label
$CurrentPairings.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$CurrentPairings.Size = New-Object System.Drawing.Size(300,800)
$CurrentPairings.AutoSize = $true
$CurrentPairings.Location  = New-Object System.Drawing.Point(10,600)
$CurrentPairings.Text = ("Current pairings: `n$($CurrentPairings_array1)")
$CurrentPairings.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$main_form.Controls.Add($CurrentPairings)


#Standings
function Standings{
    $global:standing_array1=@()
    [string]$global:standing_array1
        foreach($stand in $global:Players | Sort-Object Point -Descending) {
         $global:standing_array1+="$($stand.name): $($stand.point) `n"
        }
}

function CurrentPairings{
    $global:CurrentPairings_array1=@()
    [string]$global:CurrentPairings_array1
        foreach($pod in $temppod | Sort-Object Point -Descending) {
         $global:CurrentPairings_array1+="$($pod.id): $($pod.players -join ', ' ) `n"
        }
}




#Buttons
$Button_addplayer = New-Object System.Windows.Forms.Button
$Button_addplayer.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_addplayer.BackColor = [System.Drawing.Color]::FromArgb(190,0,255,0)
$Button_addplayer.Location = New-Object System.Drawing.Size(10,40)
$Button_addplayer.Size = New-Object System.Drawing.Size(320,160)
$Button_addplayer.Text = "Add player"
$main_form.Controls.Add($Button_addplayer)
$Button_addplayer.Add_Click(
{
$title = 'Add player'
$msg   = 'Enter name of player to add:'

$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
    if ($text -ne ''){
        if ($text -notin $global:players.name) {
       [void] [System.Windows.MessageBox]::Show( "$text added", "Add player", "Ok", "Information" )
        $Player = [Player]::New()
        $Player.Name = $text
        $global:Players += $Player
    }
    else{
        [void] [System.Windows.MessageBox]::Show( "$text Already registered, please add a letter or other unique identifier and try again", "Player already registered", "Ok", "Information" )
    }
    Standings
    $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
    }
}
)


$Button_Pairings = New-Object System.Windows.Forms.Button
$Button_Pairings.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_Pairings.Location = New-Object System.Drawing.Size(10,205)
$Button_Pairings.Size = New-Object System.Drawing.Size(320,160)
$Button_Pairings.Text = "Make pairings"
$Button_Pairings.BackColor = [System.Drawing.Color]::FromArgb(150,255,255,255)
$main_form.Controls.Add($Button_Pairings)
$Button_Pairings.Add_Click(
{
        $Descendingsort = $global:players | Sort-Object -Property point -Descending
        $RandomList = $global:Players | Sort-Object {Get-Random}
        while ($RandomList.point[-1] -gt $Descendingsort.point[-1] -and $RoundNR -ne 1)
        {
            $RandomList = $global:Players | Sort-Object {Get-Random}
        }
        $global:i = 1
        $global:IndexStart = 0
        $Global:Size=4
        $global:IndexEnd = $global:Size-1
        $Global:Pod = ''
        [array]$tempPod = @()

        While ($true) {
            if (0 -eq $Players.count % 2 -and 0 -ne $Players.count % 4) {
            
                $Global:Size = 3
                $global:IndexEnd = $global:IndexEnd-1
                $PlayersInScope = $RandomList[$global:IndexStart..$global:IndexEnd]

                if ($PlayersInScope.count -le 0) {break}

                [hashtable]$ObjProperty = [Ordered]@{
                    ID = $i
                    Players = @( $PlayersInScope.Name )
                }
                $tempPod += New-Object -TypeName PSObject -Property $ObjProperty
              
                if($global:i -eq 1){
                    $global:IndexStart = $global:IndexStart + $Global:Size 
                    $global:IndexEnd = $global:IndexEnd + $Global:Size + 1
                }
                elseif($global:i -eq 2){
                    $global:IndexStart = $global:IndexStart + $Global:Size 
                    $global:IndexEnd = $global:IndexEnd + $Global:Size + 2
                }
                else{
                    $global:IndexStart = $global:IndexStart + $Global:Size + 1
                    $global:IndexEnd = $global:IndexEnd + $Global:Size + 2
                }
            }
            else {
                $PlayersInScope = $RandomList[$global:IndexStart..$global:IndexEnd]
                if ($PlayersInScope.count -le 0) {break}

                [hashtable]$ObjProperty = [Ordered]@{
                    ID = $i
                    Players = @( $PlayersInScope.Name )
                }
                $tempPod += New-Object -TypeName PSObject -Property $ObjProperty

                $global:IndexStart = $global:IndexStart + $Global:Size 
                $global:IndexEnd = $global:IndexEnd + $Global:Size 
            }

            $global:i++
                        
        }

        # Format the pods to display
        $formatedTempPod = ""
        $tempPod | ForEach-Object {
            $formatedTempPod = $formatedTempPod + "$($_.ID): $( $_.Players -join ', ' )`n" 
        }
        $formatedTempPod = $formatedTempPod + "`n"

        # Accept pods
        if([System.Windows.Forms.MessageBox]::Show(("$($formatedTempPod) Accept these pairings?"), "Question",[System.Windows.Forms.MessageBoxButtons]::OKCancel) -eq "OK"){
            
            Standings 
            $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
            $Players | Select-Object Point,Name | Sort-Object Point -Descending | out-file  $global:location"\$((Get-Date).ToString("yyyyMMdd_HHMMss")) Standings.csv" -Append -force 
            $formatedTempPod | out-file  $global:location"\$((Get-Date).ToString("yyyyMMdd")) Runde $global:RoundNR.csv" -Append -force
            if (-not (test-path $global:location"\$((Get-Date).ToString("yyyyMMdd")) Runde $global:RoundNR.csv")) {
                "Pod nr,Podmembers" | out-file  $global:location"\$((Get-Date).ToString("yyyyMMdd")) Runde $global:RoundNR.csv" -Append -force
            }
            $global:RoundNR++

            # Add opponents to players if the pod is approved
            Foreach ($pod in $tempPod) {
                foreach ($tmpPlayer in $pod.Players) {
                    $ActualPlayer = $global:Players | Where-Object { $_.Name -eq $tmpPlayer}
                    # If only one player in the pod add byes
                    if ($pod.Players.count -eq 1) {                        
                        $ActualPlayer.Played +=  $global:byeopps 
                    }
                    # else add each opponent from the pod to the Played propertie
                    else {
                        $ActualPlayer.Played += $global:Players | Where-Object { $pod.Players -match "^$($_.Name)$" -and $_.Name -ne $tmpPlayer }
                    }
                }               
            }
            CurrentPairings
            $CurrentPairings.Text = ("Current pairings: `n$($CurrentPairings_array1)")
        }
        write-Host $global:Players
        
    }
)

$Button_Winner = New-Object System.Windows.Forms.Button
$Button_Winner.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_Winner.Location = New-Object System.Drawing.Size(335,40)
$Button_Winner.Size = New-Object System.Drawing.Size(320,160)
$Button_Winner.Text = "Add winner"
$Button_Winner.BackColor = [System.Drawing.Color]::FromArgb(150,255,255,255)
$main_form.Controls.Add($Button_Winner)
$Button_Winner.Add_Click({
    $title = 'Add winner'
    $msg   = 'Enter name of winner:'
    $text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
    if ($text -ne ''){
        $Winner=$global:Players|Where-Object name -eq $text
        $Winner.Point=$Winner.Point+5
        [void] [System.Windows.MessageBox]::Show( "5 points given to $text", "Add winner", "Ok", "Information" )
    }
    Standings
    $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
})


$Button_Bye = New-Object System.Windows.Forms.Button
$Button_Bye.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_Bye.Location = New-Object System.Drawing.Size(335,205)
$Button_Bye.Size = New-Object System.Drawing.Size(320,160)
$Button_Bye.Text = "Add bye"
$Button_Bye.BackColor = [System.Drawing.Color]::FromArgb(150,255,255,255)
$main_form.Controls.Add($Button_Bye)
$Button_Bye.Add_Click(
{
$title = 'Add bye'
$msg   = 'Enter name of bye:'
$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
if ($text -ne ''){
    $Bye=$global:Players|Where-Object name -eq $text
    $Bye.Point=$Bye.Point+3
    [void] [System.Windows.MessageBox]::Show( "3 points given to $text", "Add bye", "Ok", "Information" )
    }
    Standings
    $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
}
)


$Button_Draw = New-Object System.Windows.Forms.Button
$Button_Draw.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_Draw.Location = New-Object System.Drawing.Size(335,370)
$Button_Draw.Size = New-Object System.Drawing.Size(320,160)
$Button_Draw.Text = "Add draw"
$Button_Draw.BackColor = [System.Drawing.Color]::FromArgb(150,255,255,255)
$main_form.Controls.Add($Button_Draw)
$Button_Draw.Add_Click(
{
    [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Add draw player'
$msg   = 'Enter name of draw:'
$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
if ($text -ne ''){
    $Draw=$global:Players|Where-Object name -eq $text
    $Draw.Point=$Draw.Point+1
    [void] [System.Windows.MessageBox]::Show( "1 points given to $text", "Add Draw", "Ok", "Information" )
    }
    Standings
    $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
}
)


$Button_Fix = New-Object System.Windows.Forms.Button
$Button_Fix.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_Fix.Location = New-Object System.Drawing.Size(660,40)
$Button_Fix.Size = New-Object System.Drawing.Size(320,160)
$Button_Fix.Text = "Fix points"
$Button_Fix.BackColor = [System.Drawing.Color]::FromArgb(150,255,255,255)
$main_form.Controls.Add($Button_Fix)
$Button_Fix.Add_Click(
{
    [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Fix points'
$msg   = 'Enter name of Person to fix:'
$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
$global:fix=$global:Players|Where-Object name -eq $text

    if ($text -ne ''){
        $title2 = 'Fix points'
        $msg2  = 'Enter amount of points to add/remove:'
        $text2 = [Microsoft.VisualBasic.Interaction]::InputBox($msg2, $title2)
        $global:fix.point=$global:fix.point+$text2
    }
    Standings
    $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
}
)


$Button_Standings = New-Object System.Windows.Forms.Button
$Button_Standings.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_Standings.Location = New-Object System.Drawing.Size(660,205)
$Button_Standings.Size = New-Object System.Drawing.Size(320,160)
$Button_Standings.Text = "Show timer"
$Button_Standings.BackColor = [System.Drawing.Color]::FromArgb(150,255,255,255)
$main_form.Controls.Add($Button_Standings)

$Button_Standings.Add_Click(
{
    Start-Process powershell $global:location"\timer.ps1" 
}
)


$Button_FinalStandings = New-Object System.Windows.Forms.Button
$Button_Finalstandings.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_FinalStandings.Location = New-Object System.Drawing.Size(660,370)
$Button_FinalStandings.Size = New-Object System.Drawing.Size(320,160)
$Button_FinalStandings.Text = "Show final standings"
$Button_FinalStandings.BackColor = [System.Drawing.Color]::FromArgb(150,255,255,255)
$main_form.Controls.Add($Button_FinalStandings)
$Button_FinalStandings.Add_Click(
{
    if([System.Windows.Forms.MessageBox]::Show("Continue? `n This will assign breakers and the tournament should end afterwards", "Question",[System.Windows.Forms.MessageBoxButtons]::OKCancel) -eq "OK")
{
	Write-Host "OK!"

    foreach ($Player in $global:Players) {
        [float]$Modifier = 0.00
        foreach ($opp in $Player.Played) {
            $Modifier = $Modifier + ($opp.point) #/ $opp.Played.Count)
        }
    $Modifier = $Modifier / 100
    $player.point=[math]::round($player.point+$modifier,2)
    $finalstanding_array=@()
    [string]$finalstanding_array
    foreach($stand in $global:Players | Sort-Object Point -Descending) {
        $finalstanding_array+="$($stand.name): $($stand.point) `n"
    }  
}
    [void] [System.Windows.MessageBox]::Show( "$finalstanding_array", "Final standings", "Ok", "Information" )
    $Players | Select-Object Point,Name | Sort-Object Point -Descending | out-file  $global:location"\$((Get-Date).ToString("yyyyMMdd_HHMMss")) Final_Standings.csv" -Append -force
    Standings
    $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
}
}
)

$Button_dropplayer = New-Object System.Windows.Forms.Button
$Button_dropplayer.Font = New-Object System.Drawing.Font("Times New Roman",22,[System.Drawing.FontStyle]::Bold)
$Button_dropplayer.Location = New-Object System.Drawing.Size(10,370)
$Button_dropplayer.Size = New-Object System.Drawing.Size(320,160)
$Button_dropplayer.Text = "Drop player"
$Button_dropplayer.BackColor = [System.Drawing.Color]::FromArgb(100,255,0,0)
$main_form.Controls.Add($Button_dropplayer)
$Button_dropplayer.Add_Click(
{
$title = 'Drop player'
$msg   = 'Enter name of player to drop:'

$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
    if ($text -ne ''){
        $newarray = $global:Players | where-object name -ne $text
        $global:Players = $newarray
       [void] [System.Windows.MessageBox]::Show( "$text Dropped", "Drop player", "Ok", "Information" )
    }
    Standings
    $Label.Text = ("Player count: $($global:players.count) `n`nStandings:`n"+$global:standing_array1)
}
)
#################
# form icon
$objImage = [system.drawing.image]::FromFile("$global:location\baltzer.jpg")
$main_form.BackgroundImage = $objImage
$main_form.BackgroundImageLayout = "stretch"
#None, Tile, Center, Stretch, Zoom
 
##################
$main_form.ShowDialog()
