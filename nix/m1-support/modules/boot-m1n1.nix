{ config , pkgs , lib , ... } @ args:
let
  pkgs' = config.hardware.asahi.pkgs;

  overrides = rec {
    m1n1 = pkgs'.m1n1.override {
      isRelease = true;
      withTools = false;
      customLogo = config.boot.m1n1CustomLogo;
    };

    u-boot = pkgs'.u-boot.override { inherit m1n1; };
  };

  boot-m1n1 = (pkgs'.mk-boot-m1n1 config.boot.kernelPackages).override {
    inherit (overrides) m1n1 u-boot;
  };
in {
  config = let
    bootFiles = {
      "m1n1/boot.bin" = boot-m1n1;
    };
  in {
    # install m1n1 with the boot loader
    boot.loader.grub.extraFiles = bootFiles;
    boot.loader.systemd-boot.extraFiles = bootFiles;

    # ensure the installer has m1n1 in the image
    system.extraDependencies = (builtins.attrValues overrides);
    system.build.m1n1 = bootFiles."m1n1/boot.bin";
  };

  options.boot = {
    m1n1ExtraOptions = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Append extra options to the m1n1 boot binary. Might be useful for fixing
        display problems on Mac minis.
        https://github.com/AsahiLinux/m1n1/issues/159
      '';
    };

    m1n1CustomLogo = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Custom logo to build into m1n1. The path must point to a 256x256 PNG.
      '';
    };
  };
}
