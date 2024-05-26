#!/usr/bin/env -S pwsh -nop
#requires -version 5

<#
 * Name: My PowerShell Profile
 * Author: james yang
 * Email: i@xhlr.top
 * Date: May 22, 2022
 * Update: Jan 18, 2024

初始化配置:
  PS> if (!(Test-Path -Path $Profile)) { New-Item -Type File -Path $Profile -Force }
  PS> st $Profile || code $Profile || notepad $Profile
  PS> . $Profile
#>

<# 环境变量 #>
<#-----------------------------------------------------------------#>
# UTF8
#chcp 65001
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues["*:Encoding"] = "utf8"
$env:PYTHONIOENCODING = "utf-8"
$env:NLS_LANG = "SIMPLIFIED CHINESE_CHINA.UTF8"
# 代理
#$env:HTTP_PROXY="http://127.0.0.1:8080"
#$env:HTTPS_PROXY="https://127.0.0.1:8080"
#$env:TDL_PROXY="socks5://127.0.0.1:7890"
# X11
#$env:DISPLAY = "127.0.0.1:0"
# Profile Home
#$profilehome = Split-Path $profile
<#-----------------------------------------------------------------#>

<# 欢迎消息 #>
<#-----------------------------------------------------------------#>
#$time = Get-date -Format "现在是 yyyy 年 M 月 d 日 H 时 m 分"
#$Motd = $Path + "\motd.txt"
$Path = $Pwd.path  # 获取路径
if ($path.split("\")[-1] -eq "Windows" -xor $path.split("\")[-1] -eq "System32") {
    # 切换到桌面
    Set-Location "$env:USERPROFILE\Desktop"
}
#Write-Output $time
#Get-Content $Motd
<#-----------------------------------------------------------------#>

<# 初始化 #>
<#-----------------------------------------------------------------#>
# Conda
(& "$(Get-Command conda.exe)" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
# 1password
op completion powershell | Out-String | Invoke-Expression
# ohmyposh
oh-my-posh init pwsh --config ~/.config/omp/custom.json | Invoke-Expression
Enable-PoshTooltips
Enable-PoshLineError
Enable-PoshTransientPrompt
<#-----------------------------------------------------------------#>

<# 导入模块 #>
<#-----------------------------------------------------------------#>
# posh-git
Import-Module posh-git
$env:POSH_GIT_ENABLED = $true

# PSReadLine
Import-Module PSReadLine
# 设置预测命令来源为历史记录
Set-PSReadLineOption -PredictionSource History -ShowToolTips
# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# 不设置响铃
Set-PSReadLineOption -BellStyle:None
# 设置 Tab 为菜单补全和 IntelliSense
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# Scoop
Import-Module "$env:SCOOP\modules\scoop-completion"

# GSudo
Import-Module gsudoModule

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
# Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# psfzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Import-Module ZLocation

Import-Module npm-completion


If (!(Test-Path Variable:PSise)) {
    Import-Module Get-ChildItemColor
    $Global:GetChildItemColorVerticalSpace = 1
    # 查看目录
    Set-Alias ll Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}

if (Get-Module -ListAvailable -Name Get-Quote) {
    Import-Module Get-Quote
    Set-Alias fortune Get-Quote
}

<#-----------------------------------------------------------------#>

# 查找程序路径
function WhereIs { (Get-Command $args).Source }

# 返回上级目录
function .. { Set-Location ".." }
function ... { Set-Location "../.." }

# 临时启动 Web Server
function Start-WebServer { python.exe -m http.server --bind 127.0.0.1 }

# Make 工程管理
function Make { mingw32-make.exe $args }

# 同步 NvChad 和 Packer
function Nvim-Sync { nvim.exe +"hi NormalFloat guibg=#1e222a" +NvChadUpdate +PackerSync }

# Neovim
If (Test-Path Alias:vi) { Remove-Item Alias:vi }
function VI { nvim.exe $args }

# figlet
# go install github.com/mbndr/figlet4go/cmd/figlet4go@latest
function Figlet { figlet4go.exe -str "$args" -font "larry3d" -colors "red;yellow;green;blue;magenta;cyan" }

# music-player
Set-Alias mpr music-player.exe

# wpa2gen
function Wpa2Gen { python.exe $(Get-Command wpa2gen.py).Source }

# pipe
function Pipe { python.exe $(Get-Command maze.py).Source $args }

# JaxoDraw
function JaxoDraw { java.exe -jar $(Get-Command jaxodraw.jar).Source }

# ssh-copy-id
function SSH-Copy-Id { sh.exe $(where.exe ssh-copy-id) $args }

# Colorful Git Log
function GitLogPretty { git.exe log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --all }
Set-Alias glp GitLogPretty

# 获取天气
function Get-Weather { curl "wttr.in?0&lang=zh-cn" }
Set-Alias gw Get-Weather

# 获取 IP 地址
function Get-IP { curl ip.sb }
Set-Alias getip Get-IP

# 获取 IPv4 地址
function Get-IPv4 { curl -4 ip.sb }
Set-Alias getipv4 Get-IPv4

# 获取 IPv6 地址
function Get-IPv6 { curl -6 ip.sb }
Set-Alias getipv6 Get-IPv6

# 获取所有网络接口
function Get-AllNic { Get-NetAdapter | Sort-Object -Property MacAddress }
Set-Alias getnic Get-AllNic

# 获取 IPv4 路由地址
function Get-IPv4Routes { Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne "0.0.0.0"} }
Set-Alias getipv4r Get-IPv4Routes

# 获取 IPv6 路由地址
function Get-IPv6Routes { Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne "::"} }
Set-Alias getipv6r Get-IPv6Routes

