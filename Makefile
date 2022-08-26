SHELL:=/bin/bash

install-dev: ## Install dev dependencies
	@echo installing python venv with python version 3.10
	@pipenv install --dev --python "3.10"

git-init: ## Init repo
	@echo "Initialize git repo"
	@git init
# git-hooks: ## Configure git repo
	@echo "Set-up local git config user name "Julien-Fruteau" and email "julien.fruteau@gmail.com""
	@git config --local user.name Julien-Fruteau
	@git config --local user.email julien.fruteau@gmail.com
	@echo "Commit README"
	@git add README.md
	@git commit -m "first commit"
	@echo "Switch from master to main branch"
	@git branch -M main
	@echo "Set-up remote git origin git@github.com:Julien-Fruteau/db-notebook.git"
	@git remote add origin git@github.com:Julien-Fruteau/db-notebook.git

git-add-safe-directory: ## Add workspace to git safe directory
	@echo "Configure safe directory"
	@git config --global --add safe.directory /workspaces/db-notebook

# run git config only when on opening dev container otherwise hooks will generate errors
git-hooks: ## Configure git hooks from .githooks folder
	@echo "Configure git pre-commit hooks with local .githooks folder"
	@git config core.hooksPath .githooks

git-post-init-commit: ## Git commit
	@echo "Make post init commit"
	@git add . && \
	 git commit -m "chore(setup): done"
	@echo "Local: Setup Complete"
	@echo "TODO : Create remote repo git@github.com:"Julien-Fruteau"/"db-notebook""

git-config: git-add-safe-directory git-hooks##add workspace to safe directory, and set up hooks

fmt: ## Format
	@pipenv run isort . && \
	 pipenv run black .

analysis: ## Run flake8 and typecheck analysis
	@pipenv run flake8 --exclude node_modules && \
	 pipenv run mypy

init: git-init git-post-init-commit##init-repo, and set up git 

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

objects:= @ls modules

.PHONY: all
