{ lib }: {
  mkOverlayOption = with lib;
  prefix: {
    ovelay,
    description ? mdDoc "Whether to enable ${overlay} device tree overlay"
  }: mkOption {
    inherit description;
    default = false;
    example = true;
    type = types.bool;
    apply = enabled: {
      config.hardware.deviceTree.enabledOverlays =
        if enabled then ["${prefix}/${overlay}.dtbo"] else [];
    }
  };
}