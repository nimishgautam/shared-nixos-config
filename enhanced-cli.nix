{ config, pkgs, ... }:

{
  home.packages = import ./enhanced-cli-packages.nix pkgs;
}

