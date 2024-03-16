{ lib }: {
  mkOverlayOption = with lib;
  prefix: {
    overlay,
    inverse ? false,
    description ? mdDoc "Whether to enable ${overlay}"
  }: mkOption {
    inherit description;
    default = inverse;
    example = true;
    type = types.bool;
    apply = enabled: if enabled != inverse then [ "${prefix}/${overlay}.dtbo" ] else [];
  };
}