# 打开目录，默认当前路径
function OpenCurrentFolder {
    param
    (
        $Path = "."
    )
    Invoke-Item $Path
}
Set-Alias e OpenCurrentFolder

# npm package list
function Npm-Packages {
    param
    (
        $Location = "global"
    )
    npm list --location=$Location --depth 0
}
Set-Alias np Npm-Packages
# pnpm
Set-Alias -Name pn -Value pnpm

# 更新系统组件
function Update-Packages {
    $num = 0

    # 更新 conda
    try {
        conda --version
        $num += 1
        Write-Host "Step ${num}: 更新 conda" -ForegroundColor Magenta -BackgroundColor Cyan
        conda update -y -n base -c defaults conda
        conda clean --all -y
    } catch {
        Write-Error "没有安装 Conda !"
    }

    # 更新 pip
    try {
        python -V
        $num += 1
        Write-Host "Step ${num}: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
        #curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        #python get-pip.py
        $pkgs = pip list --outdated
        $pkgs = $pkgs[2..$pkgs.Count].ForEach{($_ -Split "\s+")[0]}
        if ("pip" -in $pkgs) {
            python -m pip install --upgrade pip
            $info=$pkgs.Remove("pip")
            if ($info) {}
        }
        $Path = Split-Path $profile
        $EscapePackages = Get-Content -Path "$Path\pip.txt"
        foreach ($pkg in $EscapePackages) {
            $info=$pkgs.Remove($pkg)
            if ($info) { Write-Host "跳过${pkg}成功" } else { Write-Host "跳过${pkg}失败" }
        }
        $UserPackages = pip list --user
        $UserPackages = $UserPackages[2..$UserPackages.Count].ForEach{($_ -Split "\s+")[0]}
        if (@($pkgs).Count -ne 0) {
            foreach ($pkg in $pkgs) {
                if ($pkg -in $UserPackages) { $opt = "--user" }
                python -m pip install -U $pkg $opt
            }
        }
        pip cache info
        pip cache purge
    } catch {
        Write-Error "没有安装 Python !"
    }

    # 更新 pipx
    try {
        pipx --version
        $num += 1
        Write-Host "Step ${num}: 更新 pipx" -ForegroundColor Magenta -BackgroundColor Cyan
        pipx upgrade-all
    } catch {
        Write-Error "没有安装 pipx !"
    }

    # 更新 TeX Live
    $CurrentYear = Get-Date -Format yyyy
    try {
        tlmgr --version
        $num += 1
        Write-Host "Step ${num}: 更新 TeX Live $CurrentYear" -ForegroundColor Magenta -BackgroundColor Cyan
        tlmgr option repository https://mirrors.bfsu.edu.cn/CTAN/systems/texlive/tlnet
        tlmgr update --self --all
    } catch {
        Write-Error "没有安装 TeX Live $CurrentYear !"
    }

    # 更新 MiKTeX
    try {
        miktex --version
        $num += 1
        Write-Host "Step ${num}: 更新 MiKTeX" -ForegroundColor Magenta -BackgroundColor Cyan
        mpm --admin --set-repository=https://mirrors.bfsu.edu.cn/CTAN/systems/win32/miktex/tm/packages/ --update-db --verbose --find-updates
        mpm --admin --set-repository=https://mirrors.bfsu.edu.cn/CTAN/systems/win32/miktex/tm/packages/ --verbose --update
    } catch {
        Write-Error "没有安装 MikTeX !"
    }

    # 更新 WinGet 源
    try {
        Write-Host "WinGet $(winget --version)"
        $num += 1
        Write-Host "Step ${num}: 更新 WinGet 源" -ForegroundColor Magenta -BackgroundColor Cyan
        winget source remove winget
        winget source add winget https://mirrors.ustc.edu.cn/winget-source
        winget source update --rainbow
    } catch {
        Write-Error "没有安装 WinGet !"
    }

    # 更新 Chocolotey
    try {
        choco --version
        $num += 1
        Write-Host "Step ${num}: 更新 Chocolatey" -ForegroundColor Magenta -BackgroundColor Cyan
        choco outdated
    } catch {
        Write-Error "没有安装 Chocolatey !"
    }

    # 更新 Scoop
    try {
        scoop status
        $num += 1
        Write-Host "Step ${num}: 更新 Scoop 及其已安装包" -ForegroundColor Magenta -BackgroundColor Cyan
        scoop update *
        scoop cleanup -k *
        scoop cache rm *
    } catch {
        Write-Error "没有安装 Scoop !"
    }

    # 更新 npm
    try {
        Write-Host "Node $(node -v)"
        $num += 1
        try {
            Write-Host "Npm $(npm -v)"
        } catch {
            Copy-Item "$env:NODE_PATH\npm\bin\npm.cmd" "$env:NODE_PATH\..\npm.cmd"
        }
        Write-Host "Step ${num}: 更新 npm" -ForegroundColor Magenta -BackgroundColor Cyan
        npm i -g npm --registry=https://registry.npmmirror.com
        #npm i -g yarn --registry=https://registry.npmmirror.com
        npm i -g pnpm --registry=https://registry.npmmirror.com
        if (!(Get-Command ncu)) {
            npm i -g npm-check-updates --registry=https://registry.npmmirror.com
        }
        $cmd = $(ncu -g -u)[-2]
        if ($cmd) {
            Invoke-Expression "${cmd} --registry=https://registry.npmmirror.com"
        }
    } catch {
        Write-Error "没有安装 Node !"
    }

    # 更新 WSL
    try {
        wsl --version
        $num += 1
        Write-Host "Step ${num}: 更新 WSL" -ForegroundColor Magenta -BackgroundColor Cyan
        wsl --update
        wsl -d Ubuntu -u root -e apt-get update
        wsl -d Ubuntu -u root -e apt-get upgrade -y
        wsl -d Ubuntu -u root -e apt-get autoremove
        wsl -d Ubuntu -u root -e apt-get clean
        # wsl -d Arch -u root -e paru
        # wsl -d Arch -u root -e pacman -Scc
        # wsl -d Arch -u root -e pacman -Qtdq | wsl -d Arch -u root -e pacman -Rns
        wsl --shutdown
    } catch {
        Write-Error "没有安装 WSL !"
    }

    # 更新 PowerShell Modules
    try {
        if ($(Get-PSRepository).Name -eq 'PSGallery' && $(Get-PSRepository).InstallationPolicy -eq 'Untrusted') {
            Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
        }
        # Update-Module
    } catch {
        Write-Error "没有安装 PowerShellGet !"
    }
}
Set-Alias up Update-Packages

# 备份配置
function Backup-Configs {
    $num = 0

    # 备份 scoop 配置
    try {
        scoop status
        $num += 1
        Write-Host "Step ${num}: 备份 Scoop 配置" -ForegroundColor Magenta -BackgroundColor Cyan
        scoop list | Select-Object -Property Name,Source | ConvertTo-Json | Add-Content -Path "$env:BACKUP\scoop\apps.json"
        scoop bucket list | Select-Object -Property Name,Source | ConvertTo-Json | Add-Content -Path "$env:BACKUP\scoop\buckets.json"
        Copy-Item ~/.config/scoop/config.json "$env:BACKUP\scoop\config.json"
    } catch {
        Write-Error "没有安装 Scoop !"
    }
}
Set-Alias bc Backup-Configs
