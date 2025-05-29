{pkgs, ...}: {
  environment.systemPackages = [pkgs.virt-manager];
  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };
  users.users.little-dude.extraGroups = [
    "docker"
    "libvirtd"
  ];
  boot.kernelModules = ["kvm-intel"];
}
