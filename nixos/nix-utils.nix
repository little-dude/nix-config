{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    # Utilities
    pkgs.nurl
    pkgs.nix-tree
    pkgs.nix-output-monitor

    # Formatter
    pkgs.alejandra

    # Language servers
    pkgs.nil
    pkgs.nixd

    # Helpers for running foreign binaries on NixOS
    inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien
    # FHS environment https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs = pkgs:
            # pkgs.buildFHSEnv provides only a minimal FHS environment,
            # lacking many basic packages needed by most software.
            # Therefore, we need to add them manually.
            #
            # pkgs.appimageTools provides basic packages required by most software.
              (base.targetPkgs pkgs)
              ++ [
                pkgs.pkg-config
                pkgs.ncurses
                # Feel free to add more packages here if needed.
              ];
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = ["dev"];
          }
        )
    )
  ];
  # Optional, needed for `nix-alien-ld`
  programs.nix-ld.enable = true;
}
