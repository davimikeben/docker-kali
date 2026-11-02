# 📁 Pasta compartilhada

Arquivos colocados **nesta pasta (`shared/`)** aparecem dentro do Kali Linux em:

- 🏠 `~/shared`

Use para trocar arquivos entre o host (ou o Codespace) e o sandbox sem precisar de rede.

No Codespaces, esta pasta é montada automaticamente. Localmente (via `compose.yml`),
ela é montada como `~/shared` dentro do contêiner.

> Coloque wordlists, scripts, capturas ou relatórios aqui e acesse em `~/shared`.

Os arquivos desta pasta **não** são versionados (veja `.gitignore`), exceto este README.
