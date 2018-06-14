{ stdenv, fetchFromGitHub, pkgconfig, fuse, cryptopp, curl, openssl, db5, freeimage, readline }:

let
  inherit (stdenv.lib) optional;
in stdenv.mkDerivation rec {
  name = "megafuse";

  src = fetchFromGitHub {
    owner = "matteoserva";
    repo = "MegaFuse";
    rev = "6e7f18fdfdab032cff502de2063a2a58985b3a3c";
    sha256 = "0s00v7kq6r981b2f7q1xm9wkml5a6v5hnqa0w9kw58bpahadjinl";
  };

  nativeBuildInputs = [ pkgconfig freeimage ];
  patches = [ ./makefile-cryptopp-include.patch ./makefile_install.patch ./missing_headers.patch ];

  CRYPTOPP_INC = "${cryptopp}/include/cryptopp";
  buildInputs = [ curl openssl db5 cryptopp fuse readline ];

  installFlags = "PREFIX=\${out}";

  # TODO: pass cryptopp include directory into Makefile

  #NIX_CFLAGS_COMPILE = stdenv.lib.optional
    #(stdenv.system == "i686-linux")
    #"-D_FILE_OFFSET_BITS=64";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "MEGA client for linux, based on FUSE";
    platforms = platforms.linux;
    maintainers = with maintainers; [ michojel ];
  };
}
