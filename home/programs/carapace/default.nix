{ ... }: {
  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    environment = {
      CARAPACE_MATCH = true;
    };
  };
}
