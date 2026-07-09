@echo off
:: --- INICIADOR BLINDADO LOW ---
SET "SCRIPT_PATH=%~f0"

:: Solicita Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Executa o Codigo PowerShell de forma segura
cd /d "%~dp0"
powershell -NoExit -NoProfile -ExecutionPolicy Bypass -Command "$c = (Get-Content '%~f0' -Raw); $s = $c.IndexOf('#'+' POWERSHELL_CODE'); if ($s -ne -1) { iex $c.Substring($s) } else { Write-Host '[X] Erro critico: O codigo principal nao foi encontrado.' -ForegroundColor Red }"
exit /b
:: ---------------------------------------------------------
# POWERSHELL_CODE

# --- CONFIGURAÇÕES GERAIS ---
$Version = "4.3.1 (Process Booster & Stable)"
$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

$global:SessionLogs = @()
$global:DryRun = $false
$global:ExitScript = $false
$global:AppliedOptions = @{}

# --- FUNÇÕES CORE E LOGGING (NA MEMÓRIA) ---
function Write-Log ($Message, $Type = "INFO") {
    $stamp = Get-Date -Format "HH:mm:ss"
    $logMsg = "[$stamp] [$Type] $Message"
    $global:SessionLogs += $logMsg
}

function Set-Reg ($Path, $Name, $Value, $Type = "DWord") {
    if ($global:DryRun) {
        Write-Host " [SIMULACAO] Registro: '$Path\$Name' seria definido como '$Value'" -ForegroundColor Cyan
        Write-Log "SIMULACAO: Regedit $Path\$Name = $Value ($Type)" "SIMULACAO"
        return
    }
    Try {
        if (!(Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force -ErrorAction Stop
        Write-Host " [OK] CONFIGURADO: $Name" -ForegroundColor DarkGreen
        Write-Log "Sucesso: $Path\$Name alterado para $Value"
    } Catch {
        Write-Host " [X] ERRO: $Name" -ForegroundColor Red
        Write-Log "Falha ao configurar: $Name. Erro: $_" "ERRO"
    }
}

function Write-Info ($Desc, $Manual) {
    Write-Host ""
    Write-Host " [i] FUNCAO: $Desc" -ForegroundColor Green
    Write-Host " [i] MANUAL: $Manual" -ForegroundColor DarkGray
    Write-Host ""
}

function Draw-Line {
    Try {
        $W = $Host.UI.RawUI.WindowSize.Width
        if ($W -lt 40) { $W = 80 }
    } Catch { $W = 80 }
    $Line = "-" * ($W - 2)
    Write-Host " $Line" -ForegroundColor DarkGreen
}

# --- EFEITOS VISUAIS ---
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
Write-Typewriter " > INICIALIZANDO LOGS NA MEMORIA... [OK]" 5
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
Write-Log "Sessao do Otimizador LOW iniciada com sucesso. Versao: $Version"

# Verifica Winget silenciosamente
if (-not (Get-Command "winget.exe" -ErrorAction SilentlyContinue)) {
    Write-Host " [AVISO] Modulo Winget nao detectado. Algumas funcoes podem falhar." -ForegroundColor DarkGreen
}

Start-Sleep -s 1
Write-Host " > ACESSO CONCEDIDO." -ForegroundColor Green
Start-Sleep -s 1

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
    
    # --- HARDWARE ---
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
        if ($global:DryRun) { Write-Host " [SIMULACAO] Ponto de restauracao seria criado." -ForegroundColor Cyan; Write-Log "SIMULACAO: Criar Ponto Restore" "SIMULACAO"; return }
        $desc = "Otimizacao_Lorenzo_" + (Get-Date -Format "yyyyMMdd_HHmm")
        Write-Log "Criando Ponto de Restauracao..."
        Try { Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue; Checkpoint-Computer -Description $desc -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop; Write-Host " SUCESSO!" -ForegroundColor Green; Write-Log "Ponto criado com sucesso."; $global:AppliedOptions["1"] = $true } Catch { Write-Host " AVISO: Falha ao criar ponto." -ForegroundColor Yellow; Write-Log "Erro ao criar ponto." "ERRO" }
    }
}

function Menu-Servicos {
    Write-Host "`n [2] GERENCIAR SERVICOS" -ForegroundColor Green
    Write-Info "Desativa servicos nao essenciais." "services.msc"
    
    Write-Host " [!] ATENCAO: Desativar alguns servicos pode causar impactos:" -ForegroundColor Yellow
    Write-Host "     - Spooler: Desativa impressoras fisicas/virtuais." -ForegroundColor Gray
    Write-Host "     - TermService: Desativa acesso remoto (RDP)." -ForegroundColor Gray
    Write-Host "     - SysMain (SuperFetch): Pode deixar HDDs (discos mecanicos antigos) mais lentos." -ForegroundColor Gray
    Write-Host ""
    Write-Host "      [1] Otimizar (Desativar)" -ForegroundColor White
    Write-Host "      [2] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "0") { return }
    
    $servicos = @("WSearch", "TapiSrv", "SysMain", "Spooler", "TermService", "BDESVC", "WbioSrvc", "edgeupdate", "edgeupdatem", "MicrosoftEdgeElevationService", "SCardSvr", "WerSvc")
    
    if ($sub -eq "1") {
        $conf = Read-Host " Confirma a desativacao destes servicos? (S/N)"
        if ($conf -notmatch 's') { Write-Host " Cancelado."; return }
        
        Write-Log "Otimizando Servicos"
        foreach ($s in $servicos) {
            if ($global:DryRun) { Write-Host " [SIMULACAO] Parando e desativando servico: $s" -ForegroundColor Cyan; Write-Log "SIMULACAO: Stop/Disable Service $s" "SIMULACAO"; continue }
            Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
            Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host " [-] $s Desativado" -ForegroundColor DarkGreen
        }
        if (-not $global:DryRun) { $global:AppliedOptions["2"] = $true }
    } elseif ($sub -eq "2") {
        Write-Log "Restaurando Servicos"
        foreach ($s in $servicos) {
            if ($global:DryRun) { Write-Host " [SIMULACAO] Restaurando e iniciando servico: $s" -ForegroundColor Cyan; Write-Log "SIMULACAO: Start/Enable Service $s" "SIMULACAO"; continue }
            Set-Service -Name $s -StartupType Automatic -ErrorAction SilentlyContinue
            Start-Service -Name $s -ErrorAction SilentlyContinue
            Write-Host " [+] $s Restaurado" -ForegroundColor DarkGray
        }
        if (-not $global:DryRun) { $global:AppliedOptions["2"] = $false }
    }
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
        Write-Log "Otimizando Efeitos Visuais."
        Set-ItemProperty $PathVisual "VisualFXSetting" 3 -ErrorAction SilentlyContinue
        Set-Reg $PathMetrics "MinAnimate" "0" "String"
        Set-Reg "HKCU:\Control Panel\Desktop" "DragFullWindows" "1" "String"
        Set-Reg "HKCU:\Control Panel\Desktop" "FontSmoothing" "2" "String"
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" "LogEvent" 0
        Write-Host " Visual Otimizado." -ForegroundColor Green; $exec = $true
        if (-not $global:DryRun) { $global:AppliedOptions["3"] = $true }
    } elseif ($sub -eq "2") {
        Write-Log "Restaurando Efeitos Visuais."
        Set-ItemProperty $PathVisual "VisualFXSetting" 1 -ErrorAction SilentlyContinue
        Set-Reg $PathMetrics "MinAnimate" "1" "String"
        Set-Reg "HKCU:\Control Panel\Desktop" "DragFullWindows" "1" "String"
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" "LogEvent" 1
        Write-Host " Visual Restaurado." -ForegroundColor DarkGray; $exec = $true
        if (-not $global:DryRun) { $global:AppliedOptions["3"] = $false }
    }
    if ($exec -and (-not $global:DryRun)) { Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue }
}

