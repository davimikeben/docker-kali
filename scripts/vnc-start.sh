#!/usr/bin/env bash
# Sobe o desktop Xfce no VNC e o noVNC (acesso pelo navegador).
# Pode ser chamado de dentro do contêiner quantas vezes for necessário:
# se os servidores já estiverem rodando, a chamada não faz nada.
set -euo pipefail

DISPLAY_NUM="${VNC_DISPLAY:-:1}"
SCREEN_NUM="${DISPLAY_NUM#:}"
GEOMETRY="${VNC_GEOMETRY:-1440x900}"
DEPTH="${VNC_DEPTH:-24}"
VNC_PORT="${VNC_PORT:-5901}"
NOVNC_PORT="${NOVNC_PORT:-6080}"
VNC_PW="${VNC_PW:-kali}"

# Se já estiver rodando, não sobe de novo.
if pgrep -f "Xvnc ${DISPLAY_NUM}" >/dev/null 2>&1; then
  echo "ℹ️  VNC já está rodando em ${DISPLAY_NUM}."
  exit 0
fi

# --- Senha do VNC -----------------------------------------------------------
mkdir -p "$HOME/.vnc"
if [ ! -s "$HOME/.vnc/passwd" ]; then
  printf '%s\n%s\nn\n' "$VNC_PW" "$VNC_PW" | vncpasswd -f > "$HOME/.vnc/passwd"
  chmod 600 "$HOME/.vnc/passwd"
fi

# --- Script de sessão do Xfce ----------------------------------------------
cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session startxfce4
EOF
chmod +x "$HOME/.vnc/xstartup"

# --- Inicia o servidor VNC --------------------------------------------------
vncserver "$DISPLAY_NUM" \
  -geometry "$GEOMETRY" \
  -depth "$DEPTH" \
  -rfbport "$VNC_PORT" \
  -localhost no \
  -SecurityTypes VncAuth

# --- Inicia o noVNC (proxy WebSocket -> VNC) --------------------------------
if ! pgrep -f "websockify.*${NOVNC_PORT}" >/dev/null 2>&1; then
  websockify --web=/usr/share/novnc "${NOVNC_PORT}" "localhost:${VNC_PORT}" \
    >/tmp/websockify.log 2>&1 &
  sleep 1
fi

echo "✅ Desktop pronto."
echo "   🌐 noVNC : http://localhost:${NOVNC_PORT}/vnc.html  (senha: ${VNC_PW})"
echo "   🖥️  VNC   : localhost:${VNC_PORT}                    (senha: ${VNC_PW})"
