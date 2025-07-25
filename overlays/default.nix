{ ... }:
final: prev: {
  navicat-premium = prev.callPackage ./navicat-premium.nix { };
  orchis-theme = prev.orchis-theme.overrideAttrs (oldAttrs: {
    installPhase = ''
      runHook preInstall

      bash install.sh -d $out/share/themes -t default green --tweaks solid macos compact black primary submenu nord

      runHook postInstall
    '';
  });
  nautilus = prev.nautilus.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      sed -i '/static void\s*action_send_email/,/^\}/d' src/nautilus-files-view.c
      sed -i '/\.name = "send-email"/d' src/nautilus-files-view.c
      sed -i '/action = g_action_map_lookup_action.*(view_action_group, "send-email");/,/^\s*}$/d' src/nautilus-files-view.c
    '';
  });
  rfv = prev.writeShellScriptBin "rfv" (
    builtins.readFile (
      prev.replaceVars ./rfv {
        rg = "${prev.ripgrep}/bin/rg";
        fzf = "${prev.fzf}/bin/fzf";
        hx = "${prev.helix}/bin/hx";
        bat = "${prev.bat}/bin/bat";
      }
    )
  );
  fhs = (
    prev.buildFHSEnv (
      prev.appimageTools.defaultFhsEnvArgs
      // {
        name = "fhs";
        targetPkgs =
          pkgs:
          (prev.appimageTools.defaultFhsEnvArgs.targetPkgs pkgs)
          ++ (with pkgs; [
            libsoup_3
            # nodejs
            # yarn-berry
            # yarn-berry.yarn-berry-fetcher
            # pkg-config
            # webkitgtk_4_1
            # libsoup_3
            # gtk3
            # webkitgtk_4_0
          ]);
        runScript = "fish -i -l";
        extraOutputsToInstall = [ "dev" ];
      }
    )
  );
  vscodium-with-extensions = prev.vscode-with-extensions.override {
    vscode = prev.vscodium;
    vscodeExtensions = with prev.vscode-extensions; [
      tsyesika.guile-scheme-enhanced
      release-candidate.vscode-scheme-repl
      ufo5260987423.magic-scheme
    ];
  };
}
