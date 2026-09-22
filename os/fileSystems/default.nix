{ lib, ... }: {
  fileSystems =
    let
      c = "compress=zstd";
      n = "nofail";
    in {
      "/opt".options  = lib.mkForce [ n ];
      "/flakes".options = lib.mkForce [ "subvol=@flakes" c n ];
      "/home".options   = lib.mkForce [ "subvol=@home"   c n ];
      "/sync".options   = lib.mkForce [ "subvol=@sync"   c n ];
    };
}
