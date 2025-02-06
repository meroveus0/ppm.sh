#!/bin/sh

BIN="./pyenv/bin/python3"
ENV="./pyenv"

set -e

case "$1" in
    "init")
        if [ ! -d "$ENV" ]; then
            echo "Creating virtual environment at $ENV"
            python3 -m venv "$ENV"
            echo "*" > "$ENV/.gitignore"
            if [ -f "packages.txt" ]; then
                $BIN -m pip install -r packages.txt
            else
                $BIN -m pip install pip-autoremove
                $BIN -m pip freeze > packages.txt
            fi
        else
            echo "Virtual environment already exists at $ENV"
        fi
        ;;
    "r"|"run")
        if [ -z "$2" ]; then
            echo "usage: $0 r|run <script_path>"
            exit 1
        fi
        shift
        $BIN "$@"
        ;;
    "i"|"install")
        shift
        $BIN -m pip install "$@"
        $BIN -m pip freeze > packages.txt
        ;;
    "uninstall"|"remove")
        if [ -z "$2" ]; then
            echo "usage: $0 uninstall|remove <package_name>"
            exit 1
        fi
        shift
        ./pyenv/bin/pip-autoremove "$@"
        $BIN -m pip freeze > packages.txt
        ;;
    "h"|"help")
        echo "usage: ./ppm.sh [OPTION]"
        echo "options:"
        echo "   init        		Initialize or create a new virtual environment"
        echo "   r, run      		Run a Python script in the virtual environment"
        echo "   i, install		Install Python packages in the virtual environment"
        echo "   uninstall, remove 	Uninstall Python packages from the virtual environment"
        echo "   h, help		View help menu"
        ;;
    *)
        echo "invalid options -- run './ppm.sh help' for option overview"
        exit 1
        ;;
esac
