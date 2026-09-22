{ assets, ... }: {
  programs.noctalia = {
  	enable = true;
	  systemd.enable = true;
	  settings = import ./settings.nix { inherit assets; };
	  checkConfig = true;
  };
}
