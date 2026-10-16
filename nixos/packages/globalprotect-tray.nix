{
  lib,
  stdenvNoCC,
  makeWrapper,
  wrapGAppsHook3,
  gobject-introspection,
  python3,
  gtk3,
  libayatana-appindicator,
  libnotify,
  xdg-utils,
  src,
  gpoc,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.pyside6
    ps.pygobject3
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "globalprotect-tray";
  version = "0.2.0";

  inherit src;

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    gobject-introspection
    python3
  ];

  buildInputs = [
    pythonEnv
    gtk3
    libayatana-appindicator
    libnotify
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 "$src/globalprotect_tray.py" \
      "$out/libexec/globalprotect_tray.py"

    install -Dm755 "$src/globalprotect-tray-helper" \
      "$out/libexec/globalprotect-tray-helper"

    install -Dm644 "$src/globalprotect-tray.desktop" \
      "$out/share/applications/globalprotect-tray.desktop"

    install -Dm644 "$src/globalprotect-tray.svg" \
      "$out/share/icons/hicolor/scalable/apps/globalprotect-tray.svg"

    install -Dm644 \
      "$src/io.github.brycewalkerdev.globalprotect-tray-app.policy" \
      "$out/share/polkit-1/actions/io.github.brycewalkerdev.globalprotect-tray-app.policy"

    install -Dm644 \
      "$src/io.github.brycewalkerdev.globalprotect-tray-app.metainfo.xml" \
      "$out/share/metainfo/io.github.brycewalkerdev.globalprotect-tray-app.metainfo.xml"

    install -Dm644 "$src/LICENSE" \
      "$out/share/licenses/globalprotect-tray/LICENSE"

    # Use a Nix-provided Python interpreter for the privileged helper.
    patchShebangs "$out/libexec/globalprotect-tray-helper"

    # Patch paths in the GUI application.
    substituteInPlace "$out/libexec/globalprotect_tray.py" \
      --replace-fail "/usr/lib/globalprotect-tray/globalprotect-tray-helper" \
        "$out/libexec/globalprotect-tray-helper" \
      --replace-fail "/usr/bin/gpauth" \
        "${gpoc}/bin/gpauth" \
      --replace-fail "/usr/bin/gpclient" \
        "${gpoc}/bin/gpclient" \
      --replace-fail "/usr/bin/pkexec" \
        "/run/wrappers/bin/pkexec" \
      --replace-fail "/usr/bin/xdg-mime" \
        "${xdg-utils}/bin/xdg-mime" \
      --replace-fail "/usr/bin/notify-send" \
        "${libnotify}/bin/notify-send"

    # Patch the privileged helper's VPN client path.
    substituteInPlace "$out/libexec/globalprotect-tray-helper" \
      --replace-fail "/usr/bin/gpclient" \
        "${gpoc}/bin/gpclient"

    # Ensure Polkit authorizes the helper at its Nix store path.
    substituteInPlace \
      "$out/share/polkit-1/actions/io.github.brycewalkerdev.globalprotect-tray-app.policy" \
      --replace-fail "/usr/lib/globalprotect-tray/globalprotect-tray-helper" \
        "$out/libexec/globalprotect-tray-helper"

    # Point the desktop entry at the installed wrapper.
    substituteInPlace "$out/share/applications/globalprotect-tray.desktop" \
      --replace-fail "/usr/bin/globalprotect-tray" \
        "$out/bin/globalprotect-tray"

    mkdir -p "$out/bin"

    makeWrapper "${pythonEnv}/bin/python3" "$out/bin/globalprotect-tray" \
      --add-flags "$out/libexec/globalprotect_tray.py" \
      --prefix PATH : "${lib.makeBinPath [ gpoc xdg-utils libnotify ]}"

    runHook postInstall
  '';

  meta = {
    description = "External-browser tray client for GlobalProtect-compatible VPNs";
    homepage = "https://github.com/brycewalkerdev/globalprotect-tray-app";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
