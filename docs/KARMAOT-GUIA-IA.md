# Karma OT — Guia para IA

> **Como usar:** no chat do Cursor, mencione este arquivo com `@KARMAOT-GUIA-IA.md` e cole um dos **prompts prontos** da seção correspondente (Site, Servidor ou Client).

---

## Visão geral do projeto

| Componente | Descrição | Pasta no VPS | Repositório GitHub |
|------------|-----------|--------------|-------------------|
| **Servidor TFS** | The Forgotten Server (C++ + Lua/XML) | `/home/nekiro/` | [vilelafred/karmaot](https://github.com/vilelafred/karmaot) |
| **Site AAC** | MyAAC (PHP) | `/var/www/html/` | [vilelafred/htmlkarmaot](https://github.com/vilelafred/htmlkarmaot) |
| **OTClient** | Cliente OTClientV8 (protocolo 772) | `/root/nekiro/otclient/` | [vilelafred/karmaotclient](https://github.com/vilelafred/karmaotclient) |

**VPS:** `72.62.11.29`  
**Site:** http://72.62.11.29:8088  
**Login do jogo:** porta `7171` (game `7172`)  
**MySQL:** banco `karma`, user `root` (senha em `config.lua` — **não versionado**)  
**Protocolo do client:** `772`  
**Conta GitHub / SSH:** `vilelafred` (chave `gofonen8nkarma`)

---

## Backup automático (Git)

- Script: `/root/scripts/karmaot-git-backup.sh`
- Cron: a cada **6 horas** (00:00, 06:00, 12:00, 18:00)
- Log: `/root/logs/karmaot-git-backup.log`
- Manual: ` /root/scripts/karmaot-git-backup.sh`

Só faz commit/push quando há arquivos alterados.

---

## Prompts prontos — copie e cole no chat

### Quando for alterar o **SITE** (AAC / PHP)

```
@KARMAOT-GUIA-IA.md

Quero alterar o SITE AAC do Karma OT.

Contexto:
- Pasta: /var/www/html/
- Repo: vilelafred/htmlkarmaot
- MyAAC + PHP, Nginx na porta 8088
- config.local.php é local (não commitar); usar config.local.php.dist como referência
- Não incluir vídeos, sessões PHP, cache, logs, downloads nem .exe/.zip

Tarefa: [DESCREVA AQUI O QUE QUER — ex: mudar página de highscores, corrigir login, adicionar plugin, etc.]

Regras:
- Responder em português
- Mudança mínima, sem quebrar o resto
- Não commitar config.local.php nem arquivos sensíveis
- Testar se possível após a alteração
```

---

### Quando for alterar o **SERVIDOR / DATA** (TFS)

```
@KARMAOT-GUIA-IA.md

Quero alterar o SERVIDOR TFS do Karma OT.

Contexto:
- Pasta: /home/nekiro/
- Repo: vilelafred/karmaot
- Código C++ em sources/src/ — recompilar após mudanças em .cpp/.h
- Build: /home/nekiro/build/ → binário ./tfs
- Data/scripts: data/ (XML, Lua, monsters, spells, actions, etc.)
- config.lua NÃO está no git (usar config.lua.dist)
- Protocolo OTClientV8: exp u64 em AddPlayerStats quando otclientV8
- Market: item 6879, premiumToCreateMarketOffer = false

Tarefa: [DESCREVA AQUI — ex: novo monster, spell, NPC, fix market, rebalance item, etc.]

Regras:
- Responder em português
- Se mudar C++: recompilar e reiniciar TFS
- Se mudar só Lua/XML: reload ou restart conforme necessário
- Não commitar config.lua, tfs, logs, dumps SQL, world.otbm
```

---

### Quando for alterar o **OTCLIENT**

```
@KARMAOT-GUIA-IA.md

Quero alterar o OTCLIENT do Karma OT.

Contexto:
- Pasta: /root/nekiro/otclient/
- Repo: vilelafred/karmaotclient
- OTClientV8, protocolo 772
- init.lua: SERVER_LIST host 72.62.11.29:7171, protocol 772
- Módulos em modules/ — game_features/features.lua define features do protocolo
- Servidor envia exp u64 (GameDoubleExperience) — client deve estar alinhado

Tarefa: [DESCREVA AQUI — ex: mudar UI, hotkey, módulo de market, layout, init.lua, etc.]

Regras:
- Responder em português
- Mudança mínima
- Não commitar .log
- Lembrar que alterações no protocolo precisam bater com o TFS
```

---

### Prompt genérico (qualquer área + várias)

```
@KARMAOT-GUIA-IA.md

Projeto Karma OT — VPS 72.62.11.29

Quero: [DESCREVA A TAREFA COMPLETA]

Áreas envolvidas (marque):
- [ ] Site (/var/www/html)
- [ ] Servidor TFS (/home/nekiro)
- [ ] OTClient (/root/nekiro/otclient)

Prioridade: [ex: corrigir bug / nova feature / balanceamento]

Regras: português, diff mínimo, respeitar .gitignore, não expor senhas.
```

---

## Mapa de pastas importantes

### Servidor `/home/nekiro/`

| Caminho | Conteúdo |
|---------|----------|
| `sources/src/` | Código C++ do TFS |
| `build/` | Compilação CMake (ignorado no git) |
| `data/actions/` | actions.xml, scripts de use |
| `data/creaturescripts/` | eventos de creatures |
| `data/globalevents/` | globalevents |
| `data/monster/` | monstros |
| `data/npc/` | NPCs |
| `data/spells/` | magias |
| `data/world/` | mapa (.otbm ignorado no git) |
| `config.lua` | Config principal (**local, não commitar**) |
| `config.lua.dist` | Template versionado |
| `tfs` | Binário do servidor (**não commitar**) |
| `start.sh` | Loop de start com GDB |

### Site `/var/www/html/`

| Caminho | Conteúdo |
|---------|----------|
| `system/` | Core MyAAC |
| `plugins/` | Plugins (gesior-shop, etc.) |
| `templates/` | Temas/layouts |
| `config.php` | Config base |
| `config.local.php` | Overrides locais (**não commitar**) |
| `images/` | Imagens do site |
| `outfits/` | Sprites de outfit |

### Client `/root/nekiro/otclient/`

| Caminho | Conteúdo |
|---------|----------|
| `init.lua` | Config, SERVER_LIST, protocolo |
| `modules/` | Módulos Lua/OTUI |
| `data/things/772/` | Tibia.dat / Tibia.spr |
| `otclient_dx.exe` / `otclient_gl.exe` | Binários Windows |

---

## O que NÃO commitar (já no .gitignore)

| Repo | Ignorados principais |
|------|---------------------|
| **karmaot** | `config.lua`, `tfs`, `build/`, `logs/`, `*.sql`, `world.otbm`, zips |
| **htmlkarmaot** | `config.local.php`, `system/php_sessions/`, vídeos, `downloads/`, `.exe`, `.zip` |
| **karmaotclient** | `*.log` |

---

## Comandos úteis

### Recompilar e reiniciar TFS (após mudança em C++)

```bash
cd /home/nekiro/build && cmake .. && make -j$(nproc)
cp /home/nekiro/build/tfs /home/nekiro/tfs
# matar processo tfs e subir de novo (start.sh ou manual)
```

### Reload Nginx (após mudança no site)

```bash
nginx -t && systemctl reload nginx
```

### Backup manual Git (os 3 repos)

```bash
/root/scripts/karmaot-git-backup.sh
```

### Testar SSH GitHub

```bash
ssh -T git@github.com
```

---

## Conta de teste no jogo

| Campo | Valor |
|-------|-------|
| Conta (número) | `3015458` |
| Senha | `test` |
| Personagem | `Teste` |
| Level | 100 |

> No protocolo 772 o login usa **número da conta**, não nome.

---

## Contexto técnico — fixes já aplicados (não reverter sem motivo)

1. **Exp u64 no protocolo:** `protocolgame.cpp` → `AddPlayerStats()` envia exp como u64 quando client é OTClientV8 (evita dessync opcode 89 / speed errada).
2. **Market:** action item `6879`, events descomentados, `premiumToCreateMarketOffer = false`, balance = money + bank.
3. **enterMarket:** usa depot da town se `lastDepotId == 0`.
4. **Site:** `config.local.php` aponta `server_path = /home/nekiro/`, client `740`.

---

## Checklist antes de pedir alteração à IA

- [ ] Sei qual área mexer: Site / Servidor / Client / mais de uma
- [ ] Descrevi o comportamento atual vs. o desejado
- [ ] Mencionei `@KARMAOT-GUIA-IA.md` no chat
- [ ] Se for C++: avisei que precisa recompilar
- [ ] Se for protocolo: avisei que TFS + client precisam alinhar

---

## Onde fica este arquivo

```
/root/nekiro/KARMAOT-GUIA-IA.md
```

Copie ou abra no Cursor e use `@KARMAOT-GUIA-IA.md` no início de cada conversa nova sobre o projeto.
