@echo off
:: --- PARTE BATCH (INICIADOR) ---
:: Define o caminho do script numa variavel de ambiente para o PowerShell ler
SET "SCRIPT_PATH=%~f0"

:: Verifica se tem permissão de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando Permissao de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Configura o local e executa o código PowerShell abaixo (pula as primeiras 19 linhas)
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Content '%~f0' | Select-Object -Skip 19 | Out-String | Invoke-Expression"
exit /b
:: ---------------------------------------------------------
:: --- ABAIXO COMEÇA O SCRIPT POWERSHELL (NÃO MEXA ACIMA) ---

# --- CONFIGURAÇÕES GERAIS ---
$Version = "3.7.0 (Professional)"
$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

# --- FUNÇÃO DE GRADIENTE (VERDE ALIEN) ---
function Write-Gradient {
    param([string]$Text, [int[]]$StartColor = @(0, 60, 0), [int[]]$EndColor = @(50, 255, 50))
    $len = $Text.Length; if ($len -eq 0) { return }
    $out = ""; $ESC = [char]27
    for ($i = 0; $i -lt $len; $i++) {
        $p = $i / $len
        $r = [int]($StartColor[0] + ($EndColor[0] - $StartColor[0]) * $p)
        $g = [int]($StartColor[1] + ($EndColor[1] - $StartColor[1]) * $p)
        $b = [int]($StartColor[2] + ($EndColor[2] - $StartColor[2]) * $p)
        $out += "$ESC[38;2;$r;$g;$b`m" + $Text[$i]
    }
    Write-Host "$out$ESC[0m"
}

# --- EFEITOS VISUAIS ---
function Write-Typewriter ($Text, $Speed = 20) {
    $chars = $Text.ToCharArray()
    foreach ($c in $chars) {
        Write-Host $c -NoNewline -ForegroundColor Green
        Start-Sleep -Milliseconds $Speed
    }
    Write-Host ""
}

function Write-DecryptEffect ($Text) {
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&?£€"
    $rnd = New-Object System.Random
    $ESC = [char]27
    
    $Width = $Host.UI.RawUI.WindowSize.Width
    $PadAmt = [math]::Max(0, [int](($Width - $Text.Length) / 2))
    $Padding = " " * $PadAmt

    Write-Host $Padding -NoNewline
    for ($i = 0; $i -lt $Text.Length; $i++) {
        $targetChar = $Text[$i]
        if ($targetChar -eq " ") { Write-Host " " -NoNewline; continue }
        for ($j = 0; $j -lt 2; $j++) { 
            $randomChar = $chars[$rnd.Next($chars.Length)]
            Write-Host $randomChar -NoNewline -ForegroundColor DarkGreen
            Start-Sleep -Milliseconds 5
            $pos = $host.UI.RawUI.CursorPosition
            if ($pos.X -gt 0) { $pos.X = $pos.X - 1 }
            $host.UI.RawUI.CursorPosition = $pos
        }
        # Cor Verde Neon para o texto final
        Write-Host "$ESC[38;2;50;255;50m$targetChar$ESC[0m" -NoNewline
    }
    Write-Host ""
}

function Write-MatrixEffect {
    $rnd = New-Object System.Random
    $chars = "0123456789ABCDEF"
    $width = 120
    for ($i = 0; $i -lt 30; $i++) {
        $line = ""
        for ($k = 0; $k -lt $width; $k++) {
            if ($rnd.Next(10) -gt 8) { $line += $chars[$rnd.Next($chars.Length)] } else { $line += " " }
        }
        if ($i -lt 15) { Write-Host $line -ForegroundColor DarkGreen } else { Write-Host $line -ForegroundColor Green }
        Start-Sleep -Milliseconds 5
    }
    Write-Host ""
}

# --- INTRODUÇÃO ESTILO "BOOT DE NAVE" ---
Clear-Host
Write-Host ""
Write-Typewriter " > INICIANDO SISTEMA OPERACIONAL..." 10
Write-Typewriter " > CARREGANDO KERNEL... [OK]" 5
Write-Typewriter " > CARREGANDO MODULOS DE CRIPTOGRAFIA... [OK]" 5
Write-Typewriter " > ESTABELECENDO CONEXAO SEGURA... [OK]" 5
Write-Host ""
Start-Sleep -s 1

# LOGO VERDE RADIOATIVO
$WinWidth = $Host.UI.RawUI.WindowSize.Width
$AsciiPad = " " * [math]::Max(0, [int](($WinWidth - 80) / 2))

Write-Gradient "$AsciiPad __          ______      ______      ______      __    __      ______      ______    " 
Write-Gradient "$AsciiPad/\ \        /\  __ \    /\  == \    /\  ___\    /\ `"-.\ \    /\___  \    /\  __ \   " 
Write-Gradient "$AsciiPad\ \ \____   \ \ \/\ \   \ \  __<     \ \  __\     \ \ \-.  \   \/_/  /__   \ \ \/\ \  " 
Write-Gradient "$AsciiPad \ \_____\   \ \_____\   \ \_\ \_\   \ \_____\    \ \_\\`"\_\    /\_____\   \ \_____\ " 
Write-Gradient "$AsciiPad  \/_____/    \/_____/    \/_/ /_/    \/_____/     \/_/ \/_/    \/_____/    \/_____/ " 

Write-Host ""
$NomeUsuario = $env:USERNAME.ToUpper()
Write-DecryptEffect "BEM VINDO AO SISTEMA, $NomeUsuario"
Start-Sleep -s 1
Write-MatrixEffect

# Verifica Winget silenciosamente
if (-not (Get-Command "winget.exe" -ErrorAction SilentlyContinue)) {
    Write-Host " [AVISO] Modulo Winget nao detectado. Algumas funcoes podem falhar." -ForegroundColor DarkGreen
}

Start-Sleep -s 1
Write-Host " > ACESSO CONCEDIDO." -ForegroundColor Green
Start-Sleep -s 1

