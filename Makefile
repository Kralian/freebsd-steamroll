.PHONY: sync collections inventory syntax-check check lint bundle

DATE := $(shell date +%Y%m%d-%H%M)
GIT_SHA := $(shell git rev-parse --short HEAD)
ENV_FILE ?= uv.env
PLAYBOOK ?= freebsd-release.yml
LIMIT ?= all
TAGS ?= all
BUNDLEPATH ?= ~/Downloads

sync:
	uv sync

collections:
	uv run ansible-galaxy collection install -r collections.yml -p collections

inventory:
	uv run ansible-inventory --graph

syntax-check:
	@for playbook in *.yml; do \
		case "$$playbook" in collections.yml) continue ;; esac; \
		uv run ansible-playbook --syntax-check "$$playbook" || exit 1; \
	done

check:
	uv run --env-file=$(ENV_FILE) ansible-playbook $(PLAYBOOK) \
		--limit $(LIMIT) --tags $(TAGS) --check --diff

lint:
	uv run ansible-lint

bundle:
	@status="$$(git status --porcelain)"; \
	if [ -n "$$status" ]; then \
		printf '%s\n' "$$status"; \
		printf '%s\n' "Refusing to create a bundle: commit or ignore the files above." >&2; \
		exit 1; \
	fi
	@echo "Working tree clean at $(GIT_SHA)"
	git bundle create $(BUNDLEPATH)/freebsd-steamroll-$(DATE)-$(GIT_SHA).bundle --all
