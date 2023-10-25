$remote_host = $args[0]
$message = $args[1]

Function send_notification {
    Param($message)

    # Load some required namespaces
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
    $app =  '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'

    # Define the toast notification in XML format
    [xml]$ToastTemplate = "
    <toast scenario='reminder'>
        <visual>
            <binding template='ToastGeneric'>
                <text>$Message</text>
            </binding>
        </visual>
        <actions>
            <action content='OK' arguments='action=accept'/>
        </actions>
        <audio src='ms-winsoundevent:Notification.Default'/>
    </toast>"

    # Load the notification into the required format
    $ToastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
    $ToastXml.LoadXml($ToastTemplate.OuterXml)

    # Display
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app).Show($ToastXml)

    Write-Host -ForegroundColor Blue "A message has been sent to the user... $message"

}

Invoke-Command -ComputerName $remote_host -ScriptBlock ${function:send_notification} -ArgumentList $message
