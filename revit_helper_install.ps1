$remote_host = $args[0]


function check_installation {
    param ()

    $path = "C:\ProgramData\Autodesk\Revit\Addins\RevitHelper"

    if (Test-Path $path) {
        return 1
    }
    
    else {
        return 0
    }
}


function copy_files {
    param ($cred)

    if (-not (Test-Path "C:\RevitHelperInstall_2.9.2_custom.msi")) {
    
        $source_path = "\\srv-tex.techno.local\revit\01_Библиотека\Программы и плагины\RevitHelperInstall_2.9.2_custom.msi"

        New-PSDrive -Credential $cred -Root "\\srv-tex.techno.local\revit" -PSProvider FileSystem -Name srv-tex

        Import-Module BitsTransfer

        Start-BitsTransfer $source_path "C:\" -DisplayName "Revit helper installation" -Description "Копирование инсталлятора"
    
    }

    else {
    
        Write-Host -ForegroundColor Green "The revit helper installer has already been copied."
    
    }

    return $null

}


function main {
    param ($remote_host)


    $installation_status = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:check_installation}

    if ($installation_status -eq 1) {
        
        Write-Host -ForegroundColor Green "The Revit Helper plugin has already installed"
    }
    
    else {
    
        $cred = Get-Credential -Message "Credential are required for access to the \\srv-tex\revit file share"
    
        $copy = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:copy_files} -ArgumentList $cred
    
        $install = Invoke-Command -ComputerName $remote_host -ScriptBlock {Start-Process msiexec.exe -ArgumentList "/i `"C:\RevitHelperInstall_2.9.2_custom.msi`" ALL_USERS=1 /qn /log `"C:\revit_helper_log.txt`"" -Wait}

        .\notifications.ps1 $remote_host "Плагин revit helper установлен."

    }
    
}

main -remote_host $remote_host
