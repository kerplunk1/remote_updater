$remote_host = $args[0]

function install {
    param($cred)

    if (Test-Path "C:\Program Files\Microsoft Office\Office16") {
        
        Write-Host "Уже установлено."

    }

    else {
        
        New-PSDrive -Credential $cred -Root "\\srv-tex.techno.local\ТЕХНОЛОГИЯ" -PSProvider FileSystem -Name srv-tex

        Write-Host -ForegroundColor Yellow "Processing..."

        \\srv-tex.techno.local\ТЕХНОЛОГИЯ\99_IT\01_deploy\Office_2021\setup.exe /configure \\srv-tex.techno.local\ТЕХНОЛОГИЯ\99_IT\01_deploy\Office_2021\Config.xml

        return 0
    }
}


function main {
    param($remote_host)

    $cred = Get-Credential -Message "Credential are required for access to the \\srv-tex\ТЕХНОЛОГИЯ file share"

    $install = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:install} -ArgumentList $cred

    if ($install -eq 0) {
        
        .\notifications.ps1 $remote_host "MS Office установлен."

    }
}


main -remote_host $remote_host
