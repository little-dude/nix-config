{ config, pkgs, lib, ... }: {
  # When using undocked, use offload mode.
  # FIXME: currently we _also_ use offload mode when docked. We should try
  # using sync mode instead.
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime = {
          sync.enable = lib.mkForce false;
          offload = {
            enable = lib.mkForce true;
            enableOffloadCmd = lib.mkForce true;
          };
        };
        powerManagement = {
          enable = lib.mkForce true;
          finegrained = lib.mkForce true;
        };
      };
    };
  };
}

