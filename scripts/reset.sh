#!/usr/bin/env bash
# Para e remove o contêiner e os volumes do Kali Sandbox (uso local).
set -euo pipefail
cd "$(dirname "$0")/.."

echo "⚠️  Isto vai parar e remover o contêiner e o volume de dados do usuário."
read -r -p "Continuar? [s/N] " resp
case "${resp:-N}" in
  [sS]|[yY]) ;;
  *) echo "Cancelado."; exit 0 ;;
esac

docker compose down -v --remove-orphans
echo "✅ Contêiner e volumes removidos. A imagem 'docker-kali:latest' foi mantida."
echo "   Para remover a imagem também: docker image rm docker-kali:latest"