function Aplicar-GPO-Custom {
    Write-Host "`n [4] PRIVACIDADE E POLITICAS" -ForegroundColor Green
    Write-Info "Bloqueia telemetria e coleta." "Regedit / GPO"
    Write-Host "      [1] Ativar Bloqueios" -ForegroundColor White
    Write-Host "      [2] Reverter" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Write-Log "Bloqueando Telemetria."
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "AITEnable" 0
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" 0
        Set-Reg "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground" 2
        Write-Host " [OK] Aplicado." -ForegroundColor Green; $global:AppliedOptions["4"] = $true
    } elseif ($sub -eq "2") {
        Write-Log "Restaurando Telemetria."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Reverteria GPOs." -ForegroundColor Cyan; return }
        Remove-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" -ErrorAction SilentlyContinue
        Remove-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" -ErrorAction SilentlyContinue
        Set-Reg "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 1
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; $global:AppliedOptions["4"] = $false
    }
}

function Remover-AppsInuteis {
    Write-Host "`n [5] DEBLOAT (APPS)" -ForegroundColor Green
    Write-Info "Remove bloatware." "Configuracoes > Apps > Apps Instalados"
    Write-Host "      [1] Remover Lixo" -ForegroundColor White
    Write-Host "      [2] Reinstalar Tudo" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Write-Log "Executando Debloat."
        $apps = @("*Microsoft.549981C3F5F10*", "*WindowsFeedbackHub*", "*ZuneVideo*", "*ZuneMusic*", "*Office.OneNote*", "*MSPaint*", "*People*", "*windowscommunicationsapps*", "*Microsoft.OutlookForWindows*")
        foreach ($app in $apps) { 
            if ($global:DryRun) { Write-Host " [SIMULACAO] Removeria App: $app" -ForegroundColor Cyan; Write-Log "SIMULACAO: Remove-AppxPackage $app" "SIMULACAO"; continue }
            Write-Host " [-] Removendo: $app" -ForegroundColor DarkGreen
            Get-AppxPackage $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue 
        }
        Write-Host " Concluido." -ForegroundColor Green; if (-not $global:DryRun) { $global:AppliedOptions["5"] = $true }
    } elseif ($sub -eq "2") {
        Write-Log "Reinstalando Bloatware."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Reinstalaria Apps nativos." -ForegroundColor Cyan; return }
        Write-Host " Reinstalando..." -ForegroundColor Yellow
        Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue}
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
        Write-Log "Atualizando programas (Winget)."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Executaria winget upgrade --all" -ForegroundColor Cyan; return }
        winget upgrade --all --include-unknown --accept-source-agreements --accept-package-agreements; $global:AppliedOptions["6"] = $true
    } elseif ($sub -eq "2") {
        Write-Log "Instalando Visual C++."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Instalaria Microsoft.VCRedist" -ForegroundColor Cyan; return }
        Write-Host " [-] Instalando Visual C++..." -ForegroundColor DarkGreen
        winget install --id Microsoft.VCRedist.2015+.x64 --accept-source-agreements --accept-package-agreements
        winget install --id Microsoft.VCRedist.2015+.x86 --accept-source-agreements --accept-package-agreements
        Write-Host " [OK] Instalado." -ForegroundColor Green
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
        Write-Log "Ativando Plano Ultimate e tweaks NTFS."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Configuraria Plano de Energia e desativaria 8dot3." -ForegroundColor Cyan; return }
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null | Out-Null; powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
        powercfg -h off; fsutil behavior set disable8dot3 1 | Out-Null; fsutil behavior set disablelastaccess 1 | Out-Null
        bcdedit /set disabledynamictick yes | Out-Null; bcdedit /set useplatformtick yes | Out-Null
        Write-Host " [OK] Otimizado." -ForegroundColor Green; $global:AppliedOptions["7"] = $true
    } elseif ($sub -eq "2") {
        Write-Log "Revertendo Energia para Padrao."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Reverteria Plano de Energia e 8dot3." -ForegroundColor Cyan; return }
        powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e; powercfg -h on; fsutil behavior set disable8dot3 0 | Out-Null
        bcdedit /deletevalue disabledynamictick | Out-Null
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; $global:AppliedOptions["7"] = $false
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
        Write-Log "Otimizando TCP/IP para Ping."
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" 4294967295
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
        if (-not $global:DryRun) {
            cmd /c "ipconfig /flushdns" | Out-Null
            $PathTCP = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
            $interfaces = Get-ChildItem $PathTCP -ErrorAction SilentlyContinue
            foreach ($iface in $interfaces) { Set-ItemProperty $iface.PSPath "TcpAckFrequency" 1 -Type DWord -ErrorAction SilentlyContinue; Set-ItemProperty $iface.PSPath "TCPNoDelay" 1 -Type DWord -ErrorAction SilentlyContinue }
        }
        Write-Host " [OK] Rede Otimizada." -ForegroundColor Green; $global:AppliedOptions["8"] = $true
    } elseif ($sub -eq "2") {
        Write-Host "`n      [1] Cloudflare (1.1.1.1) - Gamer"
        Write-Host "      [2] Google (8.8.8.8)"
        Write-Host "      [3] Automatico (DHCP)"
        $dns = Read-Host "      > DNS"
        if ($global:DryRun) { Write-Host " [SIMULACAO] Alteraria servidor DNS." -ForegroundColor Cyan; Read-Host " Enter..."; return }
        $Adapters = Get-NetAdapter | Where-Object Status -eq 'Up'
        if ($dns -eq "1") { Set-DnsClientServerAddress -InterfaceIndex $Adapters.InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1"); Write-Host " [OK] Cloudflare." -ForegroundColor Green; Write-Log "DNS Alterado: Cloudflare" }
        elseif ($dns -eq "2") { Set-DnsClientServerAddress -InterfaceIndex $Adapters.InterfaceIndex -ServerAddresses ("8.8.8.8","8.8.4.4"); Write-Host " [OK] Google." -ForegroundColor Green; Write-Log "DNS Alterado: Google" }
        elseif ($dns -eq "3") { Set-DnsClientServerAddress -InterfaceIndex $Adapters.InterfaceIndex -ResetServerAddresses; Write-Host " [OK] DHCP." -ForegroundColor Yellow; Write-Log "DNS Alterado: DHCP" }
        cmd /c "ipconfig /flushdns" | Out-Null
    } elseif ($sub -eq "3") {
        Write-Log "Revertendo Rede para Padrao."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Removeria ThrottleIndex." -ForegroundColor Cyan; return }
        Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" -ErrorAction SilentlyContinue
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; $global:AppliedOptions["8"] = $false
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
        Write-Log "Otimizando Mouse e Teclado (Input Lag)."
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "0" "String"
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseThreshold1" "0" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "0" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardSpeed" "31" "String"
        Set-Reg "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506" "String"
        Write-Host " [OK] Aplicado." -ForegroundColor Green; if (-not $global:DryRun) { $global:AppliedOptions["9"] = $true }
    } elseif ($sub -eq "2") {
        Write-Log "Restaurando Mouse e Teclado."
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "1" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "1" "String"
        Set-Reg "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "510" "String"
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; if (-not $global:DryRun) { $global:AppliedOptions["9"] = $false }
    }
}

