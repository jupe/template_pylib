ifneq (,$(findstring cmd.exe,$(COMSPEC)))
    ifeq (,$(findstring bash,$(SHELL)))
        $(error This Makefile should be run in a Unix-like environment or using Git Bash on Windows)
    endif
endif

ifeq ($(OS),Windows_NT)
    VENV_BIN = venv/Scripts
    PYTHON = ${VENV_BIN}/python
    PIP = ${VENV_BIN}/pip
    RMRF = del /q /f 2>nul & rmdir /s /q
else
    VENV_BIN = venv/bin
    PYTHON = ${VENV_BIN}/python
    PIP = ${VENV_BIN}/pip
    RMRF = rm -rf
endif

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help: Show this help message."
	@echo "  create-venv: Create a virtual environment."
	@echo "  install: Install the project."
	@echo "  run: Run the project."
	@echo "  test: Run the tests."
	@echo "  clean: Clean the project."

# install project, but ignore if dependencies are already up to date
install: venv
	@echo "Installing project..."
	$(PIP) install -e .[dev]
	@echo "Project installed."

run: install
	@echo "Running project..."
	$(PYTHON) -m project
	@echo "Project run."

test: install
	@echo "Running tests..."
	$(PYTHON) -m pytest --cov-config=.coveragerc
	@echo "Tests run."

lint: install
	echo "Running linter..."
	$(PYTHON) -m flake8 --config=.flake8
	@echo "Linter run."

clean:
	@echo "Cleaning project..."
	$(RMRF)  venv
	@echo "Project cleaned."

venv: requirements-dev.txt Makefile
	@make create-venv

# create venv unless it already exists
create-venv:
	@echo "Checking for virtual environment..."
	@test -d venv || make _create-venv

_create-venv:
	@echo "Creating virtual environment..."
	python -m venv venv
	@echo "Virtual environment created."

release: install
	@echo "Releasing project.."
	$(PYTHON) setup.py sdist bdist_wheel
	$(PYTHON) -m twine upload dist/*
	@echo "Project released."
