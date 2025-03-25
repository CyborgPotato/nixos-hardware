{ callPackage, pkgsBuildHost, runCommand, writeText, writeShellApplication
, stdenv, dtc, mtdutils, coreutils }:
let
  uboot = callPackage ./uboot.nix { };
  opensbi = callPackage ./opensbi.nix {
    withPayload = "${uboot}/u-boot.bin";
    withFDT = "${uboot}/pine64_pinetabv.dtb";
  };
  spl-tool = pkgsBuildHost.callPackage ./spl-tool.nix { };
  its-file = writeText "pinetabv-uboot-fit-image.its" ''
    /dts-v1/;

    / {
      description = "U-boot-spl FIT image for JH7110 PineTab-V";
      #address-cells = <2>;

      images {
        firmware {
          description = "u-boot";
          data = /incbin/("${opensbi}/share/opensbi/lp64/generic/firmware/fw_payload.bin");
          type = "firmware";
          arch = "riscv";
          os = "u-boot";
          load = <0x0 0x40000000>;
          entry = <0x0 0x40000000>;
          compression = "none";
        };
      };

      configurations {
        default = "config-1";

        config-1 {
          description = "U-boot-spl FIT config for JH7110 PineTab-V";
          firmware = "firmware";
        };
      };
    };
  '';
in rec {
  inherit opensbi uboot;

  nixpkgs.overlays = [(self: super: {
    ubootPinetabV = uboot;
  })];
  
  spl = stdenv.mkDerivation {
    name = "pine64-pinetabv-spl";
    depsBuildBuild = [ spl-tool ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/pine64-pinetabv/
      ln -s ${uboot}/u-boot-spl.bin .
      spl_tool -c -f ./u-boot-spl.bin
      cp u-boot-spl.bin.normal.out $out/share/pine64-pinetabv/spl.bin
    '';
  };
  uboot-fit-image = stdenv.mkDerivation {
    name = "pine64-pinetabv-uboot-fit-image";
    nativeBuildInputs = [ dtc ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/pine64-pinetabv/
      ${uboot}/mkimage -f ${its-file} -A riscv -O u-boot -T firmware $out/share/pine64-pinetabv/pinetabv_fw_payload.img
    '';
  };
  updater-flash = writeShellApplication {
    name = "pinetabv-firmware-update-flash";
    runtimeInputs = [ mtdutils ];
    text = ''
      flashcp -v ${spl}/share/pine64-pinetabv/spl.bin /dev/mtd0
      flashcp -v ${uboot-fit-image}/share/pine64-pinetabv/pinetabv_fw_payload.img /dev/mtd1
    '';
  };
  updater-sd = writeShellApplication {
    name = "pinetabv-firmware-update-sd";
    runtimeInputs = [ ];
    text = ''
      dd if=${spl}/share/pine64-pinetabv/spl.bin of=/dev/mmcblk0p1 conv=fsync
      dd if=${uboot-fit-image}/share/pine64-pinetabv/pinetabv_fw_payload.img of=/dev/mmcblk0p2 conv=fsync
    '';
  };
}
