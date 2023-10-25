$remote_host = $args[0]

function prepare_for_the_update {
    param ($cred)

    Import-Module BitsTransfer

    $app_path = "C:\Program Files\Autodesk\Revit 2022\Revit.exe"
    
    $source_sp7 = "\\srv-tex.techno.local\revit\RVTSP7.msp"
    $source_sp8 = "\\srv-tex.techno.local\revit\RVTSP8.msp"

    $dest_sp7 = "C:\RVTSP7.msp"
    $dest_sp8 = "C:\RVTSP8.msp"

    New-PSDrive -Credential $cred -Root "\\srv-tex.techno.local\revit" -PSProvider FileSystem -Name srv-tex

    if (Test-Path $app_path) {
        
        $version = (Get-Item $app_path).VersionInfo.FileVersion
        Write-Host "Current version:" $version

        if ($version -like "22.1.[0-3]*") {
            
            if (-not (Test-Path $dest_sp8)) {
                Write-Host -ForegroundColor Yellow "Copying an update file SP8"
                Start-BitsTransfer $source_sp8 "C:\" -DisplayName "Update to 22.1.4" -Description "Copying an update file SP8"
            }

            else {
                Write-Host -ForegroundColor Green "The file SP8 has already been copied."
            }
        }

        elseif ($version -like "22.0.*") {

            if (-not (Test-Path $dest_sp7)) {

                Write-Host -ForegroundColor Yellow "Copying an update file SP7"
                Start-BitsTransfer $source_sp7 "C:\" -DisplayName "Update to 22.1.3" -Description "Copying an update file SP7"                
            }

            else {
                Write-Host -ForegroundColor Green "The file SP7 has already been copied."
            }

            if (-not (Test-Path $dest_sp8)) {
                    
                Write-Host -ForegroundColor Yellow "Copying an update file SP8"
                Start-BitsTransfer $source_sp8 "C:\" -DisplayName "Update to 22.1.4" -Description "Copying an update file SP8"
            }

            else {
                Write-Host -ForegroundColor Green "The file SP8 has already been copied."
            }
        }

        else {
            Write-Host -ForegroundColor Red "Current version can not be update"
        }

        return $version
    }

    else {
        Write-Host -ForegroundColor Red "Revit not found"
    }
}


function check_status_proc {
    param ()
    
    $status = Get-Process | Select-String RevitWorker

    if ($null -eq $status) {
        return 0
    }

    else {
        return 1
    }
}


function main {
    param ($remote_host)

    $cred = Get-Credential -Message "Credential are required for access to the \\srv-tex\revit file share"

    $version = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:prepare_for_the_update} -ArgumentList $cred

    $proc_status = Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:check_status_proc}

    if (($proc_status -eq 0) -and ($version -like "22.0.*")) {

        Write-Host -ForegroundColor Yellow "Processing..."

        .\notifications.ps1 $remote_host "Updating to 22.1.3"
        Invoke-Command -ComputerName $remote_host -ScriptBlock {Start-Process -FilePath "msiexec.exe" -ArgumentList "/p", "C:\RVTSP7.msp", "/qn" -Wait}

        .\notifications.ps1 $remote_host "Updating to 22.1.4"
        Invoke-Command -ComputerName $remote_host -ScriptBlock {Start-Process -FilePath "msiexec.exe" -ArgumentList "/p", "C:\RVTSP8.msp", "/qn" -Wait}

        .\notifications.ps1 $remote_host "Updating complete"
    }
    
    elseif (($proc_status -eq 0) -and ($version -like "22.1.[0-3]*")) {

        Write-Host -ForegroundColor Yellow "Processing..."
        
        .\notifications.ps1 $remote_host "Updating to 22.1.4"
        Invoke-Command -ComputerName $remote_host -ScriptBlock {Start-Process -FilePath "msiexec.exe" -ArgumentList "/p", "C:\RVTSP8.msp", "/qn" -Wait}

        .\notifications.ps1 $remote_host "Updating complete"
    }

    elseif (($proc_status -eq 1) -and (($version -like "22.1.[0-3]*") -or ($version -like "22.0.*"))) {
        
        .\notifications.ps1 $remote_host "Please, close the revit"
    }

}


main -remote_host $remote_host
