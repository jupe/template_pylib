ifeq ($(OS),Windows_NT)
    PYTHON = python
    VENV_BIN = venv\Scripts
    RMRF = del /q /f 2>nul & rmdir /s /q
else
    PYTHON = python3
    VENV_BIN = venv/bin
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
	$(VENV_BIN)/pip install -e .[dev]
	@echo "Project installed."

run: install
	@echo "Running project..."
	$(VENV_BIN)/python -m project
	@echo "Project run."

test: install
	@echo "Running tests..."
	$(VENV_BIN)/python -m pytest --cov-config=.coveragerc
	@echo "Tests run."

lint: install
	echo "Running linter..."
	$(VENV_BIN)/python -m flake8 --config=.flake8
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
	$(VENV_BIN)/python setup.py sdist bdist_wheel
	$(VENV_BIN)/python -m twine upload dist/*
	@echo "Project released."
