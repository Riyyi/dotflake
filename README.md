# dotflake

.NET flake test

## Prerequisites

- nix
- .NET SDK 9
- Git

## Usage

Run the nix devshell to start PostgreSQL and apply EF Core migrations automatically.

```sh
nix develop
```

### Details

* PostgreSQL runs on port 5432
* Credentials and DB name are defined in `appsettings.Development.json`

# References

- https://wiki.nixos.org/wiki/DotNET
- https://nixos.org/manual/nixpkgs/stable/#packaging-a-dotnet-application
- https://nixos.org/manual/nixpkgs/stable/#generating-and-updating-nuget-dependencies
