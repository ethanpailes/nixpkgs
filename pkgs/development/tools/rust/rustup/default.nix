{ stdenv, tree, openssl, fetchFromGitHub, rustUnstable, cargo }:

let
  version = "0.1.6";
in

with rustUnstable;

# stdenv.mkDerivation rec {
    # name = "rustup-${version}";
# 
    # src = fetchFromGitHub {
        # owner = "rust-lang-nursery";
        # repo  = "rustup.rs";
        # rev   = "${version}";
        # sha256 = "0hldsb1ah0khr9fgkpy0158yjkvzx37nrcplcy0a4wyj3fgcjk2m";
    # };
# 
    # buildInputs = [ openssl cargo rustUnstable.rustc rustUnstable.rustRegistry ];
# 
    # buildPhase = ''
        # cat << EOF > deps/config
# [registry]
# index = \"file:///dev/null\"
# EOF
        # echo "running: cargo build --release"
        # cargo build --verbose --release
    # '';
# }


buildRustPackage {
  name = "rustup-${version}";
  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustup.rs";
    rev = "${version}";
    sha256 = "0hldsb1ah0khr9fgkpy0158yjkvzx37nrcplcy0a4wyj3fgcjk2m";
  };

  depsSha256 = "0wy6czcmgsc9n95zpaiihy1pb7zhidq569y57ka5dxpmkbwjx2kp";
  # depsSha256 = "1r2fxirkc0y6g7aas65n3yg1f2lf3kypnjr2v20p5np2lvla6djj";

  buildInputs = [ tree openssl ];#rustUnstable.rustc rustUnstable.rustRegistry ];

  # unpackPhase = ''
    # cat env-vars
  # '';

  preUnpack = ''
    mkdir -p deps/registry/index/-2304f9dd481834b8
    echo "source files are:"
    tree /nix/store/s14nrr24mjv7g7326v60w2m1hq8v9fck-rustup.rs-0.1.6-src
  '';

  postUnpack = ''
    echo "Made it through unpack."
  '';

  buildPhase = ''
    echo "build"
    tree .
  '';

  # configurePhase = ''
  #   echo $(pwd)
  #   tree .
  # '';

  # The default install phase should work.
  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp -p target/release/rustup $out/bin/
  # '';

  meta = with stdenv.lib; {
    description = "A toolchain multiplexer for the rust programming language.";
    homepage = https://github.com/rust-land-nursery/rustup.rs;
    license = with licenses; [ mit asl20 ];
  };
}
