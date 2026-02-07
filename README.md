# dotflake

.NET flake test

## Prerequisites

- Git
- Nix
- .NET SDK 9

## Usage

Run the nix devshell to start PostgreSQL and apply EF Core migrations automatically.

```sh
nix develop
```

### Details

* PostgreSQL runs on port 5432
* Credentials and DB name are defined in `appsettings.Development.json`

## Packaging

When project depencies change, Nix should be informed.
This can be done with the following commands.

```sh
nix build .#fetch-deps
./result deps.json
```

# References

- https://wiki.nixos.org/wiki/DotNET
- https://nixos.org/manual/nixpkgs/stable/#packaging-a-dotnet-application
- https://nixos.org/manual/nixpkgs/stable/#generating-and-updating-nuget-dependencies
