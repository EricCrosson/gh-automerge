{
  description = "GitHub CLI extension to enable auto-merge on a PR";

  nixConfig.extra-substituters = ["https://ericcrosson-gh-automerge.cachix.org"];
  nixConfig.extra-trusted-public-keys = ["ericcrosson-gh-automerge.cachix.org-1:GbweXYwKQnDBSkYtrGQQ9qYfsjh2Ar9CYUoa78pvqRM="];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = {
    # deadnix: skip
    self,
    nixpkgs,
  }: let
    forEachSystem = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  in {
    packages = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      gh-automerge = pkgs.rustPlatform.buildRustPackage {
        inherit (cargoToml.package) version;
        pname = cargoToml.package.name;
        src = ./.;
        cargoLock = {
          lockFile = ./Cargo.lock;
          outputHashes = {};
        };
      };
    in {
      inherit gh-automerge;
      default = gh-automerge;
    });
  };
}
