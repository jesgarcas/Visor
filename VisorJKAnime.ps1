#Powershell 3.0 https://www.microsoft.com/en-us/download/details.aspx?id=34595
 #DEPRECATED

Add-Type -AssemblyName System.Windows.Forms 
#Interfaz
$Form = New-Object system.Windows.Forms.Form
$Form.FormBorderStyle = 'Fixed3D'
$Form.MaximizeBox = $false
$Form.Text = "JKAnime PoPuPer"
$Form.Size = New-Object System.Drawing.Size(400,600)
$Form.Icon = $FormIcon
$Form.StartPosition = "CenterScreen"

$LabelAni = New-Object System.Windows.Forms.Label
$LabelAni.Location = New-Object System.Drawing.Size(100,5)
$LabelAni.Size = New-Object System.Drawing.Size(250,20)
$LabelAni.Text = "Pega el nombre de la URL del anime"

$TBAni = New-Object System.Windows.Forms.TextBox 
$TBAni.Location = New-Object System.Drawing.Size(70,20) 
$TBAni.Size = New-Object System.Drawing.Size(250,20) 
$Form.Controls.Add($TBAni) 
$Form.Controls.Add($LabelAni)


#$LabelCapi = New-Object System.Windows.Forms.Label
#$LabelCapi.Location = New-Object System.Drawing.Size(150,50)
#$LabelCapi.Size = New-Object System.Drawing.Size(250,20)
#$LabelCapi.Text = "Capítulos"

#$TBCapi = New-Object System.Windows.Forms.TextBox 
#$TBCapi.Location = New-Object System.Drawing.Size(200,47) 
#$TBCapi.Size = New-Object System.Drawing.Size(40,20)


#$Form.Controls.Add($TBCapi) 
#$Form.Controls.Add($LabelCapi)

$Generar = new-Object System.Windows.Forms.Button
$Generar.Location = new-Object System.Drawing.Size(145,70)
$Generar.Size = new-Object System.Drawing.Size(100,20)
$Generar.Text = "Generar Listado"
$Form.Controls.Add($Generar)

$flowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$flowPanel.Location = New-Object System.Drawing.Size(10,100)
$flowPanel.Size = New-Object System.Drawing.Size(380,500)
$Form.Controls.Add($flowPanel)

Function Accion(){

    #Obtenemos Capitulos del anime:
    $enlace = $TBAni.Text
    $web = Invoke-WebRequest -Uri $enlace
    $extraido = ($web.ParsedHtml.getElementsByTagName(‘div’) | Where{ $_.className -eq ‘listnavi’ }).textContent
    #$capitulos = $extraido.Trim(" ")
    $capitulos = $capitulos.SubString($capitulos.LastIndexOf(" "))
    #$capitulos = $capitulos.Trim(" ")


    $buttons_functionslist = @()
    for($i=0;$i -lt $capitulos;$i++){
        $buttons_functionslist += $i
    }

    $buttons_functionbuttoncount = $buttons_functionslist.count

    $loop = 0
        #Limpiamos el panel al que agregaremos los botones, por si se pulsa de nuevo el boton
    $flowPanel.Controls.Clear()
    while($loop -lt $capitulos)
	    {
            $loop += 1
	        $thisbutton = New-Object System.Windows.Forms.Button
	        [string]$thisbuttonname = $buttons_functionslist[$loop]
	        $thisbutton.Text = $loop
	        $thisbutton.size = New-Object System.Drawing.Size(40,20)

	        $thisbutton.Location = New-Object System.Drawing.Size(10,70)
	        $thisbutton.Add_Click({

                #Variables

                $enlace = $TBAni.Text
                $enlacecapi = $enlace + $this.Text
                write-host $enlacecapi
                #$enlace = $TBAni.Text

                #Obtención del contenido de la web
                $webcapi = Invoke-WebRequest -Uri $enlacecapi

                #Extraigo el src del iframe cuyo nombre de clase es "player_conte"
                $extraido = ($webcapi.ParsedHtml.getElementsByTagName(‘iframe’) | Where{ $_.className -eq ‘player_conte’ }).src

                #Abro dicho src en un navegador
                $navegador = new-object -com internetexplorer.application
                $navegador.ToolBar = 0
                $navegador.StatusBar = $False
                $navegador.navigate2($extraido[0])
                $navegador.visible=$true
	        })

	        $flowPanel.Controls.Add($thisbutton)

	    
	    }
        
}

$Generar.Add_Click({Accion})






###
$Form.ShowDialog() 
