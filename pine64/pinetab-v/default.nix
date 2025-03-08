{ config, lib, pkgs, ... }: {
  nixpkgs.overlays = [(self: super: {
    makeModulesClosure = x: super.makeModulesClosure (x // {
      allowMissing = true;
    });

    linux-ptv = pkgs.callPackage ./linux-5.15.nix {
      inherit (config.boot) kernelPatches;
    };

    linux-ptv-6' = pkgs.callPackage ./linux-6.6.nix {
      inherit (config.boot) kernelPatches;
    };

    linux-ptv-6 = self.linux-ptv-6'.overrideAttrs (old: {nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.breakpointHook];});
  })];

  # Somehow ttyS0 dOAoesn't get enabled by default
  systemd.services."serial-getty@ttyS0".enable = lib.mkDefault true;
  systemd.services."serial-getty@ttyS0".wantedBy = lib.mkDefault [ "getty.target" ];

  boot = {
    # Force no ZFS (from nixos/modules/profiles/base.nix) until updated to kernel 6.0
    # TODO still valid for star64?
    supportedFilesystems =
      lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault (pkgs.linuxPackagesFor pkgs.linux-ptv-6');

    kernelParams = lib.mkDefault [ "console=ttyS0" ];

    initrd.availableKernelModules = [ "dw_mmc_starfive" ];

    # Ethernet. The module gets forced m due to other modules even though
    # it's marked y in defconfig.
    kernelModules = [ "dwmac-starfive-plat" ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.deviceTree.name =
    lib.mkDefault "starfive/jh7110-pine64-pinetabv.dtb";
}
