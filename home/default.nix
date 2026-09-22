{ hostPlatform, pkgs, llm-agents, ... }: {
  imports = [
    ./appearance
    ./programs
    ./services
  ];
  home = rec {
    username = "kay";
    packages = builtins.concatLists [
      (with llm-agents.packages.${hostPlatform}; [
        dsh
      ])
      (with pkgs; [
        typst
        tinymist
        r2modman
      ])
    ];
    shell = {
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
}
