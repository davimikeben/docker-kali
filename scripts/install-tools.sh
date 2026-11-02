#!/usr/bin/env bash
# Instala ferramentas Kali adicionais em um contêiner já em execução.
# Exemplos:
#   ./scripts/install-tools.sh nmap metasploit-framework
#   ./scripts/install-tools.sh kali-linux-headless
set -euo pipefail
cd "$(dirname "$0")/.."

if [ "$#" -eq 0 ]; then
  echo "Uso: $0 <pacote> [pacote...]"
  echo "Ex.:  $0 nmap wireshark"
  echo "     $0 kali-linux-headless"
  exit 1
fi

CONTAINER="${CONTAINER:-kali}"
command -v docker >/dev/null 2>&1 || { echo "❌ Docker não encontrado."; exit 1; }

echo "📦 Instalando: $*"
docker exec -u root "$CONTAINER" bash -lc "apt-get update && apt-get install -y --no-install-recommends $*"
echo "✅ Concluído."
