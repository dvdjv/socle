{ lib }: {
  mkOverlayOption = with lib;
  prefix: {
    overlay,
    description ? mdDoc "Whether to enable ${overlay} device tree overlay"
  }: mkOption {
    inherit description;
    default = false;
    example = true;
    type = types.bool;
    apply = enabled: if enabled then ["${prefix}/${overlay}.dtbo"] else [];
  };
}