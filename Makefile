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
	@venv/bin/pip install -e .[dev]
	@echo "Project installed."

run: install
	@echo "Running project..."
	@venv/bin/python -m project
	@echo "Project run."

test: install
	@echo "Running tests..."
	@venv/bin/python -m pytest --cov-config=.coveragerc
	@echo "Tests run."

lint: install
	@echo "Running linter..."
    #@venv/bin/python -m flake8 src --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
	@echo "Linter run."
clean:
	@echo "Cleaning project..."
	@rm -rf venv
	@echo "Project cleaned."

venv: requirements-dev.txt Makefile
	@make create-venv

# create venv unless it already exists
create-venv:
	@echo "Checking for virtual environment..."
	@test -d venv || make _create-venv

_create-venv:
	@echo "Creating virtual environment..."
	@python3 -m venv venv
	@echo "Virtual environment created."
