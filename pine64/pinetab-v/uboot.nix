{ config, lib, pkgs
, buildUBoot
, fetchFromGitHub
, ... }: buildUBoot {
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "62eeb016d65b6872408d9e5384cd9626aee8ff2a";
    hash = "sha256-mL9RbwFkFVW24Ycb0rjD8rjusQLDFC7hiYIgWCLj64Q=";
  };
  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}
