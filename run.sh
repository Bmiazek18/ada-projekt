#!/usr/bin/env bash
set -e

# Przejście do katalogu projektu
cd "$(dirname "$0")"

echo "🔨 Kompilacja projektu Ada..."
alr build

echo -e "\n🚀 Uruchamianie aplikacji...\n"
./bin/main "$@"