# --- FUNÇÃO AUXILIAR DE REGISTRO ---
function Set-Reg ($Path, $Name, $Value, $Type = "DWord") {
    Try {
        if (!(Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force -ErrorAction Stop
        Write-Host " [OK] CONFIGURADO: $Name" -ForegroundColor DarkGreen
    } Catch {
        Write-Host " [X] ERRO: $Name" -ForegroundColor Red
    }
}

function Write-Info ($Desc, $Manual) {
    Write-Host ""
    Write-Host " [i] FUNCAO: $Desc" -ForegroundColor Green
    Write-Host " [i] MANUAL: $Manual" -ForegroundColor DarkGray
    Write-Host ""
}

function Draw-Line {
    # Linha simples para evitar bugs de caractere
    $Line = "-" * 80
    Write-Host " $Line" -ForegroundColor DarkGreen
}

# --- FUNÇÃO SOBRE ---
function Menu-Info {
    Clear-Host
    Draw-Line
    Write-Host "                  DADOS DO SISTEMA / SOBRE                      " -ForegroundColor White
    Draw-Line
    Write-Host ""
    Write-Host "    CRIADO POR: " -NoNewline -ForegroundColor Gray; Write-Host "Lorenzo vulgo Rattao" -ForegroundColor Green
    Write-Host "    CONTATO:    " -NoNewline -ForegroundColor Gray; Write-Host "lorenzocunha01@outlook.com" -ForegroundColor White
    Write-Host "    VERSAO:     " -NoNewline -ForegroundColor Gray; Write-Host "$global:Version" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    [!] APOIE O PROJETO (PIX):" -ForegroundColor Green
    Write-Host "    Chave: " -NoNewline -ForegroundColor Gray; Write-Host "lorenzocunha01@outlook.com" -ForegroundColor White
    Write-Host ""
    
    # --- HARDWARE (Estilo Terminal) ---
    try {
        $CPU = (Get-CimInstance Win32_Processor).Name
        $RAM = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 0)
        $GPU = (Get-CimInstance Win32_VideoController).Name
        $MB_Obj = Get-CimInstance Win32_BaseBoard
        $MOBO = "$($MB_Obj.Manufacturer) $($MB_Obj.Product)"
        
        Draw-Line
        Write-Host " [HARDWARE DETECTADO]" -ForegroundColor Green
        Write-Host " > CPU:  $CPU" -ForegroundColor Gray
        Write-Host " > RAM:  $RAM GB" -ForegroundColor Gray
        Write-Host " > GPU:  $GPU" -ForegroundColor Gray
        Write-Host " > MOBO: $MOBO" -ForegroundColor Gray
    } catch {}
    
    Draw-Line
    Write-Host " [?] ORDEM RECOMENDADA DE USO:" -ForegroundColor Green
    Write-Host "      [1] Ponto de Restauracao" -ForegroundColor Gray
    Write-Host "      [2] Atualizar e Debloat (Op 6 e 5)" -ForegroundColor Gray
    Write-Host "      [3] Aplicar Otimizacoes (Todas as outras)" -ForegroundColor Gray
    Write-Host "      [4] Limpeza (Op 10)" -ForegroundColor Gray
    Write-Host "      [5] Reiniciar PC" -ForegroundColor Gray
    Write-Host ""
    
    Draw-Line
    Write-Host " [?] GUIA DE OPCOES:" -ForegroundColor Green
    Write-Host " [1] Restauracao: " -NoNewline -ForegroundColor White; Write-Host "Cria Ponto de Restauracao." -ForegroundColor Gray
    Write-Host " [2] Servicos:    " -NoNewline -ForegroundColor White; Write-Host "Desativa servicos inuteis p/ RAM." -ForegroundColor Gray
    Write-Host " [3] Visual:      " -NoNewline -ForegroundColor White; Write-Host "Remove animacoes para FPS." -ForegroundColor Gray
    Write-Host " [4] Privacidade: " -NoNewline -ForegroundColor White; Write-Host "Bloqueia telemetria Windows." -ForegroundColor Gray
    Write-Host " [5] Debloat:     " -NoNewline -ForegroundColor White; Write-Host "Remove apps inuteis (Cortana etc)." -ForegroundColor Gray
    Write-Host " [6] Atualizar:   " -NoNewline -ForegroundColor White; Write-Host "Atualiza programas e Visual C++." -ForegroundColor Gray
    Write-Host " [7] Energia/SSD: " -NoNewline -ForegroundColor White; Write-Host "Plano Ultimate + Tweak NTFS." -ForegroundColor Gray
    Write-Host " [8] Rede:        " -NoNewline -ForegroundColor White; Write-Host "DNS Gamer, TCP NoDelay." -ForegroundColor Gray
    Write-Host " [9] Perifericos: " -NoNewline -ForegroundColor White; Write-Host "Mouse/Teclado rapido, No StickyKeys." -ForegroundColor Gray
    Write-Host " [10] Limpeza:    " -NoNewline -ForegroundColor White; Write-Host "Limpa Temp, Cache e Prefetch." -ForegroundColor Gray
    Write-Host " [11] Diagnosis:  " -NoNewline -ForegroundColor White; Write-Host "Mata tarefas de diagnostico." -ForegroundColor Gray
    Write-Host " [12] Seguranca:  " -NoNewline -ForegroundColor White; Write-Host "Roda MRT, SFC e DISM." -ForegroundColor Gray
    Write-Host " [13] HPET:       " -NoNewline -ForegroundColor White; Write-Host "Desativa Timer Alta Precisao." -ForegroundColor Gray
    Write-Host " [14] Speedtest:  " -NoNewline -ForegroundColor White; Write-Host "Testa internet via CMD." -ForegroundColor Gray
    Write-Host " [15] Boot:       " -NoNewline -ForegroundColor White; Write-Host "Remove delay de inicializacao." -ForegroundColor Gray
    Write-Host " [16] Scanner:    " -NoNewline -ForegroundColor White; Write-Host "Busca profunda de falhas (Bateria, Drivers, BSOD)." -ForegroundColor Gray
    Write-Host " [17] Backup:     " -NoNewline -ForegroundColor White; Write-Host "Salva arquivos pessoais na Area de Trabalho." -ForegroundColor Gray
    Write-Host " [18] Wi-Fi Keys: " -NoNewline -ForegroundColor White; Write-Host "Revela senhas de redes Wi-Fi salvas." -ForegroundColor Gray
    Write-Host " [19] Regedit:    " -NoNewline -ForegroundColor White; Write-Host "Otimizacao forcada de registro." -ForegroundColor Gray
    Write-Host ""
    
    Read-Host " Pressione ENTER para voltar..."
}

# --- FUNÇÕES DE OTIMIZAÇÃO ---

function Menu-Restauracao {
    Write-Host "`n [1] PONTO DE RESTAURACAO" -ForegroundColor Green
    Write-Info "Backup do estado atual." "sysdm.cpl"
    Write-Host "      [1] Criar Novo Ponto" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        $desc = "Otimizacao_Lorenzo_" + (Get-Date -Format "yyyyMMdd_HHmm")
        Try { Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue; Checkpoint-Computer -Description $desc -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop; Write-Host " SUCESSO!" -ForegroundColor Green } Catch { Write-Host " AVISO: Falha ao criar ponto." -ForegroundColor Yellow }
        Read-Host " Enter..."
    }
}

