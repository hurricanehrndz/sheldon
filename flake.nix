{
  description = "Sheldon -  Fast, configurable, shell plugin manager";

  inputs.utils.url = "github:numtide/flake-utils";
  inputs.naersk.url = "github:nmattia/naersk";

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      naersk-lib = naersk.lib."${system}";
    in rec {
      packages.sheldon = naersk-lib.buildPackage {
        pname = "sheldon";
        root = ./.;
        buildInputs = [pkgs.openssl pkgs.pkgconfig];
      };
      defaultPackage = packages.sheldon;

      apps.sheldon = utils.lib.mkApp {
        drv = packages.sheldon;
      };
      defaultApp = apps.sheldon;

      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [openssl pkgconfig rustc cargo];
      };
    });
}
