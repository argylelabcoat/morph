{ stdenv, fetchgit, buildGoModule, go-bindata, lib
, version ? "dev"
}:

buildGoModule rec {
  name = "morph-unstable-${version}";
  inherit version;

  buildInputs = [ go-bindata ];

  src = import ./source.nix { inherit lib; };

  buildFlagsArray = ''
    -ldflags=
    -X
    main.version=${version}
  '';

  postPatch = ''
    go-bindata -pkg assets -o assets/assets.go data/
  '';

  postInstall = ''
    mkdir -p $lib
    cp -v $src/data/*.nix $lib
    cp morph $out/
  '';

  outputs = [ "out" "lib" ];

  meta = {
    homepage = "https://github.com/DBCDK/morph";
    description = "Morph is a NixOS host manager written in Golang.";
  };
}
