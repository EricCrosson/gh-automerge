{
  description = "GitHub CLI extension to mark a PR as ready for review and enable auto-merge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    git-hooks,
    nixpkgs,
  }: let
    # System types to support.
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for supported system types.
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    checks = forAllSystems (system: let
      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          actionlint.enable = true;
          alejandra = {
            enable = true;
            settings = {
              verbosity = "quiet";
            };
          };
          deadnix.enable = true;
          prettier.enable = true;
          shellcheck.enable = true;
          shfmt.enable = true;
          statix.enable = true;
        };
      };
    in {
      inherit pre-commit-check;
    });

    # Add dependencies that are only needed for development
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });

    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      gh-arm = pkgs.writeShellApplication {
        name = "gh-arm";
        text = builtins.readFile ./gh-arm;
      };
    in {
      inherit gh-arm;
      default = gh-arm;
    });
  };
}
