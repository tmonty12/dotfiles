{
  description = "Home Manager configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # System types
      darwinSystem = "aarch64-darwin";  # Apple Silicon
      linuxSystem = "x86_64-linux";
      aarch64LinuxSystem = "aarch64-linux";
    in
    {
      # Home Manager configurations
      homeConfigurations = {
        # Local macOS configuration
        "home" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${darwinSystem};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            user = "tmontfort";
            homeDirectory = "/Users/tmontfort";
            useForwardedSshAgent = false;
          };
        };

        "bataquaman" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linuxSystem};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            user = "tmontfort";
            homeDirectory = "/home/tmontfort";
            useForwardedSshAgent = true;
          };
        };

        "brev-vm" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linuxSystem};
          modules = [ ./home.nix ];  # Use the same file with conditionals
          extraSpecialArgs = {
            user = "ubuntu";
            homeDirectory = "/home/ubuntu";
            useForwardedSshAgent = false;
          };
        };

        "brev-vm-gpu" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linuxSystem};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            user = "nvidia";
            homeDirectory = "/home/nvidia";
            useForwardedSshAgent = false;
          };
        };

        "brev-vm-arm" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${aarch64LinuxSystem};
          modules = [ ./home.nix ];  # Use the same file with conditionals
          extraSpecialArgs = {
            user = "ubuntu";
            homeDirectory = "/home/ubuntu";
            useForwardedSshAgent = false;
          };
        };
      };

      packages = {
        ${darwinSystem}.home-manager = home-manager.packages.${darwinSystem}.home-manager;
        ${linuxSystem}.home-manager = home-manager.packages.${linuxSystem}.home-manager;
        ${aarch64LinuxSystem}.home-manager = home-manager.packages.${aarch64LinuxSystem}.home-manager;
      };

      formatter = {
        ${darwinSystem} = nixpkgs.legacyPackages.${darwinSystem}.nixpkgs-fmt;
        ${linuxSystem} = nixpkgs.legacyPackages.${linuxSystem}.nixpkgs-fmt;
      };
    };
}
