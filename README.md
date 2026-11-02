# 🐉 docker-kali — Kali Linux Sandbox para GitHub Codespaces

Sandbox **Kali Linux** pronta para uso, baseada na imagem oficial
[`kalilinux/kali-rolling`](https://hub.docker.com/r/kalilinux/kali-rolling),
com **desktop Xfce acessível pelo navegador** (noVNC) e um conjunto de
ferramentas Kali configurável.

Funciona em:

- ☁️ **GitHub Codespaces** — o devcontainer constrói a imagem e sobe o desktop automaticamente;
- 💻 **Docker local** — via `compose.yml` (Linux, macOS e Windows com WSL2).

> ⚠️ **Uso responsável.** Use este sandbox apenas em sistemas e redes que você
> **possui** ou para os quais tem **autorização por escrito**. Testes de
> segurança sem autorização são ilegais na maioria das jurisdições.

---

## 🚀 Início rápido

### GitHub Codespaces

1. Clique em **Code → Codespaces → Create codespace on main**.
2. Aguarde a construção da imagem (primeira vez: ~5–20 min, conforme `KALI_TOOLS`).
3. O desktop sobe sozinho. Abra a aba **Ports (Portas)** e clique no 🌐 da porta **6080**,
   ou acesse `http://localhost:6080/vnc.html`.
4. Senha do VNC: **`kali`** (altere em `.devcontainer/devcontainer.json` → `VNC_PW`).

### Docker local

```bash
git clone https://github.com/davimikeben/docker-kali.git
cd docker-kali
cp .env.example .env
docker compose up -d --build
```

Depois abra **http://localhost:6080/vnc.html** (senha: `kali`).

Ou, sem compose:

```bash
docker build -t docker-kali .
docker run --rm -it -p 6080:6080 -p 5901:5901 docker-kali
```

---

## 🖥️ Acesso ao desktop

| Recurso | Endereço | Observação |
| --- | --- | --- |
| **noVNC** (navegador) | `http://localhost:6080/vnc.html` | Não precisa instalar nada |
| **VNC nativo** | `localhost:5901` | Use TigerVNC, RealVNC, etc. |
| **Terminal** | `docker exec -it kali bash` | Acesso por linha de comando |

No Codespaces, encaminhe as portas **6080** e **5901** pela aba **Ports**.
Para o VNC nativo, deixe a porta **pública** e conecte-se ao host encaminhado.

---

## 🧰 Ferramentas instaladas

O conjunto de ferramentas é escolhido no build pelo argumento `KALI_TOOLS`:

| `KALI_TOOLS` | Conteúdo | Tamanho aproximado |
| --- | --- | --- |
| `kali-tools-top10` **(padrão)** | nmap, metasploit, wireshark, burp, john, hashcat, aircrack-ng, hydra… | ~600 pacotes |
| `kali-linux-headless` | Conjunto headless completo | ~1300 pacotes |
| `kali-linux-large` | Praticamente todas as ferramentas | ~2100 pacotes |
| *(vazio)* | Sem ferramentas extras — imagem leve | base + desktop |

Escolha no build:

```bash
docker build --build-arg KALI_TOOLS=kali-linux-headless -t docker-kali .
```

Ou no `.devcontainer/devcontainer.json` (campo `build.args.KALI_TOOLS`).

### Instalar mais ferramentas depois

```bash
./scripts/install-tools.sh nmap wireshark
./scripts/install-tools.sh kali-linux-headless
```

Dentro do contêiner:

```bash
sudo apt update && sudo apt install -y nmap
```

---

## 📁 Estrutura do repositório

```
docker-kali/
├── .devcontainer/
│   └── devcontainer.json     # configuração do Codespaces / VS Code
├── .github/workflows/
│   └── main.yml              # CI: valida build da imagem e shell scripts
├── scripts/
│   ├── entrypoint.sh         # inicia o desktop e mantém o contêiner vivo
│   ├── vnc-start.sh          # sobe Xfce + VNC + noVNC
│   ├── start-local.sh        # atalho para subir com Docker local
│   ├── start-codespaces.sh   # (re)inicia o desktop no Codespace
│   ├── install-tools.sh      # instala ferramentas extras em execução
│   └── reset.sh              # remove contêiner e volumes
├── shared/                   # 📁 pasta compartilhada com o host (→ ~/shared)
├── Dockerfile
├── compose.yml
├── .env.example
└── README.md
```

---

## ⚙️ Configuração

Copie `.env.example` para `.env` e ajuste:

| Variável | Padrão | Descrição |
| --- | --- | --- |
| `KALI_TOOLS` | `kali-tools-top10` | Metapacote de ferramentas (build) |
| `USERNAME` | `kali` | Usuário não-root criado na imagem |
| `VNC_PW` | `kali` | Senha do VNC |
| `VNC_GEOMETRY` | `1440x900` | Resolução do desktop |
| `VNC_DEPTH` | `24` | Profundidade de cor |
| `VNC_PORT` | `5901` | Porta do servidor VNC |
| `NOVNC_PORT` | `6080` | Porta do noVNC (navegador) |
| `TZ` | `America/Sao_Paulo` | Fuso horário |

---

## ❓ Perguntas frequentes

Veja o [FAQ.md](FAQ.md).

---

## 🤝 Contribuições

Pull requests são bem-vindos. Descreva no PR qual cenário você está adicionando
(novas ferramentas, outro desktop, ajustes de rede, etc.).

## 📄 Licença

Distribuído sob a licença **MIT** — veja [LICENSE](LICENSE).
Este repositório **não distribui** o Kali Linux nem suas ferramentas; a imagem é
construída a partir dos repositórios oficiais da Offensive Security.
