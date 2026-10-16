{ pkgs, ... }: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    modelsDir = "/opt/Ollama";
  };
}
