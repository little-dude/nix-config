{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    OVMF
    pciutils
  ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
      qemuVerbatimConfig = ''
        nvram = [
        "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"
        ]
      '';
    };
    docker.enable = true;
  };
  users.groups = {
    libvirtd.members = [
      "root"
      "little-dude"
    ];
    docker.members = [
      "root"
      "little-dude"
    ];
  };
  boot = {
    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    kernelModules = [
      "kvm-intel"
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      "vfio_virqfd"
    ];
    kernelParams = [ "intel_iommu=on" ];
    extraModprobeConfig = "options vfio-pci ids=[10de:28e0, 10de:22be]";
  };
}
