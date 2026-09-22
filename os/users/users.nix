{ ... }: {
  users.users = {
    "kay" = {
      isNormalUser = true;
      extraGroups = [ "root" "wheel" "network" "render" "video" ];
      initialPassword = "kay";
    };
  };
}
