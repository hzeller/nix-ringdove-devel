{ pkgs ? import <nixpkgs> {} }:
let
  #compile_used_stdenv = pkgs.stdenv;        # Regular compilation environment
  compile_used_stdenv = pkgs.ccacheStdenv;   # Usuing ccache for faster compile

  # Ringdove base library used by all the other projects.
  local-librnd = (pkgs.callPackage ./nix/librnd.nix {
    withGtk2 = true;
    withGtk4 = false;

    # Optionally set UnstableRevision, UnstableHash to get a particular revision
  });

  # Ringdove scripting library.
  fungw = (pkgs.callPackage ./nix/fungw.nix {
  });
in
compile_used_stdenv.mkDerivation {
  name = "compile-build-environment";
  buildInputs = with pkgs;
    [
      subversion
      pkg-config
      libxml2

      libGLU
      gtk2
      gnome2.gtkglext

      lesstif

      gd
      freetype

      gtk4
      libepoxy

      # fungw is a ringdove library to allow for scripting
      fungw

      # All pcb-rnd, sch-rnd etc need the librnd which
      # we defined above.
      local-librnd
    ];

  shellHook = ''
    # The configure scripts of the various tools need to know where the librnd
    # is. If not set, they look in /usr/lib or so where they won't find it.
    export LIBRND_PREFIX=${local-librnd}
  '';
}
