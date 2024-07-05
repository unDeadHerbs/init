
# If not Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Startscript as Administrator
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs -NoNewWindow -Wait
    exit
}

# Install Chocolatey
# From https://chocolatey.org/docs/installation#install-with-powershellexe
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Wraped to protect current shell
Start-Process powershell.exe "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" -NoNewWindow -Wait

# Install Utilities
# Wraped to protect current shell
Start-Process powershell.exe "choco install -y vcxsrv cmder git msys2" -NoNewWindow -Wait

# Import cmder config
# ConEmu.xml
Copy-Item Cmder_Config.xml C:\tools\Cmder\config\user-ConEmu.xml
