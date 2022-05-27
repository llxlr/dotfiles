#!/usr/bin/env -S pwsh -nop
#requires -version 5

<#
 * Name: My PowerShell Configs
 * Author: james yang
 * Email: i@xhlr.top
 * Date: May 22, 2022

初始化配置:
    PS> if (!(Test-Path -Path $Profile)) { New-Item -Type File -Path $Profile -Force }
    PS> code $Profile || notepad $Profile
    PS> . $Profile
#>

# UTF8
#chcp 65001
$PSDefaultParameterValues["*:Encoding"] = "utf8"
$env:PYTHONIOENCODING = "utf-8"

$env:DISPLAY = "127.0.0.1:0"  # X11

#$Path = Split-Path $profile

# 欢迎消息
#$time = Get-date -Format "现在是 yyyy 年 M 月 d 日 H 时 m 分"
#$Motd = $Path + "\motd.txt"
$Path = $Pwd.path           # 获取路径
if ($path.split("\")[-1] -eq "Windows" -xor $path.split("\")[-1] -eq "System32") {
    # 默认路径为桌面
    $Desktop = $env:USERPROFILE + "\Desktop\"
    # 切换到桌面
    Set-Location $Desktop
}
#Write-Output $time
#Get-Content $Motd

# Conda
(& "D:\envs\conda\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
# ohmyposh
# $env:POSH_THEMES_PATH\star.omp.json
oh-my-posh init pwsh --config ~/.omp.json | Invoke-Expression
Enable-PoshTooltips

# 导入模块
Import-Module posh-git
$env:POSH_GIT_ENABLED = $true
Import-Module PSReadLine
If (!(Test-Path Variable:PSise)) {
    Import-Module Get-ChildItemColor
    $Global:GetChildItemColorVerticalSpace = 1
    # 查看目录
    Set-Alias ll Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}
Import-Module ZLocation
Import-Module npm-completion
if (Get-Module -ListAvailable -Name Get-Quote) {
    Import-Module Get-Quote
    Set-Alias fortune Get-Quote
}

# 设置预测命令来源为历史记录
Set-PSReadLineOption -PredictionSource History -ShowToolTips
# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit
# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# 查找程序路径
function WhereFile { where.exe $args }
Set-Alias whereis WhereFile

# 打开目录，默认当前路径
function OpenCurrentFolder {
    param
    (
        $Path = '.'
    )
    Invoke-Item $Path
}
Set-Alias o OpenCurrentFolder

# 返回上级目录
function GoBack { Set-Location .. }
Set-Alias .. GoBack

# Colorful Git Log
function GitLogPretty {
    git.exe log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all
}
Set-Alias glp GitLogPretty

# Lazy Git
function LazyGit { lazygit.exe $args }
Set-Alias lg LazyGit

# 临时启动 Web Server
function WebServer { python.exe -m http.server --bind 127.0.0.1 }
Set-Alias start-server WebServer

# Make 工程管理
function MakeFile { mingw32-make.exe $args }
Set-Alias make MakeFile

# 同步 NvChad 和 Packer
function NvimSync { nvim.exe +'hi NormalFloat guibg=#1e222a' +NvChadUpdate +PackerSync }
Set-Alias nvim-sync NvimSync

# Neovim
function NVI { nvim.exe $args }
Set-Alias vi NVI

# figlet
function Figlet4Go {
    #go install github.com/mbndr/figlet4go/cmd/figlet4go@latest
    figlet4go.exe -str "$args" -font "larry3d" -colors "red;yellow;green;blue;magenta;cyan"
}
Set-Alias figlet Figlet4Go

# music-player
Set-Alias mpr music-player.exe

# wpa2gen
function Wpa2Gen { python.exe $(where.exe wpa2gen.py) }
Set-Alias wpa2gen Wpa2Gen

# 更新系统组件
function Update-Packages {
    # 更新 conda
    Write-Host "Step 1: 更新 conda" -ForegroundColor Magenta -BackgroundColor Cyan
    conda update -y -n base -c defaults conda
    conda clean --all -y

    # 更新 pip
    Write-Host "Step 2: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
    # curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    # python get-pip.py
    $pkgs = pip list --outdated
    $pkgs = $pkgs[2..$pkgs.Count].ForEach{($_ -Split "\s+")[0]}
    if ("pip" -in $pkgs) {
        python -m pip install --upgrade pip
        $pkgs.Remove("pip")
    }
    $EscapePackages = "setuptools", "h11", "pywin32"
    foreach ($pkg in $EscapePackages) {
        $pkgs.Remove($pkg)
    }
    $UserPackages = @(Get-ChildItem $env:APPDATA\Python\Python38\site-packages -Name -Attributes D -Exclude @(
        "__pycache__"
    )).ForEach{$_=$_ -Split "\-.*?\.dist-info"; if ($_.Count -eq 2){ $_[0] }}
    if (@($pkgs).Count -ne 0) {
        foreach ($pkg in $pkgs) {
            if ($pkg -in $UserPackages) { $opt = "--user" }
            python -m pip install -U $pkg $opt
        }
    }

    # 更新 pipx
    Write-Host "Step 3: 更新 pipx" -ForegroundColor Magenta -BackgroundColor Cyan
    pipx upgrade-all

    # 更新 TeX Live
    $CurrentYear = Get-Date -Format yyyy
    Write-Host "Step 4: 更新 TeX Live $CurrentYear" -ForegroundColor Magenta -BackgroundColor Cyan
    # tlmgr update --self --all --repository https://mirrors.bfsu.edu.cn/CTAN/systems/texlive/tlnet

    # 更新 MiKTeX
    Write-Host "Step 5: 更新 MiKTeX" -ForegroundColor Magenta -BackgroundColor Cyan
    mpm --admin --set-repository=https://mirrors.bfsu.edu.cn/CTAN/systems/win32/miktex/tm/packages/ --update-db --verbose --find-updates
    mpm --admin --set-repository=https://mirrors.bfsu.edu.cn/CTAN/systems/win32/miktex/tm/packages/ --verbose --update

    # 更新 WinGet 源
    Write-Host "Step 6: 更新 WinGet 源" -ForegroundColor Magenta -BackgroundColor Cyan
    winget source update

    # 更新 Chocolotey
    Write-Host "Step 7: 更新 Chocolatey" -ForegroundColor Magenta -BackgroundColor Cyan
    # choco outdated

    # 更新 Scoop
    Write-Host "Step 8: 更新 Scoop 及其已安装包" -ForegroundColor Magenta -BackgroundColor Cyan
    scoop update *
    scoop status
}
Set-Alias update Update-Packages

# 获取所有网络接口
function Get-AllNic { Get-NetAdapter | Sort-Object -Property MacAddress }
Set-Alias getnic Get-AllNic

# 获取 IP 地址
function Get-IP { curl ip.sb }
Set-Alias getip Get-IP

# 获取 IPv4 路由地址
function Get-IPv4Routes {
    Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne "0.0.0.0"}
}
Set-Alias getipv4 Get-IPv4Routes

# 获取 IPv6 路由地址
function Get-IPv6Routes {
    Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne "::"}
}
Set-Alias getipv6 Get-IPv6Routes

# 获取天气
function Get-Weather { curl "wttr.in?M&lang=zh-cn&format=4" }
Set-Alias gwt Get-Weather
