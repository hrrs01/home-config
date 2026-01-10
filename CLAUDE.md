# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS home-manager configuration repository using Snowfall Lib for structure. It manages user environment configuration for hrrs01, including Helix editor with Steel scripting support, shell configuration, and various development tools.

## Repository Structure

The repository follows Snowfall Lib conventions:

- `flake.nix` - Main flake entry point that delegates to Snowfall Lib
- `homes/` - Home-manager configurations organized by architecture and user
  - `homes/x86_64-linux/hrrs01/default.nix` - User-specific home configuration
- `modules/` - Reusable home-manager modules
  - `modules/home/base/default.nix` - Base module with core packages and program configurations
- `packages/` - Custom Nix packages
  - `packages/hrrs01-configs/` - Package containing configuration files for Helix, clangd, and Zellij

## Key Architecture Patterns

### Configuration Management Pattern

Configuration files (Helix, clangd, Zellij) are packaged in `packages/hrrs01-configs/` and then symlinked into the appropriate XDG config locations via `xdg.configFile` in the home module. This ensures configurations are managed as immutable Nix derivations.

Example flow:
1. Source config lives in `packages/hrrs01-configs/configs/helix/config.toml`
2. Build phase copies to `$out/configs/helix/config.toml`
3. Home module references via `${pkgs.internal.hrrs01-configs}/configs/helix/config.toml`
4. `xdg.configFile` creates symlink in `~/.config/helix/config.toml`

### Helix Editor Customization

The repository uses a custom Helix build from a fork that includes Steel scripting support:
- Source: `inputs.helix-flake` from github:mattwparas/helix (steel-event-system branch)
- Build flags: `--features steel,git` (modules/home/base/default.nix:6)
- Steel integration files: `init.scm` and `helix.scm` in helix config

### Multiple Nixpkgs Versions

The flake uses three nixpkgs inputs:
- `nixpkgs` (25.05) - Main stable packages
- `nixpkgs_unstable` - For bleeding-edge packages (e.g., urdf-viz)
- `nixpkgs-25-11` - Alternative stable version

Access unstable packages via `pkgs_unstable` binding in modules/home/base/default.nix:3.

## Common Commands

### Building the Configuration

```bash
# Build the home configuration
nix build .#homeConfigurations.x86_64-linux.hrrs01.activationPackage

# Build the hrrs01-configs package
nix build .#hrrs01-configs
```

### Applying the Configuration

```bash
# Activate the home-manager configuration
home-manager switch --flake .#hrrs01@x86_64-linux
```

### Updating Dependencies

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input helix-flake
```

### Development and Testing

```bash
# Check flake outputs
nix flake show

# Check for errors without building
nix flake check

# Build specific package
nix build .#packages.x86_64-linux.hrrs01-configs

# Enter development shell (if defined)
nix develop
```

## Adding New Packages

To add a new package to the user environment:
1. Add to `home.packages` list in `modules/home/base/default.nix`
2. Rebuild and switch

## Adding New Program Configurations

To add configuration for a new program:
1. Add config files to `packages/hrrs01-configs/configs/<program>/`
2. Update `buildPhase` in `packages/hrrs01-configs/default.nix` to copy files
3. Add `xdg.configFile` entry in `modules/home/base/default.nix`
4. Set `force = true` to ensure regeneration on each rebuild

## Installed Tools

Key tools configured in this environment:
- **Editor**: Helix (with Steel scripting, custom from fork)
- **Shell**: Bash with Starship prompt, Nushell also available
- **Version Control**: Git, Lazygit
- **Terminal**: WezTerm
- **File Manager**: Yazi (integrated with Helix)
- **Language Servers**: marksman, markdown-oxide, cmake-language-server, ruff, python-lsp-server, simple-completion-language-server, lemminx
- **AI Tools**: helix-gpt, lsp-ai, aichat
- **File Listing**: eza (aliased to `ls` and `lt` for tree view)

## Special Configurations

### Bash Aliases
Defined in modules/home/base/default.nix:61-64:
- `lg` → lazygit
- `ls` → eza -l
- `lt` → eza -lT (tree view)

### Yazi Integration
Configured as file picker for Helix (modules/home/base/default.nix:126-145).

### Clangd
Global clangd config is managed but clangd itself should be installed per-environment, not system-wide (modules/home/base/default.nix:116-123).
