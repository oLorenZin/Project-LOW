# 📖 GUIA RÁPIDO - PROJECT-LOW v4.0

## ⚡ START RÁPIDO

### 1️⃣ Executar Normalmente
```cmd
project_low_v4.bat
```
Abre o menu com todas as animações e efeitos visuais.

---

### 2️⃣ Modo DRY-RUN (SEM RISCO) ⭐ RECOMENDADO PRIMEIRO
```cmd
project_low_v4.bat --dry-run
```
Simula tudo sem fazer alterações. Perfeito para testar antes de aplicar.

---

### 3️⃣ Modo FAST (SEM ANIMAÇÕES)
```cmd
project_low_v4.bat --fast
```
Executa normal mas sem efeitos visuais (mais rápido).

---

## 📋 O QUE FOI MELHORADO

### ✅ Logging
- **Arquivo:** Desktop\LOW_Logs\LOW_YYYYMMDD_HHMM.log
- **O que registra:** Cada operação com timestamp
- **Para quê:** Auditoria, troubleshooting, histórico

### ✅ Health Check
- **Quando:** Automático ao iniciar
- **Verifica:** Espaço disco, RAM, admin, Windows version
- **Avisa:** Se espaço < 5GB ou RAM < 1GB

### ✅ Relatório
- **Gerado:** Automaticamente ao sair (tecla [0])
- **Arquivo:** Desktop\LOW_Report_YYYYMMDD_HHMMSS.txt
- **Contém:** Resumo completo de tudo que foi feito

### ✅ Rastreamento
- Cada operação é registrada (sucesso/falha)
- Valores antigos do registro são salvos
- Mostra detalhes dos erros

---

## 🎯 FLUXO RECOMENDADO

### Para PRIMEIRO USO:
```
1. Abrir Terminal como Admin
2. Rodar: project_low_v4.bat --dry-run
3. Analisar o que seria feito (sem medo)
4. Rodar: project_low_v4.bat (modo normal)
5. Selecionar opções com cuidado
6. Sempre fazer [1] PONTO DE RESTAURACAO primeiro
7. Depois outras otimizações conforme necessário
```

### Ordem recomendada de otimizações:
```
[1] Ponto de Restauração        ← SEMPRE PRIMEIRO
[5] Debloat (remover apps)      ← Remove peso
[2] Desativar Serviços          ← Libera RAM
[3] Visual (FPS)                ← Melhora performance
[4] Privacidade/GPO             ← Segurança
[8] Otimizar Rede               ← Velocidade
[10] Limpeza de Disco           ← Espaço
[Reiniciar PC]                  ← Aplica tudo
```

---

## 🆕 NOVAS OPÇÕES NO MENU

```
Menu Principal:

⭐ [h] Health Check        → Verifica saúde do sistema
⭐ [20] Gerar Relatório    → Cria resumo da sessão
⭐ [21] Ver Log            → Mostra últimas 50 linhas do log
[i] Informações/Sobre      → Dados do sistema + dicas
[0] Sair                   → Sai e gera relatório automático
```

---

## 📊 EXEMPLO DE SAÍDA

### Health Check (ao iniciar)
```
[HEALTH CHECK] Analisando sistema...

[OK] Disco: 250.45 GB livres / 500 GB (50% usado)
[OK] RAM: 12000 MB livres / 16000 MB
[OK] Privilégios: Administrador (True)
[OK] Windows: 22H2 (Build 22621)
[*] Modo: DRY-RUN (simulacao)
```

### Operação Normal
```
[1] PONTO DE RESTAURACAO
  ┣ Funcao: Backup seguro do estado atual do sistema
  ┣ Risco: BAIXO - Permite reverter todas as mudancas
  ┗ Compativel: Windows 10 Pro/Enterprise, Windows 11 Pro

  [1] Criar Novo Ponto
  [0] Voltar
  > Escolha: 1

[OK] Ponto criado com sucesso!
```

### Serviços (com Dry-Run)
```
[DRY-RUN] Simularia desativar:
  ✗ WSearch
  ✗ TapiSrv
  ✗ SysMain
  (sem fazer alterações reais)
```

