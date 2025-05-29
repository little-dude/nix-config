{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nix-tree
    pkgs.nix-output-monitor
    # nix-alien makes it possible to run foreign binaries
    # https://github.com/thiagokokada/nix-alien
    inputs.nix-alien.packages.${pkgs.system}.nix-alien
    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    # See: https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs";
          targetPkgs =
            pkgs:
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
          extraOutputsToInstall = [ "dev" ];
        }
      )
    )
  ];
  # Optional, needed for `nix-alien-ld`
  programs.nix-ld.enable = true;
}
