{ stdenv, fetchgit, git, zlib, gcc, patchelf, makeWrapper, which }:

let
  version = "0.8.0";
in

stdenv.mkDerivation rec {
  name = "multirust-${version}";

  #
  # NOTE: If you change the rev here you must also change ver_date
  # and ver_hash in build.sh.patch
  #
  src = fetchgit {
    url = "https://github.com/brson/multirust";
    rev = "ab97f829aa669e3537e472e8bfad296f20df545d";
    sha256 = "0hhzlm43dgmyf3x55gmvkd2kpnkznprlh760f0gjw8hn8yyiz380";

    # TODO: why doesn't this work?
    # fetchSubmodules = true;
  };

  buildInputs = [ git zlib patchelf which ];

  libPath = stdenv.lib.makeLibraryPath [
    zlib gcc
  ];

  postPatch = ''
    sed -i -e "s|DYN_LINKER_FILE|$out/dyn_linker.txt|g" src/multirust
    sed -i -e "s|PATCHELF_BIN_FILE|$out/patchelf_bin_file.txt|g" src/multirust
    sed -i -e "s|LIB_PATH_FILE|$out/lib_path.txt|g" src/multirust
  '';

  patches = [
    ./build.sh.patch
    ./install.sh.patch

    # multirust does not know anything about how nix dynamic linking works,
    # so we have to tell it.
    ./multirust.patch
  ];



  buildPhase = ''
    ./build.sh $out
  '';

  #
  # NOTE: I will have to add the dynamic linker to the patch files
  # to inject NIX_CC into the wrapper script
  installPhase = ''
    OUT=$out ./install.sh --prefix=$out

    echo ${libPath} > $out/lib_path.txt
    cat $NIX_CC/nix-support/dynamic-linker > $out/dyn_linker.txt
    which patchelf > $out/patchelf_bin_file.txt
  '';

  postInstall = ''
    # for prog in multirust cargo rustc rustdoc rust-gdb
    # wrapProgram $out/bin/multirust --prefix PATH : $(which patchelf) \
        # --set "DYN_LINKER" $(cat $NIX_CC/nix-support/dyn_linker) \
        # --set "LIB_PATH" ${libPath}
  '';

  meta = with stdenv.lib; {
    description = "A simple tool for managing multiple installations of the Rust toolchain.";
    homepage = https://github.com/brson/multirust;
    license = with licenses; [ mit asl20 ];
  };

}
