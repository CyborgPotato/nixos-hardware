{ config, lib, pkgs, ... }: {
  nixpkgs.overlays = [(self: super: {
    makeModulesClosure = x: super.makeModulesClosure (x // {
      allowMissing = true;
    });

    linux-ptv = pkgs.lib.recurseIntoAttrs ( pkgs.linuxPackagesFor (pkgs.callPackage ./linux-5.15.nix {
      inherit (config.boot) kernelPatches;
    }));
  })];

  # Somehow ttyS0 doesn't get enabled by default
  systemd.services."serial-getty@ttyS0".enable = lib.mkDefault true;
  systemd.services."serial-getty@ttyS0".wantedBy = lib.mkDefault [ "getty.target" ];

  boot = {
    # Force no ZFS (from nixos/modules/profiles/base.nix) until updated to kernel 6.0
    # TODO still valid for star64?
    supportedFilesystems =
      lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault pkgs.linux-ptv;

    kernelParams =
      lib.mkDefault [ "console=tty0" "console=ttyS0,115200n8" "earlycon=sbi" ];

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