function Limpeza-Total {
    Write-Host "`n [10] LIMPEZA DE SISTEMA" -ForegroundColor Green
    Write-Info "Limpa Temp, Cache, Prefetch e GPU Shader." "cleanmgr"
    Write-Host "      [1] Executar Limpeza Completa" -ForegroundColor White
    Write-Host "      [2] Reativar Prefetch" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Write-Log "Executando Limpeza Profunda (Arquivos e Shader Cache)."

        Write-Progress -Activity "Limpeza de Sistema" -Status "Limpando Temporarios e Lixeira..." -PercentComplete 20
        if ($global:DryRun) { Write-Host " [SIMULACAO] Apagaria pasta TEMP e Esvaziaria Lixeira." -ForegroundColor Cyan; Write-Log "SIMULACAO: Limpeza Temp/Lixeira" "SIMULACAO" }
        else {
            Stop-Service wuauserv -Force -ErrorAction SilentlyContinue; Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; Start-Service wuauserv -ErrorAction SilentlyContinue
        }

        Write-Progress -Activity "Limpeza de Sistema" -Status "Limpando Shader Cache (NVIDIA/AMD)..." -PercentComplete 60
        if ($global:DryRun) { Write-Host " [SIMULACAO] Apagaria caches GLCache e DxCache." -ForegroundColor Cyan; Write-Log "SIMULACAO: Limpeza Shader Cache" "SIMULACAO" }
        else {
            Remove-Item "$env:LOCALAPPDATA\NVIDIA\GLCache\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item "$env:LOCALAPPDATA\AMD\DxCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        }

        Write-Progress -Activity "Limpeza de Sistema" -Status "Ajustando Prefetch..." -PercentComplete 90
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" 0
        Write-Progress -Activity "Limpeza de Sistema" -Completed
        Write-Host " [OK] Sistema Limpo!" -ForegroundColor Green; if (-not $global:DryRun) { $global:AppliedOptions["10"] = $true }
    } elseif ($sub -eq "2") {
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" 3
        Write-Host " [OK] Prefetch Reativado." -ForegroundColor DarkGray; if (-not $global:DryRun) { $global:AppliedOptions["10"] = $false }
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
        Write-Log "Desativando Tarefas de Diagnostico (Scheduled Tasks)."
        foreach ($nome in $tarefasAlvo) {
            if ($global:DryRun) { Write-Host " [SIMULACAO] Desativaria tarefa: $nome" -ForegroundColor Cyan; continue }
            Write-Host " [-] Desativando: $nome" -ForegroundColor DarkGreen
            Disable-ScheduledTask -TaskName $nome -TaskPath $taskPath -ErrorAction SilentlyContinue
            cmd /c "schtasks /Change /TN \Microsoft\Windows\Diagnosis\$nome /Disable 2>nul" | Out-Null
        }
        $svcs = @("PcaSvc", "DPS", "WdiServiceHost", "WdiSystemHost")
        foreach ($s in $svcs) { 
            if ($global:DryRun) { Write-Host " [SIMULACAO] Pararia servico de log: $s" -ForegroundColor Cyan; continue }
            Stop-Service $s -Force -ErrorAction SilentlyContinue; Set-Service $s -StartupType Disabled -ErrorAction SilentlyContinue 
        }
        Write-Host " [OK] Desativado." -ForegroundColor Green; if (-not $global:DryRun) { $global:AppliedOptions["11"] = $true }
    } elseif ($sub -eq "2") {
        Write-Log "Reativando Diagnostico."
        foreach ($nome in $tarefasAlvo) { 
            if ($global:DryRun) { continue }
            Enable-ScheduledTask -TaskName $nome -TaskPath $taskPath -ErrorAction SilentlyContinue; cmd /c "schtasks /Change /TN \Microsoft\Windows\Diagnosis\$nome /Enable 2>nul" | Out-Null 
        }
        if (-not $global:DryRun) {
            Set-Service "DPS" -StartupType Automatic -ErrorAction SilentlyContinue; Start-Service "DPS" -ErrorAction SilentlyContinue
            Set-Service "WdiServiceHost" -StartupType Manual -ErrorAction SilentlyContinue
        }
        Write-Host " [OK] Reativado." -ForegroundColor DarkGray; if (-not $global:DryRun) { $global:AppliedOptions["11"] = $false }
    }
}

function Verificar-Sistema {
    Write-Host "`n [12] SEGURANCA E REPARO" -ForegroundColor Green
    Write-Info "Executa MRT (Virus), SFC e DISM (Reparo)." "mrt / sfc / dism"
    Write-Host "      [1] Iniciar Verificacao Completa" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Write-Log "Iniciando processo de verificacao do sistema SFC/DISM."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Executaria MRT, SFC e DISM." -ForegroundColor Cyan; Read-Host " Enter..."; return }
        Write-Progress -Activity "Seguranca e Reparo" -Status "Executando MRT (Antivirus)..." -PercentComplete 10
        Write-Host " [-] Iniciando MRT..." -ForegroundColor Yellow; Start-Process "mrt.exe" "/F" -Wait
        Write-Progress -Activity "Seguranca e Reparo" -Status "Verificando Arquivos (SFC)..." -PercentComplete 40
        Write-Host " [-] Verificando Arquivos (SFC)..." -ForegroundColor Yellow; sfc /scannow
        Write-Progress -Activity "Seguranca e Reparo" -Status "Reparando Imagem (DISM)..." -PercentComplete 75
        Write-Host " [-] Reparando Imagem (DISM)..." -ForegroundColor Yellow; Start-Process "dism.exe" "/online /cleanup-image /restorehealth" -Wait -NoNewWindow
        Write-Progress -Activity "Seguranca e Reparo" -Completed
        Write-Host " [OK] Concluido." -ForegroundColor Green; $global:AppliedOptions["12"] = $true
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
        Write-Log "Desativando HPET."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Desabilitaria HPET e platformclock." -ForegroundColor Cyan; Read-Host " Enter..."; return }
        Get-PnpDevice | Where-Object { $_.FriendlyName -match "High precision event timer" } | Disable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue
        bcdedit /deletevalue useplatformclock | Out-Null; bcdedit /set disabledynamictick yes | Out-Null
        Write-Host " [OK] Desativado." -ForegroundColor Green; $global:AppliedOptions["13"] = $true
    } elseif ($sub -eq "2") {
        Write-Log "Reativando HPET."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Reabilitaria HPET." -ForegroundColor Cyan; Read-Host " Enter..."; return }
        Get-PnpDevice | Where-Object { $_.FriendlyName -match "High precision event timer" } | Enable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue
        bcdedit /set useplatformclock yes | Out-Null; bcdedit /set disabledynamictick no | Out-Null
        Write-Host " [OK] Reativado." -ForegroundColor DarkGray; $global:AppliedOptions["13"] = $false
    }
}

function Teste-Internet {
    Write-Host "`n [14] TESTE DE VELOCIDADE" -ForegroundColor Green
    Write-Info "Teste de conexao via CMD." "Speedtest CLI"
    Write-Host "      [1] Iniciar Teste" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Write-Log "Iniciando teste de velocidade CMD."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Rodaria Speedtest." -ForegroundColor Cyan; Read-Host " Enter..."; return }
        $global:AppliedOptions["14"] = $true
        if (Get-Command "speedtest.exe" -ErrorAction SilentlyContinue) { speedtest } 
        else { 
            $local = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\speedtest.exe"
            if (Test-Path $local) { & $local } 
            else { 
                Write-Host " [!] Speedtest nao encontrado. Instalando..." -ForegroundColor Yellow
                winget install -e --id Ookla.Speedtest.CLI --accept-source-agreements --accept-package-agreements
            }
        }
    }
}

function Boot-Rapido {
    Write-Host "`n [15] BOOT INSTANTANEO" -ForegroundColor Green
    Write-Info "Remove delay de inicializacao de apps." "regedit > HKCU\...\Explorer\Serialize"
    Write-Host "      [1] Ativar (Zero Delay)" -ForegroundColor White
    Write-Host "      [2] Reverter (Padrao)" -ForegroundColor DarkGray
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -eq "1") {
        Write-Log "Ativando Boot Rapido (StartupDelayInMSec = 0)."
        Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" 0
        Write-Host " [OK] Ativado." -ForegroundColor Green; $global:AppliedOptions["15"] = $true
    } elseif ($sub -eq "2") {
        Write-Log "Revertendo Boot Rapido."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Removeria chave Serialize." -ForegroundColor Cyan; Read-Host " Enter..."; return }
        Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" -ErrorAction SilentlyContinue
        Write-Host " [OK] Revertido." -ForegroundColor DarkGray; $global:AppliedOptions["15"] = $false
    }
}

