{
  pkgs,
  lib,
  ...
}: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    # https://mikelev.in/futureproof/nixos-nvidia-cuda-ollama/#working-nvidia-configuration-example
    # environmentVariables = {
    #   CUDA_VISIBLE_DEVICES = "0";
    #   NVIDIA_VISIBLE_DEVICES = "all";
    # };
  };
  environment.systemPackages = with pkgs; [
    oterm
    # https://mikelev.in/futureproof/nixos-nvidia-cuda-ollama/#working-nvidia-configuration-example
    # cudaPackages.cudatoolkit
    # cudaPackages.cudnn
    # cudaPackages.cuda_cudart
  ];
  # https://mikelev.in/futureproof/nixos-nvidia-cuda-ollama/#working-nvidia-configuration-example
  # environment.sessionVariables = {
  #   CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
  #   CUDA_MODULE_LOADING = "LAZY";
  #   # LD_LIBRARY_PATH = lib.makeLibraryPath [
  #   #   "${pkgs.cudaPackages.cudatoolkit}"
  #   #   "${pkgs.cudaPackages.cudatoolkit}/lib64"
  #   #   pkgs.cudaPackages.cudnn
  #   #   pkgs.cudaPackages.cuda_cudart
  #   #   pkgs.stdenv.cc.cc.lib
  #   # ];
  # };
  services.open-webui = {
    package = pkgs.open-webui;
    enable = true;
    environment = {
      ENABLE_SIGNUP = "True";
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };
}
