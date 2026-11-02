#!/usr/bin/env bash
# Sobe o Kali Linux Sandbox localmente (usa compose.yml da raiz).
set -euo pipefail
cd "$(dirname "$0")/.."

command -v docker >/dev/null 2>&1 || { echo "❌ Docker não encontrado."; exit 1; }

if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "📝 .env criado a partir do .env.example (ajuste e rode de novo se quiser)."
fi

echo "🚀 Construindo e subindo o Kali Linux Sandbox..."
echo "   (a primeira vez pode levar de 5 a 20 minutos, dependendo do KALI_TOOLS)"
docker compose up -d --build

# shellcheck disable=SC1091
NOVNC_PORT="$(grep -E '^NOVNC_PORT=' .env 2>/dev/null | cut -d= -f2 || true)"
NOVNC_PORT="${NOVNC_PORT:-6080}"

echo
echo "✅ Container iniciado! Próximos passos:"
echo "   1. Abra http://localhost:${NOVNC_PORT}/vnc.html no navegador"
echo "   2. Senha do VNC: a definida em VNC_PW (.env) — padrão: kali"
echo "   3. Terminal: docker exec -it kali bash"
echo "   Logs: docker compose logs -f kali"
