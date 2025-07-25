{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  libGL,
  glib,
  glibc,
  pango,
  harfbuzz,
  fontconfig,
  libX11,
  freetype,
  e2fsprogs,
  expat,
  p11-kit,
  libxcb,
  libgpg-error,
  cjson,
  libxcrypt-legacy,
  curl,
  autoPatchelfHook,
  libxkbcommon,
  libselinux,
  libxcrypt,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "navicat-premium";
  version = "17.3.0";

  src = appimageTools.extractType2 {
    inherit (finalAttrs) pname version;
    src = fetchurl {
      url = "https://dn.navicat.com/download/navicat17-premium-cs-x86_64.AppImage";
      hash = "sha256-OpkhWy4lHZW6toSCZ7zaxVYaBi85jyUR95gYGLg3uG8=";
    };
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    glibc
    libgpg-error
    libxcrypt
    libxcrypt-legacy
    libselinux
    expat
    e2fsprogs
    libX11
    libxcb
    libxkbcommon
    libGL
    freetype
    fontconfig
    harfbuzz
    pango
    glib
    qt6.qtbase
    cjson
    curl
    p11-kit
  ];

  installPhase = ''
    runHook preInstall

    cp -r --no-preserve=mode usr $out
    chmod +x $out/bin/navicat
    mkdir -p $out/usr
    ln -s $out/lib $out/usr/lib

    runHook postInstall
  '';

  dontWrapQtApps = true;

  preFixup = ''
    rm $out/lib/libselinux.so.1
    ln -s ${libselinux.out}/lib/libselinux.so.1 $out/lib/libselinux.so.1
    rm $out/lib/glib/libglib-2.0.so.0
    ln -s ${glib.out}/lib/libglib-2.0.so.0 $out/lib/glib/libglib-2.0.so.0
    patchelf --replace-needed libcrypt.so.1 \
      ${libxcrypt}/lib/libcrypt.so.2 $out/lib/pq-g/libpq.so.5.5
    patchelf --replace-needed libcrypt.so.1 \
      ${libxcrypt}/lib/libcrypt.so.2 $out/lib/pq-g/libpq_ce.so.5.5
    patchelf --replace-needed libselinux.so.1 \
      ${libselinux.out}/lib/libselinux.so.1 $out/lib/pq-g/libpq.so.5.5
    wrapQtApp $out/bin/navicat \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          glib
          glibc
          pango
          harfbuzz
          fontconfig
          libX11
          freetype
          e2fsprogs
          expat
          p11-kit
          libxcb
          libgpg-error
          libxkbcommon
          libselinux
        ]
      }:$out/lib \
      --set QT_PLUGIN_PATH $out/plugins \
      --set QT_QPA_PLATFORM xcb \
      --set QT_STYLE_OVERRIDE Fusion \
      --chdir $out
  '';

  meta = {
    homepage = "https://www.navicat.com/products/navicat-premium";
    changelog = "https://www.navicat.com/products/navicat-premium-release-note";
    description = "Database development tool that allows you to simultaneously connect to many databases";
    mainProgram = "navicat";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
})
