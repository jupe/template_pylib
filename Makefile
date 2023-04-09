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
	@echo "Checking for project installation..."
	@venv/bin/pip install -e .[dev] --upgrade --no-deps || make _install

_install:
	@echo "Installing project..."
	@venv/bin/pip install -e .[dev]
	@echo "Project installed."

run: install
	@echo "Running project..."
	@venv/bin/python -m project
	@echo "Project run."

test: install
	@echo "Running tests..."
	@venv/bin/python -m pytest --cov=project --cov-report=term-missing \
			--cov-report=xml --cov-fail-under=100 --xml=coverage.xml --junitxml=report.xml \
			--color=yes --durations=0 --verbose tests --no-cov-on-fail \
			--cov-config=.coveragerc
	@echo "Tests run."

lint: install
	@echo "Running linter..."
    #@venv/bin/python -m flake8 src --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
	@echo "Linter run."
clean:
	@echo "Cleaning project..."
	@rm -rf venv
	@echo "Project cleaned."

venv: requirements-dev.txt Makefile venv
	@make create-venv

# create venv unless it already exists
create-venv:
	@echo "Checking for virtual environment..."
	@test -d venv || make _create-venv

_create-venv:
	@echo "Creating virtual environment..."
	@python3 -m venv venv
	@echo "Virtual environment created."
