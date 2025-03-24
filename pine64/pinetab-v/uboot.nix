{ config, lib, pkgs
, buildUBoot
, fetchFromGitHub
, ... }: (buildUBoot {
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "196f587b957a7a7b2900de53b1cafb6ae034de0d";
    hash = "sha256-/lPnxrJVSGyxbnhbcTbbD/6Devn6qoMabNxyd1N3UOg=";
  };
  defconfig = "pine64_pinetabv_defconfig";
  postPatch = ''
    sed -i -e 's#printf#//printf#g' drivers/video/starfive_seeed_panel.c
  '';
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/pine64_pinetabv.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
  extraConfig = ''
    
  '';
  env.NIX_CFLAGS_COMPILE = "-Wno-int-conversion -Wno-implicit-function-declaration";
}).overrideAttrs (old: {
  patches = [
    # HS200 support introduced in:
    # https://github.com/starfive-tech/u-boot/commit/8bc74ce3e17fc569c612f4f1c70d1be4c94475f5#diff-42780b1add333460b8a0217175c7aaf0bff94bab13c89cda996fb5d0f8c0f904
    ./uboot_hs200_support.patch
  ];
})

