self: super:
{
  # nb. below may actually *require* overrides to reference
  # nb. inconsistecy of pkg definition location is a smell
  asahi-fwextract = self.callPackage ./asahi-fwextract {};
  asahi-kernel = self.callPackage ./kernel {};
  m1n1 = self.callPackage ./m1n1 {};
  u-boot = self.callPackage ./u-boot {};

  mk-peripheral-firmware = peripheralFirmwareDirectory:
    self.callPackage ./peripheral-firmware { inherit peripheralFirmwareDirectory; };
  mk-boot-m1n1 = kernelPackages:
    self.callPackage ./boot-m1n1 { inherit kernelPackages; };
}

