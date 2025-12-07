{ config, pkgs, ... }:
{
imports = [
  <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
];

time.timeZone = "Europe/Lisbon";
i18n.defaultLocale = "pt_PT.UTF-8";
services.xserver.xkb.layout = "pt";
console.keyMap = "pt-latin1";

services.xserver = {
  enable = true;
  desktopManager = {
    xterm.enable = false;
    xfce.enable = true;
  };
};
services.displayManager.defaultSession = "xfce";
services.displayManager.autoLogin.enable = true;
services.displayManager.autoLogin.user = "demos";

users.users.demos = {
  isNormalUser = true;
  password = "demos";
};
nixpkgs.config.pulseaudio = true;

environment.systemPackages = with pkgs; [
  (python313.withPackages (ps: with ps; [ pygame pytmx cairosvg ]))
  jre
];

environment.etc."xdg/autostart/xfce4-hide-icons.desktop".source = ./xfce4-hide-icons.desktop;

system.activationScripts.populateDemo = ''
  cp -r ${./demos} /demos
  cp -r ${./desktop} '/home/demos/Área de Trabalho'
  chown -R demos:users /demos '/home/demos/Área de Trabalho'
  chmod -R a+rwX /demos
'';
}
