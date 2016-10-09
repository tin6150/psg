# https://nixos.org/wiki/Cheatsheet
# personal's collection, here called 'all'
# TBA, was not able to change name to sn-pkg
# it is really just like any other pkg
# Place file in ~/.nixpkg/config.nix
# add the whole collection via nix-env -i all
# NOTE: pkg installed on cli via nix-env -i dropbox would 
# conflict with a dup listed in this file
# also, nix-env -q will only show "all" as installed, not the individual pkg.
# this is perhaps a problem of treating it as pkg rather than a container, now things are opaque.
{
  packageOverrides = pkgs_: with pkgs_; {
    all = with pkgs; buildEnv {
    #sn-pkg = with pkgs; buildEnv {
      name = "all";
      paths = [
	#dropbox 	roxterm 	transmission
	vlc 		w3m 		tcsh
	# trying to see if can get all deps for couchdb here...
	file
	#ar

      ];
    };
  };
}