function Menu-Scanner {
    Write-Host "`n [16] SCANNER DE SISTEMA" -ForegroundColor Green
    Write-Info "Diagnostico Profundo (Hardware, Logs, Crash)." "eventvwr.msc (Visualizador de Eventos)"
    Write-Log "Iniciando System Scanner Profundo."
    
    Write-Host " [?] Iniciando varredura profunda..." -ForegroundColor DarkGray
    Write-Host " [|] Carregando logs de sistema..." -ForegroundColor DarkGreen
    Start-Sleep -s 1
    
    $ProblemsFound = $false
    
    # 1. VERIFICAR TELA AZUL (BSOD) - Event ID 1001
    Write-Progress -Activity "System Scanner" -Status "Verificando Historico de Tela Azul..." -PercentComplete 20
    Write-Host " [-] Verificando Historico de Tela Azul..." -ForegroundColor Gray
    $bsod = Get-WinEvent -FilterHashtable @{LogName='System'; ID=1001} -MaxEvents 3 -ErrorAction SilentlyContinue
    if ($bsod) {
        Write-Host " [!] CRITICO: O sistema registrou Telas Azuis (BSOD) recentemente." -ForegroundColor Red
        Write-Host "     [FIX] Atualize seus Drivers (Opcao 6) e verifique a Memoria RAM." -ForegroundColor Yellow
        $ProblemsFound = $true
    }

    # 2. VERIFICAR DESLIGAMENTOS (Kernel-Power 41)
    Write-Progress -Activity "System Scanner" -Status "Verificando Desligamentos Inesperados..." -PercentComplete 45
    Write-Host " [-] Verificando Desligamentos Inesperados..." -ForegroundColor Gray
    $erros = Get-WinEvent -FilterHashtable @{LogName='System'; ID=41} -MaxEvents 5 -ErrorAction SilentlyContinue
    if ($erros) {
        $qtd = $erros.Count
        Write-Host " [!] ATENCAO: Desligamento Inesperado detectado ($qtd vezes)." -ForegroundColor Yellow
        Write-Host "     [FIX] Pode ser superaquecimento ou falha na fonte de energia." -ForegroundColor DarkGray
        $ProblemsFound = $true
    }
    
    # 3. VERIFICAR HARDWARE/DRIVERS COM ERRO
    Write-Progress -Activity "System Scanner" -Status "Verificando Gerenciador de Dispositivos..." -PercentComplete 70
    Write-Host " [-] Verificando Gerenciador de Dispositivos..." -ForegroundColor Gray
    $devErrors = Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
    if ($devErrors) {
        foreach ($dev in $devErrors) {
            Write-Host " [X] ERRO DE DRIVER: $($dev.Name) (Codigo $($dev.ConfigManagerErrorCode))" -ForegroundColor Red
        }
        Write-Host "     [FIX] Reinstale os drivers dos dispositivos acima." -ForegroundColor Yellow
        $ProblemsFound = $true
    }

    # 4. ESPAÇO EM DISCO
    Write-Progress -Activity "System Scanner" -Status "Verificando Espaco em Disco..." -PercentComplete 90
    $disk = Get-Volume -DriveLetter C -ErrorAction SilentlyContinue
    if ($disk.SizeRemaining -lt 20GB) {
        $livre = [math]::Round($disk.SizeRemaining / 1GB, 1)
        Write-Host " [!] POUCO ESPACO: Apenas $livre GB livres no Disco C." -ForegroundColor Yellow
        $ProblemsFound = $true
    }
    Write-Progress -Activity "System Scanner" -Completed

    Draw-Line
    $global:AppliedOptions["16"] = $true
    if (-not $ProblemsFound) {
        Write-Host ""
        Write-Host " [OK] EXCELENTE: Nenhuma falha critica encontrada. Sistema Saudavel." -ForegroundColor Green
        Write-Log "System Scanner executado - Nenhum erro critico encontrado."
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host " [i] ANALISE CONCLUIDA: Verifique os avisos acima." -ForegroundColor Cyan
        Write-Log "System Scanner executado - Erros encontrados."
        Write-Host ""
    }
}

function Menu-BackupFiles {
    Write-Host "`n [17] BACKUP DE ARQUIVOS PESSOAIS" -ForegroundColor Green
    Write-Info "Salva PDFs, Imagens e Docs na Area de Trabalho." "Ctrl+C / Ctrl+V manual nas pastas Documentos, Imagens, Downloads"
    Write-Log "Iniciando Backup de Arquivos Pessoais."
    
    Write-Host " [!] ATENCAO: Arquivos maiores que 100MB serao ignorados por seguranca." -ForegroundColor Yellow
    
    if ($global:DryRun) { Write-Host " [SIMULACAO] Backup pularia arquivos gigantes e copiaria o resto." -ForegroundColor Cyan; Read-Host " Enter..."; return }

    $Desktop = [Environment]::GetFolderPath("Desktop")
    $DataHora = Get-Date -Format "yyyy-MM-dd_HHmm"
    $Destino = "$Desktop\Backup_Rattao_$DataHora"
    
    New-Item -ItemType Directory -Force -Path $Destino | Out-Null
    Write-Host " [i] Criando pasta: $Destino" -ForegroundColor Gray

    $PastasOrigem = @("Documents", "Pictures", "Desktop", "Downloads", "Music", "Videos")
    $Extensoes = @("*.pdf", "*.jpg", "*.jpeg", "*.png", "*.docx", "*.xlsx", "*.txt", "*.pptx", "*.zip", "*.rar", "*.mp3", "*.mp4", "*.mkv")
    $maxSize = 100MB
    $TotalPastas = $PastasOrigem.Count
    $PastaAtual = 0

    foreach ($pasta in $PastasOrigem) {
        $PastaAtual++
        $PercentPasta = [int](($PastaAtual / $TotalPastas) * 100)
        Write-Progress -Activity "Backup Pessoal" -Status "Verificando $pasta..." -PercentComplete $PercentPasta
        $CaminhoCompleto = "$env:USERPROFILE\$pasta"
        if (Test-Path $CaminhoCompleto) {
            Write-Host " [>] Verificando $pasta..." -ForegroundColor Yellow
            $Arquivos = Get-ChildItem -Path $CaminhoCompleto -Include $Extensoes -Recurse -ErrorAction SilentlyContinue
            
            foreach ($arq in $Arquivos) {
                if ($arq.FullName -like "*$Destino*") { continue }
                if ($arq.Length -gt $maxSize) {
                    Write-Host "     - Ignorado (Muito Grande): $($arq.Name)" -ForegroundColor DarkGray
                    continue
                }
                Copy-Item -LiteralPath $arq.FullName -Destination $Destino -Force -ErrorAction SilentlyContinue
                Write-Host "     + Copiado: $($arq.Name)" -ForegroundColor DarkGreen
            }
        }
    }
    Write-Progress -Activity "Backup Pessoal" -Completed
    Write-Host ""
    Write-Host " [OK] Backup Concluido na Area de Trabalho!" -ForegroundColor Green
    $global:AppliedOptions["17"] = $true
}

function Menu-WifiKeys {
    Write-Host "`n [18] RECUPERADOR DE SENHAS WI-FI" -ForegroundColor Green
    Write-Info "Exibe senhas de redes salvas neste PC." "netsh wlan show profile name=NOME key=clear (via CMD)"
    Write-Log "Executando Recuperador de Senhas Wi-Fi."
    
    Write-Host " [>] Varrendo perfis de rede..." -ForegroundColor Gray
    $global:AppliedOptions["18"] = $true
    $Profiles = netsh wlan show profiles | Select-String "All User Profile"
    
    if (-not $Profiles) {
        Write-Host " [X] Nenhuma rede Wi-Fi encontrada ou sem adaptador." -ForegroundColor Red
    } else {
        foreach ($line in $Profiles) {
            $SSID = $line.ToString().Split(":")[1].Trim()
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
}

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
        Write-Log "Iniciando Otimizacao de Registro Avancada (Regedit God)."
        
        Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 3
        Set-Reg "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate" "0" "String"
        Set-Reg "HKCU:\Control Panel\Desktop" "MenuShowDelay" "0" "String"
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" 4294967295
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "0" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "0" "String"
        Set-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
        Set-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" 0
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" "2000" "String"
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" 0
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "NtfsDisableLastAccessUpdate" 1
        
        Write-Host " [!] Aplicando Otimizacoes Extras..." -ForegroundColor Cyan
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" 2
        Set-Reg "HKCU:\Software\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" 1
        Set-Reg "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode" 1
        
        Write-Host " [-] Executando TRIM no Disco C..." -ForegroundColor DarkGray
        if ($global:DryRun) { Write-Host " [SIMULACAO] Executaria ReTrim." -ForegroundColor Cyan; Write-Log "SIMULACAO: Optimize-Volume C -ReTrim" "SIMULACAO" }
        else { Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue }
        
        Write-Host " [OK] Otimizacoes Aplicadas." -ForegroundColor Green
        $global:AppliedOptions["19"] = $true
        
    } elseif ($sub -eq "2") {
        Write-Host "`n [!] RESTAURANDO PADROES..." -ForegroundColor Yellow
        Write-Log "Revertendo Otimizacoes de Registro."
        if ($global:DryRun) { Write-Host " [SIMULACAO] Reverteria todas as chaves de registro editadas na Opcao 19." -ForegroundColor Cyan; Read-Host " Enter..."; return }
        
        Set-ItemProperty "HKCU:\Control Panel\Desktop" "MenuShowDelay" "400" -ErrorAction SilentlyContinue
        Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate" "1" -ErrorAction SilentlyContinue
        Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" -ErrorAction SilentlyContinue
        Set-Reg "HKCU:\Control Panel\Mouse" "MouseSpeed" "1" "String"
        Set-Reg "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "1" "String"
        Remove-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" -ErrorAction SilentlyContinue
        Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" -ErrorAction SilentlyContinue
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" "5000" "String"
        Set-Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" 20
        Set-Reg "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "NtfsDisableLastAccessUpdate" 0
        Remove-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" -ErrorAction SilentlyContinue
        Remove-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" -ErrorAction SilentlyContinue
        Remove-ItemProperty "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode" -ErrorAction SilentlyContinue
        
        Write-Host " [OK] Padroes Restaurados." -ForegroundColor Green
        $global:AppliedOptions["19"] = $false
    }
    Write-Host " [!] Reinicie o computador para aplicar." -ForegroundColor DarkGray
}

