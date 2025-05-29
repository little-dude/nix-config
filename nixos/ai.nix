{pkgs, ...}: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  environment.systemPackages = [pkgs.oterm];
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
