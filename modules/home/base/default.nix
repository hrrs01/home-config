{ inputs, config, pkgs, lib, system, ... }:
let
  pkgs_unstable = import inputs.nixpkgs_unstable { inherit system; };
  helix-from-flake = inputs.helix-flake.packages.${system}.default;
  helix-with-plugins = helix-from-flake.overrideAttrs
    (prev: { cargoBuildFlags = "--features steel,git"; });
in {

  home.packages = with pkgs; [
    # REGULAR PROGRAMS, PACKAGES, AND TOOLS
    pkgs_unstable.lazygit
    pkgs_unstable.delta
    libxml2
    marksman
    markdown-oxide
    kdiff3
    simple-completion-language-server
    internal.hrrs01-configs
    cmake-language-server
    ruff
    python3Packages.python-lsp-server
    starship
    uv

    eza

    opcua-commander

    pkgs_unstable.urdf-viz
    pokeget-rs
    lemminx

    # AI
    helix-gpt
    lsp-ai
    aichat
    htop

    morph
    steel
    # Some nice to have shell scripts
    (pkgs.writeShellScriptBin "telemetry-compose" ''
      cd ~/telemetry-stack
      docker compose --file docker-compose.yml --project-directory . up --abort-on-container-exit --remove-orphans
    '')

  ];

  programs.git = {
    enable = true;
    userName = "hrrs01";
    userEmail = "haavard.nygaard@motiontech.no";
  };

  programs.nushell = { enable = true; };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;

  };

  programs.bash = {
    enable = true;
    sessionVariables = { EDITOR = "hx"; };
    bashrcExtra = ''
      alias lg="lazygit"
      alias ls="eza -l"
      alias lt="eza -lT"
    '';
  };

  ## START OF HELIX CONFIG
  programs.helix = {
    package = helix-with-plugins;
    enable = true;
    defaultEditor = true;
    extraPackages = [
      pkgs.steel
      pkgs.nixfmt
      pkgs.simple-completion-language-server
      pkgs.cmake-language-server
      pkgs.ruff
      pkgs.python3Packages.python-lsp-server
    ];
  };

  ## HELIX CONFIG - Copied (not symlinked) for easy iteration
  home.activation.copyHelixConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      run echo "Copying Helix configuration..."
      CONFIG_DIR="${config.home.homeDirectory}/.config/helix"
      SOURCE_DIR="${pkgs.internal.hrrs01-configs}/configs/helix"

      # Create helix config directory
      run mkdir -p "$CONFIG_DIR"

      # Remove existing files/symlinks before copying
      run rm -f "$CONFIG_DIR/config.toml"
      run rm -f "$CONFIG_DIR/init.scm"
      run rm -f "$CONFIG_DIR/helix.scm"
      run rm -f "$CONFIG_DIR/languages.toml"

      # Copy files (will overwrite existing files)
      run cp -f "$SOURCE_DIR/config.toml" "$CONFIG_DIR/config.toml"
      run cp -f "$SOURCE_DIR/init.scm" "$CONFIG_DIR/init.scm"
      run cp -f "$SOURCE_DIR/helix.scm" "$CONFIG_DIR/helix.scm"
      run cp -f "$SOURCE_DIR/languages.toml" "$CONFIG_DIR/languages.toml"

      # Make copied files writable (they inherit read-only permissions from Nix store)
      run chmod +w "$CONFIG_DIR/config.toml"
      run chmod +w "$CONFIG_DIR/init.scm"
      run chmod +w "$CONFIG_DIR/helix.scm"
      run chmod +w "$CONFIG_DIR/languages.toml"

      # Copy directories recursively (remove and recreate)
      # Make files writable before removing to avoid permission errors
      [ -d "$CONFIG_DIR/snippets" ] && run chmod -R +w "$CONFIG_DIR/snippets" || true
      [ -d "$CONFIG_DIR/themes" ] && run chmod -R +w "$CONFIG_DIR/themes" || true
      run rm -rf "$CONFIG_DIR/snippets"
      run rm -rf "$CONFIG_DIR/themes"
      run cp -rf "$SOURCE_DIR/snippets" "$CONFIG_DIR/"
      run cp -rf "$SOURCE_DIR/themes" "$CONFIG_DIR/"

      # Make copied directories and their contents writable
      run chmod -R +w "$CONFIG_DIR/snippets"
      run chmod -R +w "$CONFIG_DIR/themes"
    '';
  ## END OF HELIX CONFIG

  ## Start of global clangd config
  ## NOTE: Clangd is not installed by the system
  ## but rather a specific version for each environment
  ## It should however respect this
  home.activation.copyClangdConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      run echo "Copying clangd configuration..."
      CONFIG_DIR="${config.home.homeDirectory}/.config/clangd"
      SOURCE_FILE="${pkgs.internal.hrrs01-configs}/configs/clangd/config.yaml"

      run mkdir -p "$CONFIG_DIR"
      run rm -f "$CONFIG_DIR/config.yaml"
      run cp -f "$SOURCE_FILE" "$CONFIG_DIR/config.yaml"
      run chmod +w "$CONFIG_DIR/config.yaml"
    '';

  ## START OF YAZI CONFIG
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      manager = { ratio = [ 0 1 0 ]; };
      opener = {
        helix = [{
          run = ''hx "$@"'';
          desc = "Use yazi as a file picker within helix";
        }];
      };
      open = {
        rules = [{
          name = "**/*";
          use = "helix";
        }];
      };
    };
  };
  ## END OF YAZI CONFIG

  ## START OF YAZI CONFIG
  programs.zellij = {
    enable = false;
    enableBashIntegration = false;
  };

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
  };
  home.activation.copyLazygitConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      run echo "Copying lazygit configuration..."
      CONFIG_DIR="${config.home.homeDirectory}/.config/lazygit"
      SOURCE_FILE="${pkgs.internal.hrrs01-configs}/configs/lazygit/config.yml"

      run mkdir -p "$CONFIG_DIR"
      run rm -f "$CONFIG_DIR/config.yml"
      run cp -f "$SOURCE_FILE" "$CONFIG_DIR/config.yml"
      run chmod +w "$CONFIG_DIR/config.yml"
    '';

  # Create zellij config externally (copied for easy iteration)
  # as Nix to KDL converter is broken
  home.activation.copyZellijConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      run echo "Copying Zellij configuration..."
      CONFIG_DIR="${config.home.homeDirectory}/.config/zellij"
      SOURCE_FILE="${pkgs.internal.hrrs01-configs}/configs/zellij/config.kdl"

      run mkdir -p "$CONFIG_DIR"
      run rm -f "$CONFIG_DIR/config.kdl"
      run cp -f "$SOURCE_FILE" "$CONFIG_DIR/config.kdl"
      run chmod +w "$CONFIG_DIR/config.kdl"
    '';
  ## END OF ZELLIJ CONFIG
}
