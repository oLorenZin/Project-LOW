# 🚀 LOW - Limpeza e Otimizador do Windows

![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue?style=for-the-badge&logo=windows)
![Language](https://img.shields.io/badge/Language-Batch%20%7C%20PowerShell-green?style=for-the-badge&logo=powershell)
![License](https://img.shields.io/badge/License-Open%20Source-orange?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-4.3.0%20-brightgreen?style=for-the-badge)

**LOW** é uma suíte de manutenção e otimização "All-in-One" escrita nativamente com uma arquitetura híbrida (Batch como iniciador blindado + PowerShell para a lógica). Foi desenvolvido para gamers, power users e técnicos que desejam extrair o máximo de desempenho do hardware de forma segura, sem ter de instalar software pesado de terceiros.

O script opera com uma interface CLI (Linha de Comando) ao estilo "Hacker/Alien", contando agora com recursos de simulação, execução em lote e monitorização de hardware em tempo real.

---

## 🔥 Funcionalidades Principais

O LOW oferece 20 módulos principais e comandos inteligentes organizados num painel de fácil acesso:

### ⚙️ Execução Inteligente (NOVIDADE)
- **Seleção Múltipla:** Execute várias tarefas de uma só vez, separando-as por vírgulas (Ex: `1,3,10`).
- **[99] Quick Optimize:** Um atalho de um clique para executar o "Top 5" de otimizações essenciais (Ponto de Restauro, Visual, Energia, Rede e Limpeza).
- **[D] Modo Dry-Run (Simulação):** Testa o script sem aplicar qualquer alteração real no sistema. Excelente para auditorias.
- **[L] Registos (Logs) em Memória:** Exibe um relatório completo na consola de tudo o que foi alterado ou simulado durante a sessão atual.

### ⚡ Desempenho & FPS
- **Otimização Visual:** Remove animações e efeitos desnecessários do Windows.
- **[20] Prioridade de Processo:** Isola núcleos (Afinidade) e define prioridade Alta para jogos e aplicações pesadas em tempo real.
- **HUD de Hardware:** Monitorização de **Temperatura da CPU / GPU** e **Uptime** diretamente no cabeçalho.
- **Modo Energia Ultimate:** Ativa planos de energia ocultos e otimiza o SSD com a funcionalidade TRIM (`Optimize-Volume`).
- **HPET & Latência:** Desativa o *High Precision Event Timer* para reduzir o micro-stuttering em jogos.

### 🌐 Rede & Conectividade
- **Otimização TCP:** Ajustes avançados de registo para reduzir o Ping (TCP NoDelay, AckFrequency, NetworkThrottling).
- **DNS Gamer:** Troca rápida para DNS Cloudflare (1.1.1.1) ou Google.
- **Wi-Fi Keys:** Recupera e exibe as palavras-passe (senhas) de todas as redes Wi-Fi guardadas no PC.

### 🛡️ Manutenção Segura
- **System Scanner:** Diagnóstico profundo (Saúde da Bateria, Erros de Controladores/Drivers e Histórico de Ecrãs Azuis/BSOD).
- **Limpeza Profunda:** Remove lixo de sistema, Prefetch e limpa o **Shader Cache (NVIDIA/AMD)**, resolvendo travamentos (stuttering).
- **Backup Inteligente:** Copia PDFs e documentos para o Ambiente de Trabalho (ignorando, por segurança, ficheiros maiores do que 100MB).
- **Proteção de Serviços:** Avisos detalhados antes de desativar recursos vitais (Spooler de Impressão, acesso remoto RDP, etc.).

### 🔧 Avançado
- **[19] Regedit Ultimate:** Aplica ajustes avançados num só clique (HAGS / GPU Scheduling, Game Mode, Desativação do Bing na Pesquisa).
- **Notas Secretas (ADS):** Sistema de anotações codificadas em Base64, guardadas de forma invisível via *Alternate Data Streams* dentro do próprio script.

---

## 📸 Interface

```text
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

⚡ Execução Rápida (sem download)
A forma mais rápida de testar o LOW. Abra o CMD como Administrador, cole o comando abaixo e prima Enter:

powershell -ExecutionPolicy Bypass -Command "iwr '[https://raw.githubusercontent.com/oLorenZin/Project-LOW/main/project_low.bat](https://raw.githubusercontent.com/oLorenZin/Project-LOW/main/project_low.bat)' -OutFile '$env:TEMP\low.bat'; Start-Process '$env:TEMP\low.bat' -Verb RunAs"

🚀 Como Usar (Manual)
Caso prefira transferir o ficheiro e mantê-lo no seu computador (O script é 100% "Portable"):

Descarregue o ficheiro .bat da última release ou clique em Code > Download ZIP.

Clique com o botão direito do rato no ficheiro project_low.bat.

Selecione "Executar como Administrador" (Necessário para aplicar alterações no registo e nos serviços).

Dica: Para executar o script sem as animações de texto (Modo Rápido), abra-o através do terminal usando project_low.bat --fast.

Siga as instruções apresentadas no ecrã. Recomenda-se vivamente começar pela Opção 1 (Ponto de Restauro).

⚠️ Aviso Legal
Este software altera configurações profundas do Registo do Windows e serviços vitais do sistema. Embora tenha sido exaustivamente testado, validado para segurança e possua um modo de simulação (Dry-Run):

Utilize por sua conta e risco.

Faça sempre um backup dos seus dados importantes e crie um Ponto de Restauro antes de executar ferramentas de otimização em massa (como a Opção 19).

🤝 Contribuição
Sinta-se à vontade para fazer um Fork deste projeto, estudar o código híbrido, sugerir melhorias através de Issues ou enviar um Pull Request.

Desenvolvido com 💚 e ☕.