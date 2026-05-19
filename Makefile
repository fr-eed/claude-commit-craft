SKILL_NAME    := commit-craft
INSTALL_DIR   := $(HOME)/.claude/skills/$(SKILL_NAME)
SKILL_DIR     := skill
DIALOG_SRC    := dialog
DIALOG_BINARY := $(DIALOG_SRC)/.build/release/CommitDialog
SKILL_FILE    := $(SKILL_DIR)/build/SKILL.md

.PHONY: help build build-skill test demo install uninstall dev clean

help:
	@echo ""
	@echo "  commit-craft: Claude Code skill for crafting clean git commits"
	@echo ""
	@echo "  make build       Build the SwiftUI dialog binary (release)"
	@echo "  make build-skill Compose _parts/ into build/SKILL.md"
	@echo "  make test        Build, then run Swift unit tests and CLI error-path tests"
	@echo "  make demo        Open the dialog with sample data so you can see it run"
	@echo "  make install     Build binary + skill, then copy to $(INSTALL_DIR)"
	@echo "  make uninstall   Remove $(INSTALL_DIR)"
	@echo "  make dev         Symlink skill files for live editing (still builds binary)"
	@echo "  make clean       Remove Swift build artifacts"
	@echo ""

build:
	@echo "==> Building CommitDialog (release)"
	@cd $(DIALOG_SRC) && swift build -c release
	@echo "    Built $(DIALOG_BINARY)"

build-skill:
	@echo "==> Composing $(SKILL_FILE) from $(SKILL_DIR)/_parts/"
	@bash $(SKILL_DIR)/build.sh

test: build
	@echo "==> Running Swift unit tests (CommitDialogCore)"
	@cd $(DIALOG_SRC) && swift test
	@echo ""
	@bash $(DIALOG_SRC)/test-cli.sh

demo: build
	@echo "==> Opening dialog with sample data. Click Commit All or Cancel."
	@cat $(DIALOG_SRC)/demo-plan.json | $(DIALOG_BINARY)

install: build build-skill
	@echo "==> Installing to $(INSTALL_DIR)"
	@rm -rf $(INSTALL_DIR)
	@mkdir -p $(INSTALL_DIR)/dialog
	@cp $(SKILL_FILE) $(INSTALL_DIR)/SKILL.md
	@cp $(DIALOG_BINARY) $(INSTALL_DIR)/dialog/CommitDialog
	@echo "    $(SKILL_FILE) -> $(INSTALL_DIR)/SKILL.md"
	@echo "    dialog/CommitDialog -> $(INSTALL_DIR)/dialog/CommitDialog"
	@echo ""
	@echo "Done."
	@echo "Invoke from any Claude Code session with /commit-craft or by asking to commit changes."

uninstall:
	@echo "==> Removing $(INSTALL_DIR)"
	@rm -rf $(INSTALL_DIR)
	@echo "Done."

dev: build build-skill
	@echo "==> Linking $(SRC_DIR)/ -> $(INSTALL_DIR) (dev mode)"
	@rm -rf $(INSTALL_DIR)
	@mkdir -p $(INSTALL_DIR)/dialog
	@ln -s $(CURDIR)/$(SKILL_FILE)   $(INSTALL_DIR)/SKILL.md
	@ln -s $(CURDIR)/$(DIALOG_BINARY) $(INSTALL_DIR)/dialog/CommitDialog
	@echo "    SKILL.md            (symlink)"
	@echo "    dialog/CommitDialog (symlink to release build)"
	@echo "Done."
	@echo "Rerun \`make build-skill\` after editing _parts/."
	@echo "Rerun \`make build\` after editing Swift."

clean:
	@echo "==> Cleaning build artifacts"
	@rm -rf $(DIALOG_SRC)/.build $(DIALOG_SRC)/.swiftpm $(SKILL_DIR)/build
	@echo "Done."
