{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  vulkan-loader,
  libGL,
  libxkbcommon,
  wayland,
  xorg,
  alsa-lib,
  nss,
  libdrm,
  mesa,
  gtk3,
  glib,
  dbus,
  fontconfig,
  freetype,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zed-preview";
  version = "1.4.0-pre";

  src = fetchurl {
    url = "https://github.com/zed-industries/zed/releases/download/v${finalAttrs.version}/zed-linux-x86_64.tar.gz";
    hash = "sha256-rCguWWFn8/MKo+ancxc7x0d8E8eQbBAf1ad0fQpUkUI=";
  };

  sourceRoot = "zed-preview.app";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    vulkan-loader
    libGL
    libxkbcommon
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    alsa-lib
    nss
    libdrm
    mesa
    gtk3
    glib
    dbus
    fontconfig
    freetype
    openssl
  ];

  runtimeDependencies = [
    vulkan-loader
    libGL
    wayland
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec $out/lib
    cp -r lib/* $out/lib/
    cp libexec/zed-editor $out/libexec/
    cp bin/zed $out/bin/zed

    mkdir -p $out/share
    cp -r share/* $out/share/

    runHook postInstall
  '';

  meta = {
    description = "Zed editor preview release";
    homepage = "https://zed.dev";
    license = lib.licenses.gpl3Only;
    mainProgram = "zed";
    platforms = [ "x86_64-linux" ];
  };
})
