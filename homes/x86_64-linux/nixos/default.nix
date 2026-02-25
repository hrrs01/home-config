{ inputs, config, pkgs, lib, system, ... }: {

  home.username = lib.mkDefault "nixos";
  home.stateVersion = lib.mkDefault "25.05";
  home.homeDirectory = lib.mkDefault "/home/nixos";
}
