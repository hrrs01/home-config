{
  lib,
  stdenv,
  fetchzip,
  patchelf,
  glibc,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  bubblewrap,
  procps,
  socat,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "claude-code";
  version = "2.1.292";

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code-linux-x64/-/claude-code-linux-x64-${finalAttrs.version}.tgz";
    hash = "sha256-ftQUZjnDPASs0E27Ii5s0afEHkEfj7NLb7I72x46dIc=";
  };

  nativeBuildInputs = [
    patchelf
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;
  dontAutoPatchelf = true;
  dontStrip = true;
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 claude $out/lib/claude-code/claude
    # Only patch the interpreter. This is a bun single-file executable with a
    # payload trailer appended to the ELF; patchelf --set-rpath grows the file
    # and corrupts that trailer (segfault at startup), so libraries are supplied
    # via LD_LIBRARY_PATH in the wrapper instead.
    patchelf \
      --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 \
      $out/lib/claude-code/claude
    makeWrapper $out/lib/claude-code/claude $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
      --set DISABLE_INSTALLATION_CHECKS 1 \
      --prefix LD_LIBRARY_PATH : ${glibc}/lib \
      --unset DEV \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            procps
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            bubblewrap
            socat
          ]
        )
      }
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    mainProgram = "claude";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
})
