{ config, lib, pkgs, ... }: let
  dtCfg = config.hardware.deviceTree;
  blCfg = config.boot.loader;
  elCfg = blCfg.generic-extlinux-compatible;
  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;
in {
  disabledModules = [ "system/boot/loader/generic-extlinux-compatible" ];
  imports = [ ./generic-extlinux-compatible ];

  options = {
      hardware.deviceTree.enabledOverlays = with lib; mkOption {
      default = [];
      example = literalExpression ''
      [
        "rockchip/overlay/rk3588-disable-led.dtbo"
        "rockchip/overlay/rk3588-wifi-ap6275p.dtbo"
      ]
      '';
      type = types.listOf types.str;
      description = mdDoc ''
      List of overlays to apply at runtime, relative to the dtb base.
      '';
    };
  };

  config = let
    populateBuilder = pkgs.buildPackages.substituteAll {
      src = ./extlinux-conf-builder.sh;
      isExecutable = true;
      path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
      inherit (pkgs) bash;
    };

    builderArgs = "-g ${toString elCfg.configurationLimit} -t ${timeoutStr}"
      + lib.optionalString (dtCfg.name != null) " -n ${dtCfg.name}"
      + lib.optionalString (!elCfg.useGenerationDeviceTree) " -r";
  in lib.mkIf (dtCfg.enable) {
    system.extraSystemBuilderCmds = ''
        echo ${builtins.concatStringsSep " " dtCfg.enabledOverlays } > $out/devicetree-overlays
      '';
  };
}
