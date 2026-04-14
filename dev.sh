#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# 自动准备 Python 虚拟环境与后端依赖
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi

if [ ! -f ".venv/.deps_ready" ] || [ "requirements.txt" -nt ".venv/.deps_ready" ] || [ "requirements-runtime.txt" -nt ".venv/.deps_ready" ]; then
  .venv/bin/python -m pip install -r requirements.txt
  touch .venv/.deps_ready
fi

# 自动准备前端依赖（--dev 模式会拉起 Vite）
if [ ! -d "web/node_modules" ]; then
  (cd web && npm install)
fi

exec .venv/bin/python src/server/main.py --dev
