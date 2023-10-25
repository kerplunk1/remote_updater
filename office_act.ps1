$remote_host = $args[0]

function act_office {

    $ospp = "C:\Program Files\Microsoft Office\Office16\OSPP.VBS"

    (cscript.exe $ospp /rearm)
    (cscript.exe $ospp /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH)
    (cscript.exe $ospp /sethst:srv-02.techno.local)
    (cscript.exe $ospp /setprt:1688)
    (cscript.exe $ospp /act)

}

Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:act_office}

.\notifications.ps1 $remote_host "MS Office активирован!"

