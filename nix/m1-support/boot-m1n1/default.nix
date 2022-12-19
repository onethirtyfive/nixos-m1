{ pkgs
, lib
, m1n1 # per overlay, defaults to pkgs.m1n1 via callPackage
, u-boot # per overlay, defaults to pkgs.u-boot via callPackage
, kernelPackages # required
, m1n1ExtraOptions ? ""
, ... }:
assert (kernelPackages != null); pkgs.runCommand "boot.bin" {} ''
  cat ${m1n1}/build/m1n1.bin > $out
  cat ${kernelPackages.kernel}/dtbs/apple/*.dtb >> $out
  cat ${u-boot}/u-boot-nodtb.bin.gz >> $out
  if [ -n "${m1n1ExtraOptions}" ]; then
    echo '${m1n1ExtraOptions}' >> $out
  fi
''

