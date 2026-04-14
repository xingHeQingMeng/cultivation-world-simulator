@echo off
setlocal enabledelayedexpansion

set "ROOT_DIR=%~dp0"
cd /d "%ROOT_DIR%"

REM 自动准备 Python 虚拟环境与后端依赖
if not exist ".venv\Scripts\python.exe" (
  py -3 -m venv .venv
)

if not exist ".venv\.deps_ready" goto install_py_deps
goto py_deps_done

:install_py_deps
.venv\Scripts\python.exe -m pip install -r requirements.txt
type nul > ".venv\.deps_ready"

:py_deps_done
REM 自动准备前端依赖（--dev 模式会拉起 Vite）
if not exist "web\node_modules" (
  pushd web
  call npm install
  popd
)

call .venv\Scripts\python.exe src\server\main.py --dev
