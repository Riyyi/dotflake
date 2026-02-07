{
  description = ".NET package";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-linux"
      ];
    in
    {

      # ====================================
      # Development shell

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              dotnetCorePackages.sdk_9_0-bin
              nuget-to-json
              postgresql_16
            ];

            shellHook = ''
              export ASPNETCORE_ENVIRONMENT=Development

              export PGDATA=$PWD/.pgdata
              export PGHOST=localhost
              export PGPORT=5432
              export PGUSER=$USER

              export APP_DATABASE=appdb
              export APP_USER=devuser
              export APP_PASSWORD=devpass

              if [ ! -d "$PGDATA" ]; then
                initdb --auth-local=peer

                pg_ctl -l $PGDATA/logfile start

                createdb
                psql \
<<EOF
                  CREATE ROLE $APP_USER WITH LOGIN PASSWORD '$APP_PASSWORD';
                  CREATE DATABASE $APP_DATABASE OWNER $APP_USER;
                  GRANT ALL PRIVILEGES ON DATABASE $APP_DATABASE TO $APP_USER;
EOF

                pg_ctl stop
              fi

              pg_ctl -l $PGDATA/logfile start

              trap "pg_ctl stop" EXIT

              dotnet ef database update
            '';

          };
        }
      );

      # ====================================
      # Package

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          project = pkgs.buildDotnetModule {
            pname = "dotflake";
            version = "0.1.0";

            src = ./.;

            dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0-bin;
            dotnet-runtime = pkgs.dotnetCorePackages.aspnetcore_9_0-bin;

            projectFile = "dotflake.sln"; # NOTE: this is relative to ${src}!
            nugetDeps = ./deps.json;
            selfContainedBuild = false;
          };
        in
        {
          default = project;
          fetch-deps = project.fetch-deps;
        }
      );

    };
}
