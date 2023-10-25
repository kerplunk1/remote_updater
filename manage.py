import subprocess

def send_message(hostname, message):
    subprocess.run(['powershell.exe', '-ExecutionPolicy', 'Bypass', '-File', 'notifications.ps1', hostname, message])


def update_revit(hostname):
    subprocess.run(['powershell.exe', '-ExecutionPolicy', 'Bypass', '-File', 'revit_update.ps1', hostname])


def activate_office(hostname):
    subprocess.run(['powershell.exe', '-ExecutionPolicy', 'Bypass', '-File', 'office_act.ps1', hostname])


if __name__ == "__main__":
    print("You need to run the 'main.py' file")

