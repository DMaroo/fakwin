{
  description = "FakWin - Fake KWin DBus service for KDE 6 compatibility";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          packages.default = pkgs.stdenv.mkDerivation rec {
            pname = "fakwin";
            version = "1.0.0";

            src = ./.;

            nativeBuildInputs = with pkgs; [
              cmake
              pkg-config
              qt6.wrapQtAppsHook
            ];

            buildInputs = with pkgs; [
              qt6.qtbase
            ];

            cmakeFlags = [
              "-DCMAKE_BUILD_TYPE=Release"
            ];

            installPhase = ''
              runHook preInstall
              mkdir -p $out/bin
              cp fakwin $out/bin/
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Fake KWin DBus service so that KDE 6 shutdown/reboot/logout works when not using KWin";
              homepage = "https://github.com/DMaroo/fakwin";
              license = licenses.mit;
              maintainers = [ "DMaroo" ];
              platforms = platforms.linux;
            };
          };

          packages.fakwin = self'.packages.default;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cmake
              pkg-config
              qt6.qtbase
              qt6.qttools
              gdb
            ];

            shellHook = ''
              echo "FakWin development environment"
              echo "Build with: mkdir build && cd build && cmake .. && make"
              echo "Test with: qdbus org.kde.KWin /Session"
            '';
          };

        };

      flake = {
        /**
          home-manager module

          # Usage

          ```
          imports = [
            fakwin.homeManagerModules.default
          ];

          services.fakwin.enable = true;
          ```
        */
        homeManagerModules.default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          with lib;
          let
            cfg = config.services.fakwin;
            package = self.packages.${pkgs.system}.default;
          in
          {
            options.services.fakwin = {
              enable = mkEnableOption "FakWin fake KWin DBus service";
            };

            config = mkIf cfg.enable {
              systemd.user.services.fakwin = {
                Unit = {
                  Description = "Plasma Fake KWin dbus interface";
                  After = [ "multi-user.target" ];
                };
                Install = {
                  WantedBy = [ "default.target" ];
                };
                Service = {
                  ExecStart = "${package}/bin/fakwin";
                  Slice = "session.slice";
                  Restart = "on-failure";
                };
              };
            };
          };

        /**
          NixOS module

          # Usage

          ```
          imports = [
            fakwin.nixosModules.default
          ];

          services.fakwin.enable = true;
          ```
        */
        nixosModules.default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          with lib;
          let
            cfg = config.services.fakwin;
            package = self.packages.${pkgs.system}.default;
          in
          {
            options.services.fakwin = {
              enable = mkEnableOption "FakWin fake KWin DBus service";
            };

            config = mkIf cfg.enable {
              systemd.user.services.fakwin = {
                enable = true;
                description = "Plasma Fake KWin dbus interface";
                after = [ "multi-user.target" ];
                wantedBy = [ "default.target" ];
                serviceConfig = {
                  ExecStart = "${package}/bin/fakwin";
                  Slice = "session.slice";
                  Restart = "on-failure";
                };
              };
            };
          };
      };
    };
}
