{ stdenv, pkgs, lib, ... }:

stdenv.mkDerivation {
  pname = "hrrs01-configs";
  version = "1.0";

  src = ./.;

  buildPhase = ''
    mkdir -p $out/configs/
    mkdir -p $out/configs/helix/themes
    mkdir -p $out/configs/helix/snippets
    mkdir -p $out/configs/clangd
    mkdir -p $out/configs/zellij

    # Copy helix configs
    cp $src/configs/helix/config.toml $out/configs/helix/config.toml
    cp $src/configs/helix/languages.toml $out/configs/helix/languages.toml
    cp -r $src/configs/helix/themes/* $out/configs/helix/themes/
    cp -r $src/configs/helix/snippets/* $out/configs/helix/snippets/

    # Copy clangd configs
    cp $src/configs/clangd/config.yaml $out/configs/clangd/config.yaml

    # Copy zellij configs
    cp $src/configs/zellij/config.kdl $out/configs/zellij/config.kdl
  '';

  meta = with lib; {
    description = "A package with common configs used in motioncore";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
