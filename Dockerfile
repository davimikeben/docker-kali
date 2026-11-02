# syntax=docker/dockerfile:1
# =============================================================================
#  Kali Linux Sandbox
#  Imagem para GitHub Codespaces e uso local com Docker.
#
#  Base oficial: kalilinux/kali-rolling
#  Inclui: desktop Xfce + TigerVNC + noVNC (desktop no navegador),
#          Firefox ESR e um metapacote de ferramentas Kali configurável.
#
#  Uso rápido:
#    docker build -t docker-kali .
#    docker run --rm -it -p 6080:6080 -p 5901:5901 docker-kali
#    # abra http://localhost:6080/vnc.html
# =============================================================================
FROM kalilinux/kali-rolling

ARG DEBIAN_FRONTEND=noninteractive

# --- Parâmetros de build -----------------------------------------------------
# Metapacote de ferramentas Kali a instalar:
#   kali-tools-top10    -> padrão (~600 pacotes: nmap, metasploit, wireshark...)
#   kali-linux-headless -> conjunto headless completo
#   kali-linux-large    -> praticamente tudo (~2100 pacotes)
#   (vazio)             -> sem ferramentas extras: --build-arg KALI_TOOLS=
ARG KALI_TOOLS="kali-tools-top10"

# Usuário não-root criado na imagem (recebe sudo sem senha).
ARG USERNAME="kali"
ARG PASSWORD="kali"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ="America/Sao_Paulo" \
    LANG="C.UTF-8" \
    LANGUAGE="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    SHELL="/bin/bash" \
    DISPLAY=":1" \
    VNC_DISPLAY=":1" \
    VNC_PORT="5901" \
    NOVNC_PORT="6080" \
    VNC_GEOMETRY="1440x900" \
    VNC_DEPTH="24" \
    VNC_PW="kali" \
    KALI_USER="kali"

# --- 1. Sistema base, utilitários e Python ----------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl wget git sudo gnupg unzip zip xz-utils \
      locales tzdata procps psmisc \
      net-tools iproute2 iputils-ping dnsutils netcat-traditional \
      openssh-client \
      vim nano less tmux htop tree jq bash-completion \
      python3 python3-pip python3-venv pipx \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- 2. Desktop Xfce + VNC + noVNC + navegador ------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
      xfce4 xfce4-terminal xfce4-taskmanager dbus-x11 \
      x11-utils x11-xserver-utils xauth xdg-utils \
      fonts-dejavu fonts-liberation \
      tigervnc-standalone-server tigervnc-common tigervnc-tools \
      novnc websockify \
      firefox-esr \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- 3. Ferramentas Kali (metapacote configurável) --------------------------
RUN apt-get update \
 && if [ -n "${KALI_TOOLS}" ]; then apt-get install -y --no-install-recommends ${KALI_TOOLS}; fi \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- 4. Usuário não-root com sudo sem senha ---------------------------------
RUN useradd --create-home --shell /bin/bash --groups sudo "${USERNAME}" \
 && echo "${USERNAME}:${PASSWORD}" | chpasswd \
 && printf '%s ALL=(ALL) NOPASSWD:ALL\n' "${USERNAME}" > "/etc/sudoers.d/${USERNAME}" \
 && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
 && mkdir -p "/home/${USERNAME}/shared" \
 && chown -R "${USERNAME}:${USERNAME}" "/home/${USERNAME}"

# --- 5. Scripts de inicialização do desktop ---------------------------------
COPY scripts/vnc-start.sh scripts/entrypoint.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/vnc-start.sh /usr/local/bin/entrypoint.sh

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# noVNC (navegador) e VNC (cliente nativo)
EXPOSE 6080 5901

# Sobe o desktop e mantém o contêiner vivo.
CMD ["/usr/local/bin/entrypoint.sh"]