### Relatório Final
```
=============== PROJECT-LOW - RELATORIO DE SESSAO ===============
Data/Hora: 02/06/2026 21:35:00
Usuario: Phoenix
Total: 8 | Sucesso: 8 | Falhas: 0 | Desativados: 5

[SUCCESS] Ponto de Restauracao
[DISABLED] Service: WSearch
[DISABLED] Service: TapiSrv
[SUCCESS] Visual Optimization
[DISABLED] Service: SysMain
...
```

---

## 🔍 ONDE ENCONTRAR LOGS E RELATÓRIOS

### Pasta de Logs
```
C:\Users\[SeuUsuario]\Desktop\LOW_Logs\
```

### Arquivo de Log (exemplo)
```
C:\Users\Phoenix\Desktop\LOW_Logs\LOW_2026-06-02_21-35.log
```

**Conteúdo:**
```
[2026-06-02 21:30:55] [START] SESSION STARTED
[2026-06-02 21:30:56] [CONFIG] DryRun: 0 | FastMode: 0
[2026-06-02 21:31:02] [SUCCESS] Restoration point created
[2026-06-02 21:31:45] [REG_CHANGE] REG: DragFullWindows = 1
[2026-06-02 21:31:50] [OPERATION] Operation: Visual - SUCCESS
[2026-06-02 21:32:00] [END] SESSION ENDED
```

### Relatório (exemplo)
```
C:\Users\Phoenix\Desktop\LOW_Report_20260602_213510.txt
```

---

## ⚠️ DICAS DE SEGURANÇA

### ✅ Sempre faça isso:
1. Criar ponto de restauração ([1]) antes de qualquer coisa
2. Usar `--dry-run` para testar primeiro
3. Ler os avisos de risco (BAIXO/MEDIA/ALTO)
4. Verificar o log após cada sessão

### ❌ Nunca faça isso:
1. Ignorar avisos de risco MEDIA/ALTO
2. Executar sem privilégios de Admin
3. Fazer todas as otimizações de uma vez (teste gradualmente)
4. Desligar o PC sem deixar completar

---

## 🐛 TROUBLESHOOTING

### "Permissão de Administrador recusada"
→ Clique direito no arquivo → "Executar como Administrador"

### "Permissão negada ao modificar registro"
→ O serviço pode estar em uso. Pode ser necessário reiniciar.

### "Health Check falhou"
→ Log contém detalhes. Verifique em `Desktop\LOW_Logs\`

### "Quero reverter uma mudança"
→ Use o ponto de restauração criado em [1]

---

## 📚 RECURSOS

| Arquivo | Localização | Para quê |
|---------|-------------|---------|
| **project_low_v4.bat** | Raiz do projeto | Executar o programa |
| **MELHORIAS_V4.md** | Raiz do projeto | Detalhes completos de mudanças |
| **GUIA_RAPIDO.md** | Raiz do projeto | Este arquivo |
| **Logs** | Desktop\LOW_Logs\ | Histórico de operações |
| **Relatórios** | Desktop\ | Sumário de sessões |

---

## 🚀 EXEMPLOS DE COMANDO

```cmd
REM Executar normal
project_low_v4.bat

REM Simular sem alterar
project_low_v4.bat --dry-run

REM Sem animações
project_low_v4.bat --fast

REM Simulação rápida (combinado)
project_low_v4.bat --dry-run --fast
```

---

## ❓ PERGUNTAS FREQUENTES

**P: Posso reverter as mudanças?**
R: Sim! Use o ponto de restauração criado em [1].

**P: O que é dry-run?**
R: Modo de simulação que mostra o que faria SEM alterar nada.

**P: Onde estão os logs?**
R: Desktop\LOW_Logs\ (automaticamente criado)

**P: É seguro usar?**
R: Sim, mas sempre faça um ponto de restauração primeiro!

**P: Quanto melhora a performance?**
R: Depende do hardware. Tipicamente 5-15% em jogos.

---

## 📞 SUPORTE

Se tiver dúvidas ou encontrar bugs:
- 📧 Email: lorenzocunha01@outlook.com
- 🔗 GitHub: oLorenZin/Project-LOW
- 💚 Apoie: PIX lorenzocunha01@outlook.com

---

**Desenvolvido com 💚 e ☕ por Lorenzo (Rattao)**