function Menu-Servicos {
    Write-Host "`n [2] GERENCIAR SERVICOS" -ForegroundColor Green
    Write-Info "Desativa servicos nao essenciais." "services.msc"
    Write-Host "      [1] Otimizar (Desativar)" -ForegroundColor White
    Write-Host "      [2] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "0") { return }
    $servicos = @("WSearch", "TapiSrv", "SysMain", "Spooler", "TermService", "BDESVC", "WbioSrvc", "edgeupdate", "edgeupdatem", "MicrosoftEdgeElevationService", "SCardSvr", "WerSvc")
    if ($sub -eq "1") { foreach ($s in $servicos) { Stop-Service -Name $s -Force -ErrorAction SilentlyContinue; Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue; Write-Host " [-] $s Desativado" -ForegroundColor DarkGreen } } 
    elseif ($sub -eq "2") { foreach ($s in $servicos) { Set-Service -Name $s -StartupType Automatic -ErrorAction SilentlyContinue; Start-Service -Name $s -ErrorAction SilentlyContinue; Write-Host " [+] $s Restaurado" -ForegroundColor DarkGray } }
    Read-Host " Enter..."
}

function Menu-Visual {
    Write-Host "`n [3] GERENCIAR VISUAL" -ForegroundColor Green
    Write-Info "Remove animacoes para FPS." "sysdm.cpl"
    Write-Host "      [1] Otimizar (Foco em FPS)" -ForegroundColor White
    Write-Host "      [2] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "0") { return }
    $PathVisual = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"; $PathMetrics = "HKCU:\Control Panel\Desktop\WindowMetrics"; $exec = $false
    if ($sub -eq "1") {
        Set-ItemProperty $PathVisual "VisualFXSetting" 3 -ErrorAction SilentlyContinue; Set-ItemProperty $PathMetrics "MinAnimate" "0" -ErrorAction SilentlyContinue
        Set-ItemProperty "HKCU:\Control Panel\Desktop" "DragFullWindows" "1"; Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "IconsOnly" 0
        Set-ItemProperty "HKCU:\Control Panel\Desktop" "FontSmoothing" "2"; Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" "LogEvent" 0 -Type DWord -ErrorAction SilentlyContinue
        Write-Host " Visual Otimizado." -ForegroundColor Green; $exec = $true
    } elseif ($sub -eq "2") {
        Set-ItemProperty $PathVisual "VisualFXSetting" 1 -ErrorAction SilentlyContinue; Set-ItemProperty $PathMetrics "MinAnimate" "1" -ErrorAction SilentlyContinue
        Set-ItemProperty "HKCU:\Control Panel\Desktop" "DragFullWindows" "1"
        Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" "LogEvent" 1 -Type DWord -ErrorAction SilentlyContinue
        Write-Host " Visual Restaurado." -ForegroundColor DarkGray; $exec = $true
    }
    if ($exec) { Stop-Process -Name explorer -Force }; Read-Host " Enter..."
}

function Aplicar-GPO-Custom {
    Write-Host "`n [4] PRIVACIDADE E POLITICAS" -ForegroundColor Green
    Write-Info "Bloqueia telemetria e coleta." "Regedit / GPO"
    Write-Host "      [1] Ativar Bloqueios" -ForegroundColor White
    Write-Host "      [2] Reverter" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "AITEnable" 0; Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" 0
        Set-Reg "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0; Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground" 2
        Write-Host " [OK] Aplicado." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        Remove-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" -ErrorAction SilentlyContinue
        Remove-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
        Set-Reg "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 1
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Remover-AppsInuteis {
    Write-Host "`n [5] DEBLOAT (APPS)" -ForegroundColor Green
    Write-Info "Remove bloatware." "Powershell"
    Write-Host "      [1] Remover Lixo" -ForegroundColor White
    Write-Host "      [2] Reinstalar Tudo" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        $apps = @("*Microsoft.549981C3F5F10*", "*WindowsFeedbackHub*", "*ZuneVideo*", "*ZuneMusic*", "*Office.OneNote*", "*MSPaint*", "*People*", "*windowscommunicationsapps*", "*Microsoft.OutlookForWindows*")
        foreach ($app in $apps) { Write-Host " [-] Removendo: $app" -ForegroundColor DarkGreen; Get-AppxPackage $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue }
        Write-Host " Concluido." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        Write-Host " Reinstalando..." -ForegroundColor Yellow
        Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue}
        Read-Host " Enter..."
    }
}

