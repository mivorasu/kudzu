{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/5a61dd8b20df4206a7c58c985fec9214f1621702";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nix = {
      url = "github:DeterminateSystems/nix-src/v3.8.4";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-regression.follows = "nixpkgs";
      inputs.nixpkgs-23-11.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nix-index-database.follows = "nix-index-database";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          formatter = pkgs.nixfmt-tree;

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowAliases = false;
              warnUndeclaredOptions = true;
            };
            overlays = [
              inputs.firefox-addons.overlays.default
              (import ./overlays { inherit inputs; })
            ];
          };

          legacyPackages = pkgs;

          packages.default = pkgs.coreutils;
        };

      flake = {
        nixosConfigurations.noirriko = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = inputs;
          modules = [
            nixos/noirriko/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                backupFileExtension = "bak";
                users.uymi.imports = [ home-manager/uymi.nix ];
              };
            }
          ];
        };

        homeConfigurations.uymi = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
              inputs.firefox-addons.overlays.default
              (import ./overlays { inherit inputs; })
            ];
          };
          extraSpecialArgs.inputs = inputs;
          modules = [ home-manager/uymi.nix ];
        };
      };
    };

  # nixConfig = {
  #   experimental-features = [
  #     "nix-command"
  #     "flakes"
  #     "cgroups"
  #   ];
  #   lazy-trees = true;
  #   use-cgroups = true;
  #   use-registries = false;
  #   warn-dirty = false;
  #   fsync-metadata = false;
  #   always-allow-substitutes = true;
  #   builders-use-substitutes = true;
  #   require-sigs = false;
  #   extra-substituters = [
  #     "https://mirrors.ustc.edu.cn/nix-channels/store"
  #     "https://nix-community.cachix.org"
  #     "https://cache.garnix.io"
  #     "https://liramiko.cachix.org"
  #     "https://nixpkgs-update-cache.nix-community.org"
  #   ];
  #   extra-trusted-public-keys = [
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  #     "liramiko.cachix.org-1:jK+V6ujmsq8pTXnqcESWXeAy+LYNnG2mC+mOj2hhpZc="
  #     "nixpkgs-update-cache.nix-community.org-1:U8d6wiQecHUPJFSqHN9GSSmNkmdiFW7GW7WNAnHW0SM="
  #   ];
  # };
}
