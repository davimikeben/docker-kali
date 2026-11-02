#!/usr/bin/env bash
# Sobe o Kali Linux Sandbox dentro de um GitHub Codespace.
# Normalmente você não precisa rodar isto: o devcontainer já sobe o desktop sozinho.
# Use este script para (re)iniciar o desktop manualmente.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -x scripts/vnc-start.sh ]; then
  echo "🚀 Iniciando o desktop Kali (noVNC + VNC)..."
  bash scripts/vnc-start.sh
else
  echo "❌ scripts/vnc-start.sh não encontrado. Rode este script na raiz do repositório."
  exit 1
fi

echo
echo "✅ Desktop iniciado! Próximos passos:"
echo "   1. Abra a aba PORTAS (Ports) no VS Code e clique no 🌐 da porta 6080"
echo "      ou abra a URL do noVNC em http://localhost:6080/vnc.html"
echo "   2. Senha do VNC: a definida em VNC_PW — padrão: kali"
echo "   3. VNC nativo (opcional): encaminhe a porta 5901 e conecte com um cliente VNC"