function Atualizar-Programas {
    Write-Host "`n [6] ATUALIZAR SOFTWARES" -ForegroundColor Green
    Write-Info "Atualiza programas e instala Visual C++." "winget"
    Write-Host "      [1] Atualizar Tudo (Winget)" -ForegroundColor White
    Write-Host "      [2] Instalar Visual C++ (Jogos)" -ForegroundColor Yellow
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") { 
        winget upgrade --all --include-unknown --accept-source-agreements --accept-package-agreements; Read-Host " Enter..." 
    } elseif ($sub -eq "2") {
        Write-Host " [-] Instalando Visual C++..." -ForegroundColor DarkGreen
        winget install --id Microsoft.VCRedist.2015+.x64 --accept-source-agreements --accept-package-agreements
        winget install --id Microsoft.VCRedist.2015+.x86 --accept-source-agreements --accept-package-agreements
        Write-Host " [OK] Instalado." -ForegroundColor Green; Read-Host " Enter..."
    }
}

function Otimizar-Energia {
    Write-Host "`n [7] ENERGIA E DISCO" -ForegroundColor Green
    Write-Info "Plano Ultimate e Otimizacao NTFS." "powercfg / fsutil"
    Write-Host "      [1] Ativar (Ultimate)" -ForegroundColor White
    Write-Host "      [2] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null | Out-Null; powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
        powercfg -h off; fsutil behavior set disable8dot3 1 | Out-Null; fsutil behavior set disablelastaccess 1 | Out-Null
        bcdedit /set disabledynamictick yes | Out-Null; bcdedit /set useplatformtick yes | Out-Null
        Write-Host " [OK] Otimizado." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e; powercfg -h on; fsutil behavior set disable8dot3 0 | Out-Null
        bcdedit /deletevalue disabledynamictick | Out-Null
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Otimizar-Rede {
    Write-Host "`n [8] REDE E PING" -ForegroundColor Green
    Write-Info "Reduz latencia (TCP NoDelay)." "Regedit / DNS"
    Write-Host "      [1] Otimizar Latencia (TCP)" -ForegroundColor White
    Write-Host "      [2] Escolher DNS (Cloudflare/Google)" -ForegroundColor White
    Write-Host "      [3] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "0") { return }
    if ($sub -eq "1") {
        cmd /c "ipconfig /flushdns" | Out-Null
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" 4294967295
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
        $PathTCP = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
        $interfaces = Get-ChildItem $PathTCP
        foreach ($iface in $interfaces) { Set-ItemProperty $iface.PSPath "TcpAckFrequency" 1 -Type DWord -ErrorAction SilentlyContinue; Set-ItemProperty $iface.PSPath "TCPNoDelay" 1 -Type DWord -ErrorAction SilentlyContinue }
        Write-Host " [OK] Rede Otimizada." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        Write-Host "`n      [1] Cloudflare (1.1.1.1) - Gamer"
        Write-Host "      [2] Google (8.8.8.8)"
        Write-Host "      [3] Automatico (DHCP)"
        $dns = Read-Host "      > DNS"
        $Adapters = Get-NetAdapter | Where-Object Status -eq 'Up'
        if ($dns -eq "1") { Set-DnsClientServerAddress -InterfaceIndex $Adapters.InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1"); Write-Host " [OK] Cloudflare." -ForegroundColor Green }
        elseif ($dns -eq "2") { Set-DnsClientServerAddress -InterfaceIndex $Adapters.InterfaceIndex -ServerAddresses ("8.8.8.8","8.8.4.4"); Write-Host " [OK] Google." -ForegroundColor Green }
        elseif ($dns -eq "3") { Set-DnsClientServerAddress -InterfaceIndex $Adapters.InterfaceIndex -ResetServerAddresses; Write-Host " [OK] DHCP." -ForegroundColor Yellow }
        cmd /c "ipconfig /flushdns" | Out-Null
        Read-Host " Enter..."
    } elseif ($sub -eq "3") {
        Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" -ErrorAction SilentlyContinue
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Otimizar-Perifericos {
    Write-Host "`n [9] MOUSE E TECLADO" -ForegroundColor Green
    Write-Info "Remove aceleracao e delay." "Painel de Controle"
    Write-Host "      [1] Ativar (Input Lag Minimo)" -ForegroundColor White
    Write-Host "      [2] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "0" "String"; Set-Reg "HKCU:\Control Panel\Mouse" "MouseThreshold1" "0" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "0" "String"; Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardSpeed" "31" "String"
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value "506" -Type String -ErrorAction SilentlyContinue
        Write-Host " [OK] Aplicado." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "1" "String"; Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "1" "String"
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value "510" -Type String -ErrorAction SilentlyContinue
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Limpeza-Total {
    Write-Host "`n [10] LIMPEZA DE SISTEMA" -ForegroundColor Green
    Write-Info "Limpa Temp, Cache e Prefetch." "cleanmgr"
    Write-Host "      [1] Executar Limpeza" -ForegroundColor White
    Write-Host "      [2] Reativar Prefetch" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Stop-Service wuauserv -Force -ErrorAction SilentlyContinue; Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; Start-Service wuauserv -ErrorAction SilentlyContinue
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" 0
        Write-Host " [OK] Limpo!" -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" 3
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Menu-Diagnosis {
    Write-Host "`n [11] DESATIVAR DIAGNOSTICO" -ForegroundColor Green
    Write-Info "Desativa tarefas pesadas de diagnostico." "Agendador de Tarefas"
    Write-Host "      [1] Desativar (Otimizar)" -ForegroundColor White
    Write-Host "      [2] Reativar (Restaurar)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "0") { return }
    $taskPath = "\Microsoft\Windows\Diagnosis"; $tarefasAlvo = @("RecommendedTroubleshootingScanner", "Scheduled", "UnexpectedCodepath")
    if ($sub -eq "1") {
        foreach ($nome in $tarefasAlvo) {
            Write-Host " [-] Desativando: $nome" -ForegroundColor DarkGreen
            Disable-ScheduledTask -TaskName $nome -TaskPath $taskPath -ErrorAction SilentlyContinue
            cmd /c "schtasks /Change /TN \Microsoft\Windows\Diagnosis\$nome /Disable 2>nul" | Out-Null
        }
        $svcs = @("PcaSvc", "DPS", "WdiServiceHost", "WdiSystemHost")
        foreach ($s in $svcs) { Stop-Service $s -Force -ErrorAction SilentlyContinue; Set-Service $s -StartupType Disabled -ErrorAction SilentlyContinue }
        Write-Host " [OK] Desativado." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        foreach ($nome in $tarefasAlvo) { Enable-ScheduledTask -TaskName $nome -TaskPath $taskPath -ErrorAction SilentlyContinue; cmd /c "schtasks /Change /TN \Microsoft\Windows\Diagnosis\$nome /Enable 2>nul" | Out-Null }
        Set-Service "DPS" -StartupType Automatic -ErrorAction SilentlyContinue; Start-Service "DPS" -ErrorAction SilentlyContinue
        Set-Service "WdiServiceHost" -StartupType Manual -ErrorAction SilentlyContinue
        Write-Host " [OK] Reativado." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Verificar-Sistema {
    Write-Host "`n [12] SEGURANCA E REPARO" -ForegroundColor Green
    Write-Info "Executa MRT (Virus), SFC e DISM (Reparo)." "mrt / sfc / dism"
    Write-Host "      [1] Iniciar Verificacao Completa" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Write-Host " [-] Iniciando MRT..." -ForegroundColor Yellow; Start-Process "mrt.exe" "/F" -Wait
        Write-Host " [-] Verificando Arquivos (SFC)..." -ForegroundColor Yellow; sfc /scannow
        Write-Host " [-] Reparando Imagem (DISM)..." -ForegroundColor Yellow; Start-Process "dism.exe" "/online /cleanup-image /restorehealth" -Wait -NoNewWindow
        Write-Host " [OK] Concluido." -ForegroundColor Green; Read-Host " Enter..."
    }
}

function Disable-HPET {
    Write-Host "`n [13] HPET (HIGH PRECISION TIMER)" -ForegroundColor Green
    Write-Info "Desativa timer de alta precisao." "Device Manager"
    Write-Host "      [1] Desativar (Melhor Latencia)" -ForegroundColor White
    Write-Host "      [2] Reverter (Ativar)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Get-PnpDevice | Where-Object { $_.FriendlyName -match "High precision event timer" } | Disable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue
        bcdedit /deletevalue useplatformclock | Out-Null; bcdedit /set disabledynamictick yes | Out-Null
        Write-Host " [OK] Desativado." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        Get-PnpDevice | Where-Object { $_.FriendlyName -match "High precision event timer" } | Enable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue
        bcdedit /set useplatformclock yes | Out-Null; bcdedit /set disabledynamictick no | Out-Null
        Write-Host " [OK] Reativado." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Teste-Internet {
    Write-Host "`n [14] TESTE DE VELOCIDADE" -ForegroundColor Green
    Write-Info "Teste de conexao via CMD." "Speedtest CLI"
    Write-Host "      [1] Iniciar Teste" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        if (Get-Command "speedtest.exe" -ErrorAction SilentlyContinue) { speedtest } 
        else { 
            $local = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\speedtest.exe"
            if (Test-Path $local) { & $local } 
            else { 
                Write-Host " [!] Speedtest nao encontrado. Instalando..." -ForegroundColor Yellow
                winget install -e --id Ookla.Speedtest.CLI --accept-source-agreements --accept-package-agreements
            }
        }
        Read-Host " Enter..."
    }
}

function Boot-Rapido {
    Write-Host "`n [15] BOOT INSTANTANEO" -ForegroundColor Green
    Write-Info "Remove delay de inicializacao de apps." "Regedit"
    Write-Host "      [1] Ativar (Zero Delay)" -ForegroundColor White
    Write-Host "      [2] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" 0
        Write-Host " [OK] Ativado." -ForegroundColor Green; Read-Host " Enter..."
    } elseif ($sub -eq "2") {
        Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" -ErrorAction SilentlyContinue
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; Read-Host " Enter..."
    }
}

function Menu-Scanner {
    Write-Host "`n [16] SCANNER DE SISTEMA" -ForegroundColor Green
    Write-Info "Diagnostico Profundo (Hardware, Logs, Crash)." "Event Viewer / WMI"
    
    Write-Host " [?] Iniciando varredura profunda..." -ForegroundColor DarkGray
    Write-Host " [|] Carregando logs de sistema..." -ForegroundColor DarkGreen
    Start-Sleep -s 1
    
    $ProblemsFound = $false
    
    # 1. VERIFICAR TELA AZUL (BSOD) - Event ID 1001
    Write-Host " [-] Verificando Historico de Tela Azul..." -ForegroundColor Gray
    $bsod = Get-WinEvent -FilterHashtable @{LogName='System'; ID=1001} -MaxEvents 3 -ErrorAction SilentlyContinue
    if ($bsod) {
        Write-Host " [!] CRITICO: O sistema registrou Telas Azuis (BSOD) recentemente." -ForegroundColor Red
        Write-Host "     [FIX] Atualize seus Drivers (Opcao 6) e verifique a Memoria RAM." -ForegroundColor Yellow
        $ProblemsFound = $true
    }

    # 2. VERIFICAR DESLIGAMENTOS (Kernel-Power 41)
    Write-Host " [-] Verificando Desligamentos Inesperados..." -ForegroundColor Gray
    $erros = Get-WinEvent -FilterHashtable @{LogName='System'; ID=41} -MaxEvents 5 -ErrorAction SilentlyContinue
    if ($erros) {
        $qtd = $erros.Count
        Write-Host " [!] ATENCAO: Desligamento Inesperado detectado ($qtd vezes)." -ForegroundColor Yellow
        Write-Host "     [FIX] Pode ser superaquecimento ou falha na fonte de energia." -ForegroundColor DarkGray
        $ProblemsFound = $true
    }
    
    # 3. VERIFICAR HARDWARE/DRIVERS COM ERRO
    Write-Host " [-] Verificando Gerenciador de Dispositivos..." -ForegroundColor Gray
    $devErrors = Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
    if ($devErrors) {
        foreach ($dev in $devErrors) {
            Write-Host " [X] ERRO DE DRIVER: $($dev.Name) (Codigo $($dev.ConfigManagerErrorCode))" -ForegroundColor Red
        }
        Write-Host "     [FIX] Reinstale os drivers dos dispositivos acima." -ForegroundColor Yellow
        $ProblemsFound = $true
    }

    # 4. VERIFICAR SAÚDE DA BATERIA (WEAR LEVEL)
    Write-Host " [-] Verificando Saude da Bateria..." -ForegroundColor Gray
    try {
        $batt = Get-CimInstance -Namespace root\wmi -ClassName BatteryStaticData -ErrorAction Stop
        if ($batt) {
            $cap = $batt.FullChargedCapacity
            $design = $batt.DesignedCapacity
            if ($design -gt 0) {
                $health = [math]::Round(($cap / $design) * 100, 1)
                if ($health -lt 70) {
                    Write-Host " [!] BATERIA VICIADA: Saude em $health%." -ForegroundColor Red
                    Write-Host "     [FIX] Considere substituir a bateria do notebook." -ForegroundColor Yellow
                    $ProblemsFound = $true
                } else {
                    Write-Host " [OK] Bateria Saudavel ($health%)." -ForegroundColor DarkGreen
                }
            }
        }
    } catch { 
    }

    # 5. VERIFICAR APPS DE INICIALIZACAO (IMPACTO)
    Write-Host " [-] Verificando Impacto de Inicializacao..." -ForegroundColor Gray
    $startup = Get-CimInstance Win32_StartupCommand | Measure-Object
    if ($startup.Count -gt 15) {
        Write-Host " [!] LENTIDAO: Voce tem $($startup.Count) programas iniciando com o PC." -ForegroundColor Yellow
        Write-Host "     [FIX] Use a opcao [5] Debloat ou o Gerenciador de Tarefas para desativar." -ForegroundColor DarkGray
        $ProblemsFound = $true
    }

    # 6. ESPAÇO EM DISCO
    $disk = Get-Volume -DriveLetter C -ErrorAction SilentlyContinue
    if ($disk.SizeRemaining -lt 20GB) {
        $livre = [math]::Round($disk.SizeRemaining / 1GB, 1)
        Write-Host " [!] POUCO ESPACO: Apenas $livre GB livres no Disco C." -ForegroundColor Yellow
        $ProblemsFound = $true
    }

    Draw-Line
    if (-not $ProblemsFound) {
        Write-Host ""
        Write-Host " [OK] EXCELENTE: Nenhuma falha critica encontrada. Sistema Saudavel." -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host " [i] ANALISE CONCLUIDA: Verifique os avisos acima." -ForegroundColor Cyan
        Write-Host ""
    }
    Read-Host " Enter..."
}

function Menu-BackupFiles {
    Write-Host "`n [17] BACKUP DE ARQUIVOS PESSOAIS" -ForegroundColor Green
    Write-Info "Salva PDFs, Imagens e Docs na Area de Trabalho." "Copy-Item"
    
    $Desktop = [Environment]::GetFolderPath("Desktop")
    $DataHora = Get-Date -Format "yyyy-MM-dd_HHmm"
    $Destino = "$Desktop\Backup_Rattao_$DataHora"
    
    New-Item -ItemType Directory -Force -Path $Destino | Out-Null
    Write-Host " [i] Criando pasta: $Destino" -ForegroundColor Gray

    $PastasOrigem = @("Documents", "Pictures", "Desktop", "Downloads", "Music", "Videos")
    # Extensões seguras (sem executaveis)
    $Extensoes = @("*.pdf", "*.jpg", "*.jpeg", "*.png", "*.docx", "*.xlsx", "*.txt", "*.pptx", "*.zip", "*.rar", "*.mp3", "*.mp4", "*.mkv")

    foreach ($pasta in $PastasOrigem) {
        $CaminhoCompleto = "$env:USERPROFILE\$pasta"
        if (Test-Path $CaminhoCompleto) {
            Write-Host " [>] Verificando $pasta..." -ForegroundColor Yellow
            
            # Busca recursiva
            $Arquivos = Get-ChildItem -Path $CaminhoCompleto -Include $Extensoes -Recurse -ErrorAction SilentlyContinue
            
            foreach ($arq in $Arquivos) {
                # Protecao contra loop infinito (nao copiar o proprio backup)
                if ($arq.FullName -like "*$Destino*") { continue }

                Copy-Item -LiteralPath $arq.FullName -Destination $Destino -Force -ErrorAction SilentlyContinue
                Write-Host "     + Copiado: $($arq.Name)" -ForegroundColor DarkGreen
            }
        }
    }
    
    Write-Host ""
    Write-Host " [OK] Backup Concluido na Area de Trabalho!" -ForegroundColor Green
    Read-Host " Enter..."
}

function Menu-WifiKeys {
    Write-Host "`n [18] RECUPERADOR DE SENHAS WI-FI" -ForegroundColor Green
    Write-Info "Exibe senhas de redes salvas neste PC." "netsh wlan"
    
    Write-Host " [>] Varrendo perfis de rede..." -ForegroundColor Gray
    
    $Profiles = netsh wlan show profiles | Select-String "All User Profile"
    
    if (-not $Profiles) {
        Write-Host " [X] Nenhuma rede Wi-Fi encontrada ou sem adaptador." -ForegroundColor Red
    } else {
        foreach ($line in $Profiles) {
            # Extrai o nome do perfil (SSID)
            $SSID = $line.ToString().Split(":")[1].Trim()
            
            # Tenta pegar a senha
            $Info = netsh wlan show profile name="$SSID" key=clear
            $KeyLine = $Info | Select-String "Key Content"
            
            if ($KeyLine) {
                $Pass = $KeyLine.ToString().Split(":")[1].Trim()
                Write-Host " [WI-FI] $SSID" -NoNewline -ForegroundColor Yellow
                Write-Host " --> " -NoNewline -ForegroundColor DarkGray
                Write-Host "$Pass" -ForegroundColor White
            } else {
                Write-Host " [WI-FI] $SSID" -NoNewline -ForegroundColor DarkGray
                Write-Host " (Sem Senha/Aberta)" -ForegroundColor DarkGray
            }
        }
    }
    Write-Host ""
    Read-Host " Enter..."
}

# --- NOVA OPCAO 19: OTIMIZACAO DE REGISTRO (NORMAL) + REVERTER ---
function Menu-RegeditUltimate {
    Write-Host "`n [19] OTIMIZACAO DE REGISTRO (AVANCADO)" -ForegroundColor Green
    Write-Info "Gerencia configuracoes profundas do Windows." "Regedit"
    
    Write-Host " [1] Aplicar Otimizacoes (Desempenho)"
    Write-Host " [2] Restaurar Padroes (Reverter)"
    Write-Host " [0] Voltar"
    
    $sub = Read-Host " > Escolha"
    if ($sub -eq "0") { return }
    
    if ($sub -eq "1") {
        Write-Host "`n [!] APLICANDO OTIMIZACOES..." -ForegroundColor Cyan
        
        # 1. Visual
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 3 -ErrorAction SilentlyContinue
        Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate" "0" -ErrorAction SilentlyContinue
        Set-ItemProperty "HKCU:\Control Panel\Desktop" "MenuShowDelay" "0" 
        
        # 2. Rede
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" 4294967295
        
        # 3. Input
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "0" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "0" "String"
        
        # 4. Privacidade
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
        
        # 5. Boot/System
        Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" 0
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" "2000" "String"
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" 0
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "NtfsDisableLastAccessUpdate" 1
        
        Write-Host " [OK] Otimizacoes Aplicadas." -ForegroundColor Green
        
    } elseif ($sub -eq "2") {
        Write-Host "`n [!] RESTAURANDO PADROES..." -ForegroundColor Yellow
        
        # 1. Visual Restore
        Set-ItemProperty "HKCU:\Control Panel\Desktop" "MenuShowDelay" "400"
        Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate" "1" -ErrorAction SilentlyContinue
        
        # 2. Rede Restore
        Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" -ErrorAction SilentlyContinue
        
        # 3. Input Restore
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "1" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "1" "String"
        
        # 4. Privacidade Restore
        Remove-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" -ErrorAction SilentlyContinue
        
        # 5. Boot/System Restore
        Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" -ErrorAction SilentlyContinue
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" "5000" "String"
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" 20
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "NtfsDisableLastAccessUpdate" 0
        
        Write-Host " [OK] Padroes Restaurados." -ForegroundColor Green
    }
    
    Write-Host " [!] Reinicie o computador para aplicar." -ForegroundColor DarkGray
    Read-Host " Enter..."
}

# --- FUNCAO SECRETA DE NOTAS (COM CRIPTOGRAFIA BASE64 + ADS) ---
function Menu-NotasSecretas {
    # Define o caminho do arquivo e o nome do Fluxo (Stream) Oculto
    $ThisScript = $env:SCRIPT_PATH
    $StreamName = "GhostNotesEncrypted"
    
    # Backup file (caso ADS falhe)
    $BackupFile = "$ThisScript.secret"

    Do {
        Clear-Host
        Draw-Line
        Write-Host "             *** AREA CLASSIFICADA - CRIPTOGRAFADA (BASE64) ***" -ForegroundColor Black -BackgroundColor Green
        Draw-Line
        Write-Host ""
        
        $Count = 0
        
        # Tenta ler do Fluxo Oculto
        $RawNotes = @()
        try {
            $RawNotes = Get-Content -Path $ThisScript -Stream $StreamName -ErrorAction SilentlyContinue
        } catch {
            if (Test-Path $BackupFile) { $RawNotes = Get-Content $BackupFile -ErrorAction SilentlyContinue }
        }

        if ($RawNotes) {
            Write-Host " [REGISTROS DESCRIPTOGRAFADOS]:" -ForegroundColor Gray
            foreach ($encodedLine in $RawNotes) {
                try {
                    # DESCRIPTOGRAFIA (Base64 -> Texto)
                    $bytes = [System.Convert]::FromBase64String($encodedLine)
                    $decoded = [System.Text.Encoding]::UTF8.GetString($bytes)
                    Write-Host " $decoded" -ForegroundColor DarkGreen
                    $Count++
                } catch {
                    Write-Host " [X] Erro de leitura (Dados corrompidos)" -ForegroundColor Red
                }
            }
        }
        
        if ($Count -eq 0) { Write-Host " [VAZIO] Nenhum registro encontrado." -ForegroundColor DarkGray }
        
        Write-Host ""
        Draw-Line
        Write-Host " COMANDOS:" -ForegroundColor White
        Write-Host " [R] Atualizar | [limpar] Apagar tudo | [0] Sair" -ForegroundColor Gray
        Draw-Line
        
        $msg = Read-Host " > Escreva sua nota"
        
        if ($msg -eq "0") { return }
        if ($msg -eq "r" -or $msg -eq "R") { continue } 

        if ($msg -eq "limpar") { 
            try { 
                Remove-Item -Path $ThisScript -Stream $StreamName -ErrorAction SilentlyContinue 
                if (Test-Path $BackupFile) { Remove-Item $BackupFile -Force -ErrorAction SilentlyContinue }
                Write-Host " [!] REGISTROS DESTRUIDOS." -ForegroundColor Red
            } catch { Write-Host " [X] Erro ao limpar." -ForegroundColor Red }
            Start-Sleep -s 1
            
        } elseif ($msg -ne "") {
            $data = Get-Date -Format "dd/MM/yyyy HH:mm"
            $PlainPayload = "[$data] > $msg"
            
            # CRIPTOGRAFIA (Texto -> Base64)
            $Bytes = [System.Text.Encoding]::UTF8.GetBytes($PlainPayload)
            $EncodedPayload = [System.Convert]::ToBase64String($Bytes)
            
            # Salva no ADS
            try {
                Add-Content -Path $ThisScript -Stream $StreamName -Value $EncodedPayload -ErrorAction Stop
                Write-Host " [OK] Criptografado e Gravado (Stream)." -ForegroundColor Yellow
            } catch {
                try {
                    Add-Content -Path $BackupFile -Value $EncodedPayload -Force
                    $file = Get-Item $BackupFile; $file.Attributes = "Hidden"
                    Write-Host " [OK] Criptografado e Gravado (Backup)." -ForegroundColor Yellow
                } catch { Write-Host " [ERRO] Falha critica." -ForegroundColor Red }
            }
            Start-Sleep -Milliseconds 500
        }
        
    } While ($true)
}

function Write-MenuRow ($Left, $Right, $Right2) {
    # Helper to safely format columns
    $Format = { param($T) 
        if ($T -eq "" -or $T -eq $null) { return " " * 32 }
        try {
            $P = $T.Split("]")
            $Id = $P[0].Trim("["); $Tx = $P[1].Trim()
            return "$([char]27)[32m[$([char]27)[97m$Id$([char]27)[32m] $([char]27)[92m$Tx" + (" " * (32 - $T.Length))
        } catch { return " " * 32 }
    }
    
    $O1 = & $Format $Left
    $O2 = & $Format $Right
    $O3 = & $Format $Right2
    
    Write-Host "  $O1$O2$O3"
}

function Write-CenteredLink ($Key, $Text) {
    $Width = $Host.UI.RawUI.WindowSize.Width
    $Str = "[$Key] $Text"
    $PadAmt = [math]::Max(0, [int](($Width - $Str.Length) / 2))
    $Padding = " " * $PadAmt
    Write-Host $Padding -NoNewline
    Write-Host "[" -NoNewline -ForegroundColor DarkGreen
    Write-Host $Key -NoNewline -ForegroundColor White
    Write-Host "] " -NoNewline -ForegroundColor DarkGreen
    Write-Host $Text -ForegroundColor Green
}

Do {
    Clear-Host
    Draw-Line
    Write-Host "                        OTIMIZADOR DO WINDOWS                           " -ForegroundColor Green
    
    # --- HUD UPTIME (NOVO) ---
    try {
        $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
        $uptime = (Get-Date) - $boot
        $days = $uptime.Days
        $color = "DarkGray"
        if ($days -gt 7) { $color = "Red" }
        Write-Host "                        UPTIME: $days Dias, $($uptime.Hours) Horas                     " -ForegroundColor $color
    } catch {}
    
    Draw-Line
    Write-Host ""
    
    Write-MenuRow "[1] Criar Ponto Restauracao" "[8] Otimizar Rede (Ping)"     "[15] Boot Rapido"
    Write-MenuRow "[2] Desativar Servicos"      "[9] Perifericos (Input Lag)"  "[16] System Scanner"
    Write-MenuRow "[3] Otimizar Visual (FPS)"   "[10] Limpeza de Disco"        "[17] Backup Pessoal"
    Write-MenuRow "[4] Privacidade e GPO"       "[11] Desativar Diagnosis"     "[18] Wi-Fi Keys"
    Write-MenuRow "[5] Debloat (Apps)"          "[12] Seguranca e Reparo"      "[19] Regedit (Avancado)"
    Write-MenuRow "[6] Atualizar (Winget)"      "[13] Desativar HPET"          ""
    Write-MenuRow "[7] Energia e SSD"           "[14] Teste Speedtest"         ""
    
    Write-Host ""
    Write-CenteredLink "i" "Informacoes / Sobre"
    Write-CenteredLink "0" "Sair"
    
    Write-Host ""
    Draw-Line
    Write-Host ""
    
    $choice = Read-Host " > Digite sua opcao"
    
    Switch ($choice) {
        "1" { Menu-Restauracao }
        "2" { Menu-Servicos }
        "3" { Menu-Visual }
        "4" { Aplicar-GPO-Custom }
        "5" { Remover-AppsInuteis }
        "6" { Atualizar-Programas }
        "7" { Otimizar-Energia }
        "8" { Otimizar-Rede }
        "9" { Otimizar-Perifericos }
        "10" { Limpeza-Total }
        "11" { Menu-Diagnosis }
        "12" { Verificar-Sistema }
        "13" { Disable-HPET }
        "14" { Teste-Internet }
        "15" { Boot-Rapido }
        "16" { Menu-Scanner }
        "17" { Menu-BackupFiles }
        "18" { Menu-WifiKeys }
        "19" { Menu-RegeditUltimate }
        "nota" { Menu-NotasSecretas }
        "i" { Menu-Info }
        "0" { 
            Write-Host ""
            $restart = Read-Host " Deseja reiniciar o computador agora? (S/N)"
            if ($restart -eq 'S' -or $restart -eq 's') {
                Write-Host " Reiniciando..." -ForegroundColor Red
                Restart-Computer -Force
            } else {
                Exit
            }
        }
    }
} While ($choice -ne "0")
