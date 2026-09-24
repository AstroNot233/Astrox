{
  description = "Flake of kay@astrox for AstroNot233";
  inputs = {
    nixpkgs = {
      type = "git";
      url = "ssh://git@github.com/NixOS/nixpkgs.git";
      ref = "nixos-unstable";
      shallow = true;
    };
    home-manager = {
      type = "git";
      url = "ssh://git@github.com/nix-community/home-manager.git";
      ref = "master";
      shallow = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    let
      globalArgs = inputs // {
        assets = import ./assets;
        hostPlatform = "x86_64-linux";
      };
    in
    with globalArgs;
    {
      nixosConfigurations = {
        astrox = nixpkgs.lib.nixosSystem {
          specialArgs = globalArgs;
          modules = [
            ./hardware-config.nix
          ];
        };
      };
      homeConfigurations = {
        kay = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${hostPlatform};
          extraSpecialArgs = globalArgs;
          modules = [
          ];
        };
      };
      formatter = {
        ${hostPlatform} = nixpkgs.legacyPackages.${hostPlatform}.nixfmt;
      };
    };
}
