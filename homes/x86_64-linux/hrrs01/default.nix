{ inputs, config, pkgs, lib, system, ... }: {

  home.username = lib.mkDefault "hrrs01";
  home.stateVersion = lib.mkDefault "25.05";
  home.homeDirectory = lib.mkDefault "/home/hrrs01";

}
