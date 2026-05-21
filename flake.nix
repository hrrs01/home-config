{
  description = "A nix flake containing hrrs01's home config";

  nixConfig = {
    extra-substituters = [
      "https://zed.cachix.org"
    ];
    extra-trusted-public-keys = [
      "zed.cachix.org-1:FJMBiFBoaRbJMJmJbcNLJJhEW/yl2kbcOuAObHOwxNY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    helix-flake.url = "github:mattwparas/helix?ref=steel-event-system";
    windows-config = {
      url = "git+ssh://git@github.com/hrrs01/windows-config.git";
      flake = false;
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    coding-agents = {
      url = "github:kissgyorgy/coding-agents";
    };
    zed-preview = {
      url = "github:zed-industries/zed?ref=v1.4.0-pre";
    };
  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
      };

    };

}
