{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
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

  # Bundled ICU 56 and Qt5 are too old to satisfy from nixpkgs; we keep them
  # and expose them via LD_LIBRARY_PATH in the wrapper instead.
  autoPatchelfIgnoreMissingDeps = true;

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/easy-profiler $out/bin

    install -m755 bin/profiler_gui bin/profiler_converter $out/opt/easy-profiler/
    cp bin/*.so* $out/opt/easy-profiler/
    cp -r bin/iconengines bin/imageformats $out/opt/easy-profiler/

    makeWrapper $out/opt/easy-profiler/profiler_gui $out/bin/profiler-gui \
      --set LD_LIBRARY_PATH "$out/opt/easy-profiler"
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
