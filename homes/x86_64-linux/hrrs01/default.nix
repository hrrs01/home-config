{ inputs, config, pkgs, lib, system, ... }:
let pkgs_unstable = import inputs.nixpkgs_unstable { inherit system; };
in {

  home.username = lib.mkDefault "hrrs01";
  home.stateVersion = lib.mkDefault "25.05";
  home.homeDirectory = lib.mkDefault "/home/hrrs01";

  home.packages = with pkgs; [
    # REGULAR PROGRAMS, PACKAGES, AND TOOLS
    lazygit
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

    pokeget-rs
    lemminx

    # AI
    helix-gpt
    lsp-ai
    aichat
    htop

    # ALIASES FOR AI
    (pkgs.writeShellScriptBin "ai" ''
      ${pkgs.aichat}/bin/aichat "$@"
    '')

    # PROFILE GLOBAL SCRIPTS
    (writeShellScriptBin "floating-claude" ''
      zellij run -c -f --width 80% --height 80% -x 10% -y 10% -- claude
    '')
    (writeShellScriptBin "pipe-to-helix" ''
      #!/bin/env bash
      zellij action toggle-floating-panes
      zellij action write 27 # send escape key
      for selected_file in "$@"
      do
        zellij action write-chars ":open $selected_file"
        zellij action write 13 # Send enter key
      done
      zellij action toggle-floating-panes
      zellij action close-pane
    '')
    (writeShellScriptBin "floating-yazi" ''
      #!/bin/env bash
      zellij run -c -f --width 80% --height 80% -x 10% -y 10% -- yazi "$PWD"
    '')
    (writeShellScriptBin "floating-lazygit" ''
      #!/bin/env bash
      zellij run -c -f --width 95% --height 95% -x 2% -y 2% -- lazygit
    '')
    (writeShellScriptBin "floating-terminal" ''
      #!/bin/env bash
      zellij run -c -f --width 80% --height 80% -x 10% -y 10% -- bash
    '')
    (writeShellScriptBin "floating-notes" ''
      #!/bin/env bash
      zellij run -c -f --width 80% --height 80% -x 10% -y 10% --cwd ~/my-notes -- hx .
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
  };

  ## START OF HELIX CONFIG
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      pkgs.nixfmt
      pkgs.simple-completion-language-server
      pkgs.cmake-language-server
      pkgs.ruff
      pkgs.python3Packages.python-lsp-server
    ];
  };

  xdg.configFile."helix/snippets" = {
    # Force it into the config folder for helix editor
    force = true; # Force its regeneration for every generation
    recursive = true;
    source = "${pkgs.internal.hrrs01-configs}/configs/helix/snippets";
  };

  xdg.configFile."helix/config.toml" = {
    force = true;
    source = "${pkgs.internal.hrrs01-configs}/configs/helix/config.toml";
  };

  xdg.configFile."helix/themes" = {
    force = true;
    recursive = true;
    source = "${pkgs.internal.hrrs01-configs}/configs/helix/themes";
  };

  xdg.configFile."helix/languages.toml" = {
    force = true;
    source = "${pkgs.internal.hrrs01-configs}/configs/helix/languages.toml";
  };
  ## END OF HELIX CONFIG

  ## Start of global clangd config
  ## NOTE: Clangd is not installed by the system
  ## but rather a specific version for each environment
  ## It should however respect this
  xdg.configFile."clangd/config.yaml" = {
    force = true;
    source = "${pkgs.internal.hrrs01-configs}/configs/clangd/config.yaml";
  };

  ## START OF YAZI CONFIG
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      opener = {
        helix = [{
          run = ''pipe-to-helix "$@"'';
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
    enable = true;
    enableBashIntegration = true;
  };

  # Create zellij config externally
  # as Nix to KDL converter is broken
  xdg.configFile."zellij/config.kdl" = {
    force = true;
    source = "${pkgs.internal.hrrs01-configs}/configs/zellij/config.kdl";
  };
  ## END OF YAZI CONFIG
}