function Menu-PrioridadeProcesso {
    Write-Host "`n [20] PRIORIDADE E AFINIDADE DE PROCESSO" -ForegroundColor Green
    Write-Info "Ajusta prioridade (High) e isola o Core 0 do Windows." "Gerenciador de Tarefas > Detalhes > Botao direito > Definir prioridade / Afinidade"
    
    Write-Host " [!] DICA: Escreva apenas o nome do jogo/programa (ex: cs2, valorant, chrome)." -ForegroundColor Yellow
    $procName = Read-Host " > Processo ou [0] para Voltar"
    
    if ($procName -eq "0" -or [string]::IsNullOrWhiteSpace($procName)) { return }
    
    $procName = $procName.Replace(".exe", "")
    $processList = Get-Process -Name $procName -ErrorAction SilentlyContinue
    
    if (-not $processList) {
        Write-Host " [X] PROCESSO NAO ENCONTRADO: O jogo ou programa precisa estar aberto!" -ForegroundColor Red
    } else {
        foreach ($p in $processList) {
            if ($global:DryRun) { 
                Write-Host " [SIMULACAO] Alteraria '$($p.ProcessName)' para Prioridade ALTA e removeria Core 0." -ForegroundColor Cyan
                continue 
            }
            try {
                $p.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
                $cores = [Environment]::ProcessorCount
                $mask = (1 -shl $cores) - 1
                if ($cores -gt 2) { $mask = $mask -bxor 1 }
                $p.ProcessorAffinity = [System.IntPtr]$mask
                Write-Host " [OK] $($p.ProcessName) (PID: $($p.Id)) -> Prioridade ALTA | Affinity isolada." -ForegroundColor Green
                Write-Log "Processo $($p.ProcessName) otimizado: High Priority, Affinity Mask: $mask"
                $global:AppliedOptions["20"] = $true
            } catch {
                Write-Host " [X] ERRO ao modificar $($p.ProcessName). Acesso Negado pelo Anti-Cheat ou Sistema." -ForegroundColor Red
                Write-Log "Erro ao modificar processo $($p.ProcessName)." "ERRO"
            }
        }
    }
}

function Menu-DiscoSMART {
    Write-Host "`n [21] DIAGNOSTICO DE DISCO (SMART)" -ForegroundColor Green
    Write-Info "Le saude, temperatura e horas de uso do disco." "wmic diskdrive get status / CrystalDiskInfo"
    Write-Host "      [1] Iniciar Diagnostico" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -ne "1") { return }

    Write-Log "Iniciando Diagnostico SMART de Disco."
    if ($global:DryRun) { Write-Host " [SIMULACAO] Leria dados SMART dos discos fisicos." -ForegroundColor Cyan; Read-Host " Enter..."; return }

    Write-Progress -Activity "Diagnostico SMART" -Status "Consultando discos fisicos..." -PercentComplete 30
    $Discos = Get-PhysicalDisk -ErrorAction SilentlyContinue

    if (-not $Discos) {
        Write-Host " [X] Nao foi possivel acessar informacoes de disco (SMART) neste sistema." -ForegroundColor Red
        Write-Progress -Activity "Diagnostico SMART" -Completed
        Read-Host " Enter..."; return
    }

    foreach ($d in $Discos) {
        Write-Progress -Activity "Diagnostico SMART" -Status "Analisando $($d.FriendlyName)..." -PercentComplete 60
        Write-Host ""
        Write-Host " [DISCO] $($d.FriendlyName)" -ForegroundColor Yellow
        Write-Host "   Tipo:  $($d.MediaType) | Interface: $($d.BusType)" -ForegroundColor Gray

        $CorSaude = switch ($d.HealthStatus) {
            "Healthy" { "Green" }
            "Warning" { "Yellow" }
            "Unhealthy" { "Red" }
            default { "DarkGray" }
        }
        Write-Host "   Saude: " -NoNewline -ForegroundColor Gray
        Write-Host "$($d.HealthStatus)" -ForegroundColor $CorSaude

        Try {
            $Counter = Get-StorageReliabilityCounter -PhysicalDisk $d -ErrorAction SilentlyContinue
            if ($Counter) {
                if ($Counter.Temperature -gt 0) {
                    $CorTempDisco = if ($Counter.Temperature -gt 55) { "Red" } elseif ($Counter.Temperature -ge 45) { "Yellow" } else { "Green" }
                    Write-Host "   Temperatura: " -NoNewline -ForegroundColor Gray
                    Write-Host "$($Counter.Temperature)C" -ForegroundColor $CorTempDisco
                }
                if ($Counter.PowerOnHours -gt 0) {
                    $Dias = [math]::Round($Counter.PowerOnHours / 24, 0)
                    Write-Host "   Horas de Uso: $($Counter.PowerOnHours)h (~$Dias dias ligado)" -ForegroundColor Gray
                }
                if ($Counter.Wear -gt 0) {
                    Write-Host "   Desgaste (SSD): $($Counter.Wear)%" -ForegroundColor $(if ($Counter.Wear -gt 80) { "Red" } else { "Gray" })
                }
            } else {
                Write-Host "   [i] Contadores detalhados nao disponiveis para este disco." -ForegroundColor DarkGray
            }
        } Catch {
            Write-Host "   [i] Contadores detalhados nao disponiveis (requer permissao ou driver compativel)." -ForegroundColor DarkGray
        }
    }
    Write-Progress -Activity "Diagnostico SMART" -Completed
    Write-Host ""
    Write-Log "Diagnostico SMART executado."
    $global:AppliedOptions["21"] = $true
}

function Menu-TesteRAM {
    Write-Host "`n [22] TESTE DE MEMORIA RAM" -ForegroundColor Green
    Write-Info "Agenda o Windows Memory Diagnostic para o proximo boot." "mdsched.exe"
    Write-Host " [!] Uma janela abrira perguntando se quer reiniciar agora ou na proxima vez." -ForegroundColor Yellow
    Write-Host " [!] O teste roda ANTES do Windows carregar e pode levar alguns minutos." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "      [1] Abrir Ferramenta de Teste" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -ne "1") { return }

    Write-Log "Teste de Memoria RAM iniciado pelo usuario."
    if ($global:DryRun) { Write-Host " [SIMULACAO] Abriria mdsched.exe." -ForegroundColor Cyan; Write-Log "SIMULACAO: mdsched.exe" "SIMULACAO"; Read-Host " Enter..."; return }

    $global:AppliedOptions["22"] = $true
    Write-Host " [OK] Abrindo ferramenta. Escolha reiniciar agora ou depois na janela que aparecer." -ForegroundColor Green
    Start-Process "mdsched.exe"
    Start-Sleep -s 2
}

