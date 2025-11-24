{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.gns3-gui pkgs.dynamips pkgs.ubridge pkgs.gns3-server];
  services.gns3-server = {
    # enable = true;
    log.debug = true;
    dynamips.enable = true;
    vpcs.enable = true;
    ubridge.enable = true;
  };
  # systemd.services.gns3-server =
  #   let
  #     commandArgs = lib.cli.toCommandLineShellGNU { } {
  #       config = "/etc/gns3/gns3_server.conf";
  #       pid = "/run/gns3/server.pid";
  #       log = "/var/log/gns3/server.log";
  #       ssl = false;
  #       debug = true;
  #       certfile = null;
  #       certkey = null;
  #     };
  #     exe = lib.getExe pkgs.gns3-server;
  #   in
  #   {
  #     serviceConfig = {
  #       User = lib.mkForce "root";
  #       ExecStart = lib.mkForce "${exe} ${commandArgs}";
  #     };
  #   };
}
