# ❓ Perguntas frequentes (FAQ)

## O que é este repositório?

É uma **sandbox Kali Linux** pronta para uso, com desktop acessível pelo navegador,
que roda tanto no **GitHub Codespaces** quanto **localmente** com Docker.

## É legal usar as ferramentas do Kali?

As ferramentas em si são de código aberto e legais. O que pode ser ilegal é o **uso**:
escanear, explorar ou acessar sistemas **sem autorização** é crime na maioria dos
países (no Brasil, veja a Lei nº 12.737/2012 — "Lei Carolina Dieckmann" — e a
LGPD). Use apenas em **laboratórios próprios**, ambientes de estudo (HTB, TryHackMe,
VulnHub) ou alvos com **autorização por escrito**.

## Quanto custa rodar no Codespaces?

Contas pessoais têm uma **cota gratuita mensal** de Codespaces (veja em
*Settings → Billing*). A imagem com `kali-tools-top10` ocupa vários GB de disco e
consome horas de máquina. **Pare o Codespace quando não estiver usando**
(*Codespaces: Stop Current Codespace*). Localmente com Docker, é grátis.

## Quanto tempo leva para construir a imagem?

Depende do `KALI_TOOLS`:

- `kali-tools-top10` (padrão): ~5–15 min
- `kali-linux-headless`: ~10–20 min
- `kali-linux-large`: ~20–40 min
- *(vazio)*: ~3–6 min

Nas próximas vezes, o Docker reaproveita o cache de camadas e fica bem mais rápido.

## Por que a imagem é tão grande?

O Kali com o desktop Xfce e as ferramentas Top 10 fica na casa de **8–12 GB**.
Reduza usando `KALI_TOOLS=` (vazio) ou instalando só o que precisa via
`./scripts/install-tools.sh`.

## Qual usuário e senha?

Usuário **`kali`** com **sudo sem senha**. A senha do VNC é **`kali`** por padrão
(altere em `VNC_PW`). Troque a senha antes de expor qualquer porta publicamente.

## Não consigo abrir o desktop no navegador. O que fazer?

1. Confirme que o contêiner está rodando: `docker compose ps` ou `docker ps`.
2. Veja os logs: `docker compose logs -f kali`.
3. No Codespaces, verifique se a porta **6080** foi encaminhada (aba *Ports*).
4. Reinicie o desktop: `./scripts/start-codespaces.sh` (Codespaces) ou
   `docker compose restart kali` (local).

## Posso rodar Docker dentro da sandbox?

No Codespaces, sim: o devcontainer habilita o recurso *docker-in-docker*.
Localmente, descomente `privileged: true` no `compose.yml` (use com cautela).

## Como apago tudo e começo do zero?

```bash
./scripts/reset.sh        # remove contêiner e volumes
docker image rm docker-kali:latest
```

## Como uso minhas próprias wordlists?

Coloque os arquivos na pasta **`shared/`**. Ela aparece como **`~/shared`** dentro
do sandbox. As wordlists do Kali já vêm em `/usr/share/wordlists/`.
