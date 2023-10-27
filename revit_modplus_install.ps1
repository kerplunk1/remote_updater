$remote_host = $args[0]

function copy_files {
    param ($cred)
    
    $source_inst_path = "\\srv-tex.techno.local\revit\01_Библиотека\Программы и плагины\ModPlus_offline_23.10.25.msi"
    $dest_inst_path = "C:\ModPlus_offline_23.10.25.msi"

    $source_conf_path = "\\srv-tex.techno.local\revit\01_Библиотека\Программы и плагины\mpConfig.mpcf"

    New-PSDrive -Credential $cred -Root "\\srv-tex.techno.local\revit" -PSProvider FileSystem -Name srv-tex

    if (Test-Path $dest_inst_path) {
        Write-Host -ForegroundColor Green "Инсталлятор уже был скопирован"
    }
    
    else {
        Import-Module BitsTransfer
        Start-BitsTransfer $source_inst_path "C:\" -DisplayName "ModPlus installation" -Description "Копирование инсталлятора"
    }

    Copy-Item $source_conf_path "C:\" -Force

    return 0
}


function install {
    param($user)

    $instal_ldir = "C:\Program Files\ModPlus\"

    $conf_dir = "C:\Users\$user\AppData\Roaming\ModPlus Data\UserData\"

    Start-Process msiexec -ArgumentList "/i", "C:\ModPlus_offline_23.10.25.msi", "INSTALLDIR=$install_dir","/qn" -Wait

    New-Item -ItemType Directory -Path $conf_dir -Force

    New-Item -ItemType Directory -Path "C:\backup_REVIT" -Force

    Copy-Item "C:\mpConfig.mpcf" $conf_dir -Force

    return 0

}


function create_shortcut {
    param($user)

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\Users\$user\Desktop\mpConfig.lnk")
    $Shortcut.TargetPath = "C:\Program Files\ModPlus\mpConfig.exe"
    $Shortcut.Save()

    return 0
}


function main {
    param ($remote_host)

    $cred = Get-Credential
    
    $copy = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:copy_files} -ArgumentList $cred
    
    Write-Host -ForegroundColor Yellow "Из списка выберите имя пользователя, в его профиль будет скопирован файл конфигурации:"
    
    Invoke-Command -ComputerName $remote_host -ScriptBlock {Get-ChildItem -Path C:\Users\ -Name | Write-Host -ForegroundColor Magenta}

    $user = Read-Host "Введите username"

    $inst = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:install} -ArgumentList $user

    $shortcut = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:create_shortcut} -ArgumentList $user

    .\notifications.ps1 $remote_host "Плагин ModPlus установлен, для работы необходимо один раз запустить ярлык mpConfig с рабочего стола и поставить галочку 'Поддерживаемые продукты - Revit 2022'"
}


main -remote_host $remote_host
