{ inputs, config, pkgs, lib, system, ... }:
let pkgs_unstable = import inputs.nixpkgs_unstable { inherit system; };
in {

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

  # Create zellij config externally
  # as Nix to KDL converter is broken
  xdg.configFile."zellij/config.kdl" = {
    force = true;
    source = "${pkgs.internal.hrrs01-configs}/configs/zellij/config.kdl";
  };
  ## END OF YAZI CONFIG
}
