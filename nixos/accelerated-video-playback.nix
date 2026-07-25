{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vpl-gpu-rt # oneVPL runtime, needed for QSV encoding (OBS)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
