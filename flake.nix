{
  description = "A flake for my system environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }: 
    let
      system = builtins.currentSystem;
      pkgs = import nixpkgs {
        inherit system;
      };
      genericPackages = with pkgs; [
        gawk
        gh
        git
        kitty
        starship
        stow
        which
        kanata
        (neovim.overrideAttrs (oldAttrs: {
            version = "0.10.0";
            src = fetchFromGitHub {
              owner = "neovim";
              repo = "neovim";
              rev = "v0.10.0";
              sha256 = "0p366agcv4lz1qs453i44f9h37r09r58qj8g2wpbj0g4f6js48ql";
            };
        }))
      ];
      linuxPackages = with pkgs; [
        bashInteractive
        dunst
        i3
        jgmenu
        rofi
      ];
      nonLinuxPackages = with pkgs; [
        zsh
      ];
    in {
      packages.${system} = pkgs.buildEnv {
        name = "system-env";
        paths = genericPackages ++ (if pkgs.stdenv.isLinux then linuxPackages else nonLinuxPackages);
      };
    };
}
