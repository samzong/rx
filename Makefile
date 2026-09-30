CARGO := cargo
CARGO_BIN := $(or $(CARGO_HOME),$(HOME)/.cargo)/bin
ALIASES := rxc rxx rxo rxp rxd rxk

.PHONY: build release check audit fmt lint test install uninstall

build:
	$(CARGO) build --locked

release:
	$(CARGO) build --locked --release

check: audit fmt lint test

audit:
	$(CARGO) audit --file Cargo.lock

fmt:
	$(CARGO) fmt --all -- --check

lint:
	$(CARGO) clippy --locked --all-targets -- -D warnings

test:
	$(CARGO) test --locked

install:
	$(CARGO) install --path . --locked
	@for name in $(ALIASES); do ln -sfn rx "$(CARGO_BIN)/$$name"; done
	@if [ -d "$(HOME)/.zsh/completions" ]; then "$(CARGO_BIN)/rx" completions zsh > "$(HOME)/.zsh/completions/_rx"; fi

uninstall:
	$(CARGO) uninstall rx
	@for name in $(ALIASES); do rm -f "$(CARGO_BIN)/$$name"; done