function Menu-RelatorioHardware {
    Write-Host "`n [24] RELATORIO DE HARDWARE COMPLETO" -ForegroundColor Green
    Write-Info "Exporta CPU, RAM, GPU, Discos e Placa-Mae para um arquivo .txt." "msinfo32 / Get-CimInstance"
    Write-Host "      [1] Gerar Relatorio" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -ne "1") { return }

    Write-Log "Gerando Relatorio de Hardware Completo."
    if ($global:DryRun) { Write-Host " [SIMULACAO] Geraria arquivo .txt na Area de Trabalho com dados de hardware." -ForegroundColor Cyan; Write-Log "SIMULACAO: Relatorio Hardware" "SIMULACAO"; Read-Host " Enter..."; return }

    Write-Progress -Activity "Relatorio de Hardware" -Status "Coletando dados..." -PercentComplete 30

    $Desktop = [Environment]::GetFolderPath("Desktop")
    $DataHora = Get-Date -Format "yyyy-MM-dd_HHmm"
    $ArquivoSaida = "$Desktop\Relatorio_Hardware_$DataHora.txt"

    Try {
        $CPU = Get-CimInstance Win32_Processor
        $RAMModulos = Get-CimInstance Win32_PhysicalMemory
        $GPU = Get-CimInstance Win32_VideoController
        $MB = Get-CimInstance Win32_BaseBoard
        $BIOS = Get-CimInstance Win32_BIOS
        $Discos = Get-CimInstance Win32_DiskDrive

        Write-Progress -Activity "Relatorio de Hardware" -Status "Escrevendo arquivo..." -PercentComplete 70

        $Linhas = @()
        $Linhas += "=========================================="
        $Linhas += " RELATORIO DE HARDWARE - LOW OTIMIZADOR"
        $Linhas += " Gerado em: $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
        $Linhas += "=========================================="
        $Linhas += ""
        $Linhas += "--- PROCESSADOR (CPU) ---"
        $Linhas += "Nome: $($CPU.Name)"
        $Linhas += "Nucleos: $($CPU.NumberOfCores) | Threads: $($CPU.NumberOfLogicalProcessors)"
        $Linhas += "Velocidade Maxima: $($CPU.MaxClockSpeed) MHz"
        $Linhas += ""
        $Linhas += "--- MEMORIA RAM ---"
        $TotalRAM = [math]::Round(($RAMModulos | Measure-Object -Property Capacity -Sum).Sum / 1GB, 0)
        $Linhas += "Total Instalado: $TotalRAM GB"
        foreach ($m in $RAMModulos) {
            $CapGB = [math]::Round($m.Capacity / 1GB, 0)
            $Linhas += "  Slot: $($m.DeviceLocator) | $CapGB GB | $($m.Speed) MHz | Fabricante: $($m.Manufacturer)"
        }
        $Linhas += ""
        $Linhas += "--- PLACA DE VIDEO (GPU) ---"
        foreach ($g in $GPU) { $Linhas += "Nome: $($g.Name) | VRAM: $([math]::Round($g.AdapterRAM / 1GB, 1)) GB" }
        $Linhas += ""
        $Linhas += "--- PLACA-MAE ---"
        $Linhas += "Fabricante: $($MB.Manufacturer) | Modelo: $($MB.Product)"
        $Linhas += "BIOS: $($BIOS.SMBIOSBIOSVersion) | Data: $($BIOS.ReleaseDate)"
        $Linhas += ""
        $Linhas += "--- DISCOS ---"
        foreach ($d in $Discos) {
            $TamGB = [math]::Round($d.Size / 1GB, 0)
            $Linhas += "Modelo: $($d.Model) | Tamanho: $TamGB GB | Interface: $($d.InterfaceType)"
        }
        $Linhas += ""
        $Linhas += "=========================================="

        $Linhas | Out-File -FilePath $ArquivoSaida -Encoding UTF8

        Write-Progress -Activity "Relatorio de Hardware" -Completed
        Write-Host " [OK] Relatorio salvo em: $ArquivoSaida" -ForegroundColor Green
        $global:AppliedOptions["24"] = $true
        Write-Log "Relatorio de Hardware gerado: $ArquivoSaida"
    } Catch {
        Write-Progress -Activity "Relatorio de Hardware" -Completed
        Write-Host " [X] ERRO ao gerar relatorio: $_" -ForegroundColor Red
        Write-Log "Erro ao gerar Relatorio de Hardware: $_" "ERRO"
    }
}

function Menu-TesteEstabilidade {
    Write-Host "`n [26] TESTE DE ESTABILIDADE RAPIDO" -ForegroundColor Green
    Write-Info "Estressa a CPU por 30s e monitora temperatura/throttling." "Prime95 / OCCT (ferramentas dedicadas)"
    Write-Host " [!] ATENCAO: Isso vai aumentar a temperatura da CPU temporariamente." -ForegroundColor Yellow
    Write-Host " [!] Nao recomendado logo apos trocar pasta termica (aguarde a cura, ~24h)." -ForegroundColor Yellow
    Write-Host " [!] O teste sera interrompido automaticamente se a temperatura passar de 90C." -ForegroundColor Red
    Write-Host ""
    Write-Host "      [1] Iniciar Teste (30 segundos)" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -ne "1") { return }

    Write-Log "Iniciando Teste de Estabilidade Rapido."
    if ($global:DryRun) { Write-Host " [SIMULACAO] Rodaria carga de CPU por 30s monitorando temperatura." -ForegroundColor Cyan; Write-Log "SIMULACAO: Teste Estabilidade" "SIMULACAO"; Read-Host " Enter..."; return }

    # Verifica ANTES de iniciar se a leitura de temperatura funciona neste hardware.
    # Sem isso, o abort automatico por seguranca nao tem como disparar.
    $TempDisponivel = $false
    Try {
        $zonesTeste = Get-CimInstance -Namespace root\wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
        $validZonesTeste = $zonesTeste | Where-Object { $_.CurrentTemperature -gt 2732 -and $_.CurrentTemperature -lt 4000 }
        if ($validZonesTeste) { $TempDisponivel = $true }
    } Catch {}

    if (-not $TempDisponivel) {
        Write-Host ""
        Write-Host " [!] AVISO: Este PC nao expoe leitura de temperatura via WMI." -ForegroundColor Red
        Write-Host " [!] O abort automatico de seguranca (90C) NAO vai funcionar. O teste rodara os 30s completos sem monitoramento de temperatura." -ForegroundColor Red
        Write-Host " [!] Monitore a temperatura por fora (BIOS, outro app) se tiver duvida sobre o cooler." -ForegroundColor Yellow
        $confTemp = Read-Host " Deseja continuar mesmo assim? (S/N)"
        if ($confTemp -notmatch "^[sS]") { Write-Host " [!] Cancelado." -ForegroundColor Yellow; Read-Host " Enter..."; return }
    }

    $Cores = [Environment]::ProcessorCount
    $Jobs = @()
    $LimiteSeguranca = 90
    $Abortado = $false

    Write-Host " [-] Iniciando carga em $Cores nucleos por 30 segundos..." -ForegroundColor Yellow
    for ($i = 0; $i -lt $Cores; $i++) {
        $Jobs += Start-Job -ScriptBlock { $r = 0; $sw = [Diagnostics.Stopwatch]::StartNew(); while ($sw.Elapsed.TotalSeconds -lt 30) { $r = [math]::Sqrt([math]::Pow($r + 1, 2)) } }
    }

    $Segundos = 0
    while ($Segundos -lt 30) {
        Start-Sleep -s 1
        $Segundos++
        $TempAtual = -1
        Try {
            $zones = Get-CimInstance -Namespace root\wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
            $validZones = $zones | Where-Object { $_.CurrentTemperature -gt 2732 -and $_.CurrentTemperature -lt 4000 }
            if ($validZones) { $TempAtual = [math]::Round(($validZones[0].CurrentTemperature / 10) - 273.15, 0) }
        } Catch {}

        $CorBarra = if ($TempAtual -gt 80) { "Red" } elseif ($TempAtual -ge 60) { "Yellow" } else { "Green" }
        $TempTexto = if ($TempAtual -eq -1) { "N/A" } else { "$TempAtual" + "C" }
        Write-Progress -Activity "Teste de Estabilidade" -Status "Tempo: $Segundos/30s | Temp: $TempTexto" -PercentComplete ([int](($Segundos / 30) * 100))

        if ($TempAtual -ne -1 -and $TempAtual -ge $LimiteSeguranca) {
            Write-Host ""
            Write-Host " [X] ABORTADO: Temperatura atingiu $TempAtual`C (limite: $LimiteSeguranca`C)." -ForegroundColor Red
            Write-Log "Teste de Estabilidade abortado por seguranca: $TempAtual C" "ERRO"
            $Abortado = $true
            break
        }
    }

    Write-Progress -Activity "Teste de Estabilidade" -Completed
    $Jobs | Stop-Job -ErrorAction SilentlyContinue
    $Jobs | Remove-Job -Force -ErrorAction SilentlyContinue

    if (-not $Abortado) {
        Write-Host ""
        Write-Host " [OK] Teste concluido sem atingir o limite de seguranca." -ForegroundColor Green
        Write-Log "Teste de Estabilidade concluido sem abortar."
        $global:AppliedOptions["26"] = $true
    }
}

