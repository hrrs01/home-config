{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  patchelf,
  alsa-lib,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libGL,
  libdrm,
  libxkbcommon,
  mesa,
  nss,
  openssl,
  vulkan-loader,
  wayland,
  xorg,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zed-preview";
  version = "1.5.3-pre";

  src = fetchurl {
    url = "https://github.com/zed-industries/zed/releases/download/v${finalAttrs.version}/zed-linux-x86_64.tar.gz";
    hash = "sha256-bupvzFc1+5TYOJN4gec4sF2m9Z+K51dyRdry7aPUXB0=";
  };

  sourceRoot = "zed-preview.app";

  nativeBuildInputs = [
    autoPatchelfHook
    patchelf
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libxkbcommon
    mesa
    nss
    openssl
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
    zlib
  ];

  appendRunpaths = [
    (lib.makeLibraryPath [
      libGL
      vulkan-loader
      wayland
    ])
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec $out/share
    cp bin/zed $out/bin/zed-preview
    cp libexec/zed-editor $out/libexec/

    cp -r share/* $out/share/

    runHook postInstall
  '';

  meta = {
    description = "Zed editor preview release";
    homepage = "https://zed.dev";
    license = lib.licenses.gpl3Only;
    mainProgram = "zed-preview";
    platforms = [ "x86_64-linux" ];
  };
})
