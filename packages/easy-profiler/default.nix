{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  libGL,
  zlib,
  glib,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "easy-profiler";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/yse/easy_profiler/releases/download/v${version}/easy_profiler-v${version}-linux-x64-libc-2.27.tar.gz";
    hash = "sha256-4ghJln6q9UjXaQhTxeGulktqpJD5RPsFtvkmNjsrGBE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libGL
    zlib
    glib
    qt5.qtbase
    qt5.qtwayland
  ];

  # Bundled ICU 56 is too old for nixpkgs; keep it for LD_LIBRARY_PATH.
  # Qt5 comes from nixpkgs (ABI-compatible across Qt5.x).
  autoPatchelfIgnoreMissingDeps = true;

  sourceRoot = ".";
  dontWrapQtApps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/easy-profiler $out/bin

    install -m755 bin/profiler_gui bin/profiler_converter $out/opt/easy-profiler/
    # Only keep bundled ICU 56 and easy_profiler; Qt5 is sourced from nixpkgs
    cp bin/libicu*.so* bin/libeasy_profiler.so $out/opt/easy-profiler/

    makeWrapper $out/opt/easy-profiler/profiler_gui $out/bin/profiler-gui \
      --set LD_LIBRARY_PATH "$out/opt/easy-profiler" \
      --set QT_QPA_PLATFORM "wayland" \
      --set QT_PLUGIN_PATH "${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins:${qt5.qtwayland.bin}/lib/qt-${qt5.qtwayland.version}/plugins"
    makeWrapper $out/opt/easy-profiler/profiler_converter $out/bin/profiler-converter \
      --set LD_LIBRARY_PATH "$out/opt/easy-profiler"

    runHook postInstall
  '';

  meta = {
    description = "Easy profiler GUI viewer for .prof capture files";
    homepage = "https://github.com/yse/easy_profiler";
    license = lib.licenses.mit;
    mainProgram = "profiler-gui";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