function Menu-ExportarSessao {
    Write-Host "`n [28] EXPORTAR RELATORIO DA SESSAO" -ForegroundColor Green
    Write-Info "Salva todos os logs desta sessao em um arquivo .txt." "Copiar manualmente do [L] Logs"
    Write-Host "      [1] Exportar Agora" -ForegroundColor White
    Write-Host "      [0] Voltar" -ForegroundColor Gray
    $sub = Read-Host "      > Escolha"
    if ($sub -ne "1") { return }

    if ($global:SessionLogs.Count -eq 0) {
        Write-Host " [!] Nenhuma acao registrada nesta sessao ainda." -ForegroundColor Yellow
        Read-Host " Enter..."; return
    }

    $Desktop = [Environment]::GetFolderPath("Desktop")
    $DataHora = Get-Date -Format "yyyy-MM-dd_HHmm"
    $ArquivoSaida = "$Desktop\LOW_Sessao_$DataHora.txt"

    Try {
        $Cabecalho = @(
            "=========================================="
            " LOW OTIMIZADOR - RELATORIO DE SESSAO"
            " Versao: $Version"
            " Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
            " Usuario: $env:USERNAME"
            "=========================================="
            ""
        )
        $Rodape = @(
            ""
            "=========================================="
            " Total de acoes registradas: $($global:SessionLogs.Count)"
            "=========================================="
        )
        $Cabecalho + $global:SessionLogs + $Rodape | Out-File -FilePath $ArquivoSaida -Encoding UTF8

        Write-Host " [OK] Relatorio de sessao salvo em: $ArquivoSaida" -ForegroundColor Green
        Write-Log "Relatorio de Sessao exportado: $ArquivoSaida"
        $global:AppliedOptions["28"] = $true
    } Catch {
        Write-Host " [X] ERRO ao exportar relatorio: $_" -ForegroundColor Red
        Write-Log "Erro ao exportar relatorio de sessao: $_" "ERRO"
    }
}

function Quick-Optimize {
    Clear-Host
    Draw-Line
    Write-Host "                  [99] QUICK OPTIMIZE - CONFIRMACAO                  " -ForegroundColor Magenta
    Draw-Line
    Write-Host ""
    Write-Host " As seguintes acoes serao executadas em sequencia:" -ForegroundColor White
    Write-Host "   [1]  Criar Ponto de Restauracao" -ForegroundColor Gray
    Write-Host "   [3]  Otimizar Visual (FPS)" -ForegroundColor Gray
    Write-Host "   [7]  Ativar Energia Ultimate" -ForegroundColor Gray
    Write-Host "   [8]  Otimizar Rede (Ping)" -ForegroundColor Gray
    Write-Host "   [15] Ativar Boot Rapido" -ForegroundColor Gray
    Write-Host "   [10] Executar Limpeza Profunda" -ForegroundColor Gray
    Write-Host ""
    if ($global:DryRun) { Write-Host " [i] MODO SIMULACAO ATIVO: nenhuma alteracao real sera feita." -ForegroundColor Cyan; Write-Host "" }
    $conf = Read-Host " Deseja continuar? (S/N)"
    if ($conf -notmatch "^[sS]") { Write-Host " [!] Cancelado pelo usuario." -ForegroundColor Yellow; Start-Sleep -s 1; return }

    Write-Host "`n [99] QUICK OPTIMIZE INICIADO..." -ForegroundColor Magenta
    Write-Host " [i] Cada modulo ainda vai pedir a escolha [1/2/0] uma vez; a pausa de Enter entre eles foi removida." -ForegroundColor DarkGray
    Write-Log "Quick Optimize acionado pelo usuario."
    Menu-Restauracao
    Menu-Visual
    Otimizar-Energia
    Otimizar-Rede
    Boot-Rapido
    Limpeza-Total
    Write-Host "`n [!] QUICK OPTIMIZE CONCLUIDO COM SUCESSO." -ForegroundColor Magenta
}

# --- FUNCAO SECRETA DE NOTAS (COM CODIFICACAO BASE64 + ADS) ---
function Menu-NotasSecretas {
    $ThisScript = $env:SCRIPT_PATH
    $StreamName = "GhostNotesEncrypted"
    $BackupFile = "$ThisScript.secret"

    Do {
        Clear-Host
        Draw-Line
        Write-Host "             *** AREA CLASSIFICADA - CODIFICADA (BASE64) ***" -ForegroundColor Black -BackgroundColor Green
        Draw-Line
        Write-Host ""
        
        $Count = 0
        $RawNotes = @()
        try { $RawNotes = Get-Content -Path $ThisScript -Stream $StreamName -ErrorAction SilentlyContinue } 
        catch { if (Test-Path $BackupFile) { $RawNotes = Get-Content $BackupFile -ErrorAction SilentlyContinue } }

        if ($RawNotes) {
            Write-Host " [REGISTROS DECODIFICADOS]:" -ForegroundColor Gray
            foreach ($encodedLine in $RawNotes) {
                try {
                    $bytes = [System.Convert]::FromBase64String($encodedLine)
                    Write-Host " $([System.Text.Encoding]::UTF8.GetString($bytes))" -ForegroundColor DarkGreen
                    $Count++
                } catch { Write-Host " [X] Erro de leitura" -ForegroundColor Red }
            }
        }
        if ($Count -eq 0) { Write-Host " [VAZIO] Nenhum registro encontrado." -ForegroundColor DarkGray }
        
        Write-Host "`n COMANDOS: [R] Atualizar | [limpar] Apagar tudo | [0] Sair" -ForegroundColor Gray
        $msg = Read-Host " > Escreva sua nota"
        
        if ($msg -eq "0") { return }
        if ($msg -eq "r" -or $msg -eq "R") { continue } 

        if ($msg -eq "limpar") { 
            try { 
                Remove-Item -Path $ThisScript -Stream $StreamName -ErrorAction SilentlyContinue 
                if (Test-Path $BackupFile) { Remove-Item $BackupFile -Force -ErrorAction SilentlyContinue }
                Write-Host " [!] REGISTROS DESTRUIDOS." -ForegroundColor Red
            } catch {}
            Start-Sleep -s 1
        } elseif ($msg -ne "") {
            $data = Get-Date -Format "dd/MM/yyyy HH:mm"
            $EncodedPayload = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("[$data] > $msg"))
            try { Add-Content -Path $ThisScript -Stream $StreamName -Value $EncodedPayload -ErrorAction Stop } 
            catch { Add-Content -Path $BackupFile -Value $EncodedPayload -Force; (Get-Item $BackupFile).Attributes = "Hidden" }
        }
    } While ($true)
}

function Write-MenuRow ($Left, $Right, $Right2) {
    $Format = { param($T) 
        if ([string]::IsNullOrEmpty($T)) { return " " * 35 }
        try {
            $P = $T.Split("]")
            $Id = $P[0].Trim("["); $Tx = $P[1].Trim()
            $Status = ""
            if ($global:AppliedOptions.ContainsKey($Id)) {
                if ($global:AppliedOptions[$Id] -eq $true) { $Status = "$([char]27)[92m " + [char]0x2714 } # verde check
                else { $Status = "$([char]27)[90m " + [char]0x21BA } # cinza revertido
            }
            $Base = "$([char]27)[32m[$([char]27)[97m$Id$([char]27)[32m] $([char]27)[92m$Tx"
            $VisibleLen = $T.Length + $(if ($Status -ne "") { 2 } else { 0 })
            return $Base + $Status + (" " * (35 - $VisibleLen)) + "$([char]27)[0m"
        } catch { return " " * 35 }
    }
    Write-Host "  $(& $Format $Left)$(& $Format $Right)$(& $Format $Right2)"
}

