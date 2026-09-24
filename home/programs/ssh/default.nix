{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "Host github.com" = {
        IdentityFile = "/sync/Security/SSH/ed25519/astrox";
        AddKeysToAgent = true;
      };
      "Host codeberg.org" = {
        IdentityFile = "/sync/Security/SSH/ed25519/astrox";
        AddKeysToAgent = true;
      };
    };
  };
}
