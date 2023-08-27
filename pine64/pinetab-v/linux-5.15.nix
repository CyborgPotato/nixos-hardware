{ pkgs, config, lib
, buildLinux
, fetchpatch
, fetchFromGitHub
, linuxPackagesFor
, callPackage
, ... }: let
  fishWaldoSrc = fetchFromGitHub {
    owner = "FishWaldo";
    repo = "Star64_linux";
    rev = "9a02bb009aad11b8ce16eb34155aa4e2c66c0069";
    hash = "sha256-5oKNAF5Ik8a/JUxcHPQd/AEuPgCJF8SLmQkkP+9uzww=";
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
    ./rtc-starfive-irq-desc.patch
  ];
  version = "5.15.127";
  
  linuxPkg = { ... }@args: buildLinux (args // {
    inherit version;
    modDirVersion = version;

    defconfig = "pine64_pinetabv_defconfig";
    
    src = fishWaldoSrc;
    kernelPatches = map (p: {patch = p;}) patches;
    structuredExtraConfig = with lib.kernel; {
      # Enable Panel
      # DRM_PANEL_STARFIVE_10INCH = yes;
      # Disable DRM
      # TODO: Test latest kernel w/ https://lists.freedesktop.org/archives/dri-devel/2023-August/418776.html
      DRM_IMG = no;
      DRM_IMG_ROGUE = no;
      DRM_I2C_NXP_TDA998X = no; # https://github.com/starfive-tech/linux/pull/86
      DRM_VERISILICON = no;

      # Crypto Features gone
      CRYPTO_RMD128 = no;
      CRYPTO_RMD256 = no;
      CRYPTO_RMD320 = no;
      CRYPTO_TGR192 = no;
      CRYPTO_SALSA20 = no;

      # modpost error:
      CRYPTO_SM4 = no;
      CRYPTO_DEV_CCREE = no;

      VIDEO_OV5640 = no; # conflicts with starfive VIN_SENSOR_OV5640
    };
    extraMeta.branch = "5.15";
  } // (args.argsOverride or { }));
  
in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))