Do {
    Clear-Host
    Draw-Line
    Write-Host "                        LOW OTIMIZADOR DO WINDOWS                           " -ForegroundColor Green
    
    # --- HUD UPTIME & TEMP ---
    try {
        $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
        $uptime = (Get-Date) - $boot
        $color = if ($uptime.Days -gt 7) { "Red" } else { "DarkGray" }
        Write-Host "                        UPTIME: $($uptime.Days) Dias, $($uptime.Hours) Horas                     " -ForegroundColor $color
        
        # Leitura da Temperatura CPU (WMI) - Aviso Visual Adicionado
        $cpuTemp = "N/A"; $cpuTempVal = -1
        try {
            $zones = Get-CimInstance -Namespace root\wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
            if ($zones) {
                $validZones = $zones | Where-Object { $_.CurrentTemperature -gt 2732 -and $_.CurrentTemperature -lt 4000 }
                if ($validZones) {
                    $cTemp = [math]::Round(($validZones[0].CurrentTemperature / 10) - 273.15, 0)
                    $cpuTemp = "$cTemp" + "C"
                    $cpuTempVal = $cTemp
                }
            }
        } catch {}

        # Leitura da Temperatura GPU (NVIDIA-SMI)
        $gpuTemp = "N/A"; $gpuTempVal = -1
        try {
            $nsmi = "C:\Windows\System32\nvidia-smi.exe"
            if (Test-Path $nsmi) {
                $g = & $nsmi --query-gpu=temperature.gpu --format=csv,noheader 2>$null
                if ($g) { $gpuTemp = "$g" + "C"; $gpuTempVal = [int]$g }
            }
        } catch {}

        # Cor de estado: Verde <60C, Amarelo 60-80C, Vermelho >80C (Design 4)
        $CorTemp = { param($V)
            if ($V -eq -1) { return "DarkGray" }
            elseif ($V -gt 80) { return "Red" }
            elseif ($V -ge 60) { return "Yellow" }
            else { return "Green" }
        }
        $CorCPU = & $CorTemp $cpuTempVal
        $CorGPU = & $CorTemp $gpuTempVal

        Write-Host "                        CPU: " -ForegroundColor DarkGray -NoNewline
        Write-Host "$cpuTemp" -ForegroundColor $CorCPU -NoNewline
        Write-Host " (Depende BIOS) | GPU: " -ForegroundColor DarkGray -NoNewline
        Write-Host "$gpuTemp" -ForegroundColor $CorGPU
    } catch {}
    
    if ($global:DryRun) {
        Write-Host "                        MODO SIMULACAO ATIVADO" -ForegroundColor Cyan -BackgroundColor Black
    }
    
    Draw-Line
    Write-Host ""
    
    Write-Host ""
    Write-Host "  -- DESEMPENHO -------------------------------------------------------------" -ForegroundColor DarkGreen
    Write-MenuRow "[3] Otimizar Visual (FPS)"   "[7] Energia e SSD"            "[9] Perifericos (Input Lag)"
    Write-MenuRow "[13] Desativar HPET"         "[15] Boot Rapido"             "[20] Prioridade Processo"
    Write-MenuRow "[26] Teste Estabilidade"     ""                             ""

    Write-Host ""
    Write-Host "  -- REDE -------------------------------------------------------------------" -ForegroundColor DarkGreen
    Write-MenuRow "[8] Otimizar Rede (Ping)"    "[14] Teste Speedtest"         "[18] Wi-Fi Keys"

    Write-Host ""
    Write-Host "  -- MANUTENCAO & DIAGNOSTICO -----------------------------------------------" -ForegroundColor DarkGreen
    Write-MenuRow "[5] Debloat (Apps)"          "[6] Atualizar (Winget)"       "[10] Limpeza Profunda"
    Write-MenuRow "[12] Seguranca e Reparo"     "[16] System Scanner"          "[17] Backup Pessoal"
    Write-MenuRow "[21] Disco (SMART)"          "[22] Teste de RAM"            "[24] Relatorio Hardware"

    Write-Host ""
    Write-Host "  -- SISTEMA & AVANCADO -----------------------------------------------------" -ForegroundColor DarkGreen
    Write-MenuRow "[1] Criar Ponto Restauracao" "[2] Desativar Servicos"       "[4] Privacidade e GPO"
    Write-MenuRow "[11] Desativar Diagnosis"    "[19] Regedit (Avancado)"      "[28] Exportar Sessao"
    
    Write-Host ""
    Write-Host "  $([char]27)[32m[$([char]27)[97mi$([char]27)[32m] $([char]27)[92mSobre   $([char]27)[32m[$([char]27)[97mL$([char]27)[32m] $([char]27)[92mLogs   $([char]27)[32m[$([char]27)[97mD$([char]27)[32m] $([char]27)[92mDry-Run   $([char]27)[32m[$([char]27)[97m99$([char]27)[32m] $([char]27)[92mQUICK OPTIMIZE   $([char]27)[32m[$([char]27)[97m0$([char]27)[32m] $([char]27)[92mSair"
    Draw-Line
    
    $rawChoice = Read-Host "`n > Digite sua(s) opcao(oes) separadas por virgula (ex: 1,3,10)"
    $choices = $rawChoice -split ","
    
    foreach ($c in $choices) {
        $choice = $c.Trim()
        Write-Log "Opcao selecionada: $choice"
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
            "20" { Menu-PrioridadeProcesso }
            "21" { Menu-DiscoSMART }
            "22" { Menu-TesteRAM }
            "24" { Menu-RelatorioHardware }
            "26" { Menu-TesteEstabilidade }
            "28" { Menu-ExportarSessao }
            "99" { Quick-Optimize }
            "nota" { Menu-NotasSecretas }
            "i" { Menu-Info }
            "d" { 
                $global:DryRun = -not $global:DryRun
                if ($global:DryRun) { Write-Host "`n [!] MODO SIMULACAO ATIVADO! (Dry-Run)" -ForegroundColor Cyan }
                else { Write-Host "`n [!] MODO SIMULACAO DESATIVADO!" -ForegroundColor Yellow }
                Start-Sleep -s 1
            }
            "l" { 
                Clear-Host
                Draw-Line
                Write-Host "                  LOGS DA SESSAO ATUAL                      " -ForegroundColor White
                Draw-Line
                Write-Host ""
                if ($global:SessionLogs.Count -eq 0) {
                    Write-Host " Nenhuma acao registrada ainda." -ForegroundColor DarkGray
                } else {
                    foreach ($log in $global:SessionLogs) {
                        if ($log -match "\[ERRO\]|\[ERROR\]") { Write-Host " $log" -ForegroundColor Red }
                        elseif ($log -match "\[SIMULACAO\]") { Write-Host " $log" -ForegroundColor Cyan }
                        else { Write-Host " $log" -ForegroundColor DarkGreen }
                    }
                }
                Write-Host ""
            }
            "0" { 
                $restart = Read-Host "`n Deseja reiniciar o computador agora? (S/N)"
                if ($restart -match 's') { Restart-Computer -Force }
                $global:ExitScript = $true
            }
            Default { if ($choice -ne "") { Write-Log "Comando ignorado: $choice" } }
        }
    }
    $SemPromptDuplo = @("i", "l", "d", "0", "nota")
    $PrecisaPrompt = $true
    foreach ($c2 in $choices) {
        if ($SemPromptDuplo -contains $c2.Trim().ToLower()) { $PrecisaPrompt = $false; break }
    }
    if (-not $global:ExitScript -and $rawChoice -ne "" -and $PrecisaPrompt) {
        Read-Host "`n Pressione ENTER para voltar ao menu principal..."
    }
} While (-not $global:ExitScript)