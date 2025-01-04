{ pkgs, config, lib
, buildLinux
, fetchpatch
, fetchFromGitHub
, linuxPackagesFor
, callPackage
, ... }@args: let
  fishWaldoSrc = fetchFromGitHub {
    owner = "FishWaldo";
    repo = "Star64_linux";
    rev = "1456c984f15e21e28fb8a9ce96d0ca10e61a71c4";
    hash = "sha256-I5wzmxiY7PWpahYCqTOAmYEiJvpRPpUV7S21Kn9lLwg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/torvalds/linux/commit/215bebc8c6ac438c382a6a56bd2764a2d4e1da72.diff";
      hash = "sha256-1ZqmVOkgcDBRkHvVRPH8I5G1STIS1R/l/63PzQQ0z0I=";
      includes = ["security/keys/dh.c"];
    })
    (fetchpatch {
      url = "https://github.com/starfive-tech/linux/pull/108/commits/9ae8cb751c4d1fd2146b279a8e67887590e9d07a.diff";
      hash = "sha256-EY0lno+HkY5mradBUPII3qqu0xh+BVQRzveCQcaht0M=";
    })
    (fetchpatch {
      url = "https://github.com/Fishwaldo/Star64_linux/commit/b1d5cf36b4cf2ef2a7cd6aad717cae599d990403.diff";
      hash = "sha256-YMbcRIMhjdwVAl8j+7MyY+dCHLZCmQpC1WC1DLVDw+I";
      includes = [
        "drivers/gpu/drm/i2c/tda998x_pin.c"
        "drivers/gpu/drm/verisilicon/vs_drv.c"
      ];
    })
    ./rtc-starfive-irq-desc.patch
    ./drm-img-rogue-common.patch
    ./pinetabv-dtsi-battery.patch
  ];
  version = "5.15.131";
  
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
    extraMeta.branch = "5.15";
  };
  
in buildLinux (linux-ptv // args.argsOverride or { })
