{ hostPlatform, pkgs, llm-agents, ... }: {
  programs.opencode = {
    enable = false;
    package = llm-agents.packages.${hostPlatform}.opencode;
    tui = {
      keybinds = {
        command_list = "alt+x";
        input_move_up = "up,ctrl+p";
        input_move_down = "down,ctrl+n";
        input_move_left = "left,ctrl+b";
        input_move_right = "right,ctrl+f";
      };
      theme = "system";
    };
    web = {
      enable = true;
      environmentFile = null;
      extraArgs = [];
    };
    extraPackages = with pkgs; [
      git
    ];
    enableMcpIntegration = true;
    agents   = import ./agents;
    commands = import ./commands;
    skills   = import ./skills;
    tools    = import ./tools;
    context  = import ./context.nix;
    settings = import ./settings.nix;
    themes   = import ./themes.nix;
  };
}
