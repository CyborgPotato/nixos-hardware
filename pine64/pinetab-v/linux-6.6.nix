{ pkgs, config, lib
, buildLinux
, fetchpatch
, fetchFromGitHub
, linuxPackagesFor
, callPackage
, ... }@args: let
  fishWaldoSrc = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "linux";
    rev = "d0e7c0486d768a294f4f2b390d00dab8bee5d726";
    hash = "sha256-7RsTjPyLfkxCsLohgvrqqf7kCk0vhhP9DSNRUTtNsFE=";
  };

  # TODO: Need patch file for pinetab-v defconfig

  patches = [
  ];

  version = "6.6.20";
  
  linux-ptv = {
    inherit version;
    modDirVersion = version;

    defconfig = "pine64_pinetabv_defconfig";
    
    src = fishWaldoSrc;
    kernelPatches = map (p: {patch = p;}) patches;
    structuredExtraConfig = with lib.kernel; {
      VIDEO_OV5640=no;
      # DRM_PANEL_BOE_TH101MB31UIG002_28A=yes;
      # DRM_PANEL_JADARD_JD9365DA_H3=yes;
      DRM_I2C_NXP_TDA998X=yes; #https://github.com/Fishwaldo/Star64_linux/pull/1/files#diff-e668dcf0da970969e5a307d49bc4e70dc18be80b434274709b705103a43f8cb5
      DRM_VERISILICON=yes;
      STARFIVE_INNO_HDMI=no;
      STARFIVE_DSI=yes;
      PHY_M31_DPHY_RX0=yes;
      DRM_IMG_ROGUE=module;
      DRM_LEGACY= lib.mkForce yes;
      CRYPTO_RMD128=no;
      CRYPTO_RMD256=no;
      CRYPTO_RMD320=no;
      CRYPTO_TGR192=no;
      CRYPTO_SALSA20=no;
      CRYPTO_SM4=no;
      CRYPTO_DEV_CCREE=no;
    };
    extraMeta.branch = "6.6";
  };
  
in buildLinux (linux-ptv // args.argsOverride or { })
