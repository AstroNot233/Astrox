{
  pkgs,
  ...
}:
{
  imports = [
    ./appearance
    ./programs
    ./services
  ];
  home = rec {
    username = "kay";
    packages = with pkgs; [
      typst
      tinymist
      r2modman
    ];
    shell = {
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
}
