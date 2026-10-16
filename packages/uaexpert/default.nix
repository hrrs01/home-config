{
  lib,
  appimageTools,
  runCommandLocal,
}:
let
  pname = "uaexpert";
  version = "2.0.2";

  # Unified Automation ships the client as an AppImage bundled inside a tarball,
  # which is committed to this repo.
  src = runCommandLocal "UaExpert-${version}.AppImage" { } ''
    tar xzf ${../../UaExpert-2.0.2-x86_64-linux.tar.gz} --warning=no-unknown-keyword
    cp UaExpert-${version}-x86_64.AppImage $out
  '';

  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${contents}/uaexpert.desktop -t $out/share/applications
    install -Dm444 ${contents}/uaexpert.png -t $out/share/pixmaps
  '';

  meta = {
    description = "UaExpert - OPC UA reference test client from Unified Automation";
    homepage = "https://www.unified-automation.com/products/development-tools/uaexpert.html";
    license = lib.licenses.unfree;
    mainProgram = "uaexpert";
    platforms = [ "x86_64-linux" ];
  };
}
