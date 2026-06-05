# 🚀 LOW - Limpeza e Otimizador do Windows

![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue?style=for-the-badge&logo=windows)
![Language](https://img.shields.io/badge/Language-Batch%20%7C%20PowerShell-green?style=for-the-badge&logo=powershell)
![License](https://img.shields.io/badge/License-Open%20Source-orange?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-4.3.0-brightgreen?style=for-the-badge)

**LOW** é uma suíte de manutenção e otimização "All-in-One" escrita nativamente com uma arquitetura híbrida (Batch como iniciador blindado + PowerShell para a lógica). Foi desenvolvido para gamers, power users e técnicos que desejam extrair o máximo de desempenho do hardware de forma segura, sem precisar instalar software pesado de terceiros.

O script opera com uma interface CLI ao estilo "Hacker", contando com recursos de simulação, execução em lote e monitoramento de hardware em tempo real.

---

## ⚡ Execução Rápida (sem download)

A forma mais rápida de usar o LOW. Abra o **CMD como Administrador**, cole o comando abaixo e pressione Enter:

```powershell
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/oLorenZin/Project-LOW/main/project_low.bat' -OutFile '$env:TEMP\low.bat'; Start-Process '$env:TEMP\low.bat' -Verb RunAs"
```

> Requer conexão com a internet. O arquivo é baixado temporariamente e executado com privilégios de administrador.

---

## 🔥 Funcionalidades Principais

O LOW oferece **20 módulos principais** e comandos inteligentes organizados num painel de fácil acesso:

### ⚙️ Execução Inteligente

- **Seleção Múltipla** — Execute várias tarefas de uma vez, separando por vírgulas. Ex: `1,3,10`
- **[99] Quick Optimize** — Atalho que executa o "Top 5" de otimizações essenciais em sequência
- **[D] Dry-Run** — Simula todas as ações sem aplicar nenhuma alteração real. Ideal para auditorias
- **[L] Logs em Memória** — Exibe relatório completo de tudo que foi alterado ou simulado na sessão

### ⚡ Desempenho & FPS

- **Otimização Visual** — Remove animações e efeitos desnecessários do Windows
- **[20] Prioridade de Processo** — Define afinidade de núcleos e prioridade Alta para jogos em tempo real
- **HUD de Hardware** — Temperatura de CPU/GPU e Uptime exibidos diretamente no cabeçalho
- **Modo Energia Ultimate** — Ativa planos de energia ocultos e otimiza SSD via TRIM (`Optimize-Volume`)
- **HPET & Latência** — Desativa o High Precision Event Timer para reduzir micro-stuttering em jogos

### 🌐 Rede & Conectividade

- **Otimização TCP** — Ajustes avançados de registro para reduzir ping (TCP NoDelay, AckFrequency, NetworkThrottling)
- **DNS Gamer** — Troca rápida para DNS Cloudflare (1.1.1.1) ou Google
- **Wi-Fi Keys** — Recupera e exibe as senhas de todas as redes Wi-Fi salvas no PC

### 🛡️ Manutenção Segura

- **System Scanner** — Diagnóstico profundo: saúde da bateria, erros de drivers e histórico de BSODs
- **Limpeza Profunda** — Remove lixo de sistema, Prefetch e limpa Shader Cache (NVIDIA/AMD)
- **Backup Inteligente** — Copia PDFs e documentos para a Área de Trabalho, ignorando arquivos acima de 100MB
- **Proteção de Serviços** — Avisos detalhados antes de desativar recursos críticos como Spooler e RDP

### 🔧 Avançado

- **[19] Regedit Ultimate** — Aplica tweaks avançados com um clique: HAGS, GPU Scheduling, Game Mode, desativação do Bing
- **Notas Secretas (ADS)** — Anotações em Base64 armazenadas de forma invisível via Alternate Data Streams

---

## 📸 Interface

```
 --------------------------------------------------------------------------------
                        LOW OTIMIZADOR DO WINDOWS
                        UPTIME: 0 Dias, 4 Horas
                        CPU: 45C (Depende BIOS) | GPU: 50C
 --------------------------------------------------------------------------------

  [1] Criar Ponto Restauracao      [8] Otimizar Rede (Ping)         [15] Boot Rapido
  [2] Desativar Servicos           [9] Perifericos (Input Lag)      [16] System Scanner
  [3] Otimizar Visual (FPS)        [10] Limpeza Profunda            [17] Backup Pessoal
  [4] Privacidade e GPO            [11] Desativar Diagnosis         [18] Wi-Fi Keys
  [5] Debloat (Apps)               [12] Seguranca e Reparo          [19] Regedit (Avancado)
  [6] Atualizar (Winget)           [13] Desativar HPET              [20] Prioridade Processo
  [7] Energia e SSD                [14] Teste Speedtest

  [i] Sobre   [L] Logs   [D] Dry-Run   [99] QUICK OPTIMIZE   [0] Sair
 --------------------------------------------------------------------------------
 > Digite sua(s) opcao(oes) separadas por virgula (ex: 1,3,10):
```

---

## 🚀 Como Usar (Manual)

Caso prefira manter o arquivo no seu computador (100% Portable, sem instalação):

1. Baixe o arquivo `.bat` na [última release](https://github.com/oLorenZin/Project-LOW/releases) ou clique em **Code > Download ZIP**
2. Clique com o botão direito em `project_low.bat`
3. Selecione **"Executar como Administrador"** — necessário para alterações no registro e serviços
4. Siga as instruções na tela. Recomenda-se começar pela **Opção 1 (Ponto de Restauro)**

---

## ⚠️ Aviso Legal

Este software altera configurações profundas do Registro do Windows e serviços do sistema. Embora tenha sido testado e possua modo de simulação (Dry-Run):

- **Use por sua conta e risco**
- Sempre crie um Ponto de Restauro antes de executar otimizações em massa (especialmente a Opção 19)

---

## 🤝 Contribuição

Sinta-se à vontade para fazer um **Fork**, estudar o código híbrido, sugerir melhorias via **Issues** ou enviar um **Pull Request**.

---

*Desenvolvido com 💚 e ☕*