{
  stdenv,
  fetchurl,
  lib,

  # Various scripting languages provided. Only needed at compile time.
  lua,
  tcl,
  perl,
  mujs,
  mruby,
  duktape,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fungw";
  version = "1.2.1";

  src = fetchurl {
    url = "http://repo.hu/projects/fungw/releases/fungw-${finalAttrs.version}.tar.gz";
    hash = "sha256-3RJmcTo/jg+G/olCxeVlt4ajv/5CszGmAj1Wwi/wAq4=";
  };


  # Scripting language only needed at compile time to link, but user decides
  # availabilty at use-time.
  buildInputs = [
    lua
    tcl
    perl
    mujs
    mruby
    duktape
    # Note: no Python, as Python3 is generally broken for embedded use.
    # http://repo.hu/projects/fungw/lang_python3.html
  ];

  meta = with lib; {
    description = "Tiny, portable library that manages dynamic function calls across different programming languages.";
    homepage = "http://repo.hu/projects/fungw/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ hzeller ];
  };
})
