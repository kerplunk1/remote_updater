
$remote_host = $args[0]

function check_installation {
    param ()

    $path = "C:\Program Files\Autodesk\Revit 2022\AddIns\BCF Manager"

    if (Test-Path $path) {
        return 1
    }
    
    else {
        return 0
    }
}


function copy_files {
    param ($cred)

    $source_path = "\\srv-tex.techno.local\revit\01_Библиотека\Программы и плагины\BCF Manager quiet install\BCF Manager 6.0 build 12 Rvt2022*"

    New-PSDrive -Credential $cred -Root "\\srv-tex.techno.local\revit" -PSProvider FileSystem -Name srv-tex

    Copy-Item -Path $source_path -Destination "C:\" -Recurse -Force

    return $null

}


function main {
    param ($remote_host)

    $installation_status = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:check_installation}

    if ($installation_status -eq 1) {
        
        Write-Host -ForegroundColor Green "The BCF Manager plugin has already installed"
    }
    
    else {
        $cred = Get-Credential -Message "Credential are required for access to the \\srv-tex\revit file share"

        $copy = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:copy_files} -ArgumentList $cred

        Write-Host -ForegroundColor Red "Инсталлятор скопирован, но запустить его не получается.`nОткроется Enter-PSsession, просто введите эту команду:"
        Write-Host -ForegroundColor Magenta 'msiexec /i "C:\BCF Manager 6.0 build 12 Rvt2022.msi" /qn ; exit'


        Enter-PSSession $remote_host

    }
    
}

main -remote_host $remote_host