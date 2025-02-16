{ config, lib, pkgs
, buildUBoot
, fetchFromGitHub
, ... }: (buildUBoot {
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "3ddc8083aea1e7044b5b33e7c580943f834f1c67";
    hash = "sha256-MMu5Bs8RUAc3LZ52Uc12VdBdC6bLVPw0pG5OXYaJK6k=";
  };
  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}).overrideAttrs (old: {
  patches = [];
})

