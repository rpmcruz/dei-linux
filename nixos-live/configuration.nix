{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/graphical-cd.nix> ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.device = "nodev"; # for live CD, no need to install

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  environment.systemPackages = with pkgs; [
    python3
    jdk
  ];

  nixpkgs.config.allowUnfree = true;
  users.users.demo = {
    isNormalUser = true;
    password = "demo";
  };
}
