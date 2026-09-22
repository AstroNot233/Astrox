{ ... }: {
  networking = {
    hostName = "astrox";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [ "Meta" "Mihomo" ];
    };
  };
}
