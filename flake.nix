{
  description = ''A flake to build astrox for AstroNot233.'';
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    axl = {
      url = "git+https://github.com/Mystic-Stars/Axolotl/?ref=refs/tags/v1.9.7-beta.3";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    xmcl = {
      url = "github:AstroNot233/X-Minecraft-Launcher-Flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: rec {
    globalArgs = inputs // {
      assets = import ./assets;
      hostPlatform = "x86_64-linux";
    };
    nixosConfigurations = with globalArgs; {
      astrox = globalArgs.nixpkgs.lib.nixosSystem {
        specialArgs = globalArgs;
        modules = [
          ./hardware-config.nix
          ./os
        ];
      };
    };
    homeConfigurations = with globalArgs; {
      kay = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${hostPlatform};
        extraSpecialArgs = globalArgs;
        modules = [
          ./home
          axl.homeModules
          xmcl.homeModules
        ];
      };
    };
    devShells = with globalArgs; {
      ${hostPlatform}.default = nixpkgs.legacyPackages.${hostPlatform}.mkShell {
        packages = with nixpkgs.legacyPackages.${hostPlatform}; [
          curl
          wget
          python3
          coreutils
          findutils
          diffutils
          file
        ];
      };
    };
  };
}
