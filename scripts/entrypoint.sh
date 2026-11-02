#!/usr/bin/env bash
# Entrypoint do contêiner: inicia o desktop VNC e mantém o processo vivo.
set -euo pipefail

# Gera a senha do VNC a partir de VNC_PW, se ainda não existir.
if [ -n "${VNC_PW:-}" ]; then
  mkdir -p "$HOME/.vnc"
  printf '%s\n%s\nn\n' "$VNC_PW" "$VNC_PW" | vncpasswd -f > "$HOME/.vnc/passwd"
  chmod 600 "$HOME/.vnc/passwd"
fi

/usr/local/bin/vnc-start.sh

echo
echo "🐉 Kali Linux sandbox pronta. Usuário: $(whoami)"
echo "   Use 'sudo' para tarefas administrativas."
echo

# Mantém o contêiner em execução acompanhando o log do websockify.
touch /tmp/websockify.log
tail -f /tmp/websockify.log
