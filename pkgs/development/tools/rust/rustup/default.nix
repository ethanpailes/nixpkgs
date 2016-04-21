{ stdenv, openssl, fetchFromGitHub, rustPlatform }:

let
  version = "0.1.6";
in

with rustPlatform;

buildRustPackage rec {
  name = "rustup-${version}";
  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustup.rs";
    rev = "${version}";
    sha256 = "0hldsb1ah0khr9fgkpy0158yjkvzx37nrcplcy0a4wyj3fgcjk2m";
  };

  depsSha256 = "0wy6czcmgsc9n95zpaiihy1pb7zhidq569y57ka5dxpmkbwjx2kp";
  # depsSha256 = "1r2fxirkc0y6g7aas65n3yg1f2lf3kypnjr2v20p5np2lvla6djj";

  buildInputs = [ openssl ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/rustup $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A toolchain multiplexer for the rust programming language.";
    homepage = https://github.com/rust-land-nursery/rustup.rs;
    license = with licenses; [ mit asl20 ];
  };
}
