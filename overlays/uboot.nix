final: super: {
  buildUBoot = args @ { extraMakeFlags ? [], ... }: (super.buildUBoot args).override {
    makeFlags = [ "CROSS_COMPILE=${super.stdenv.cc.targetPrefix}" ] ++ extraMakeFlags;
  };
}

