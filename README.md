# Ringdove development on Nix

Simple nixos harness to be able to build [Ringdove] binaries.
All tools use the [librnd], which we can build locally (see bottom of the page)
and use for building all the other tools.

For simplicity, librnd is also provided as nix derivation here.
This repo provides a local derivation
(provided in [librnd.nix](./librnd.nix)); the [shell.nix](./shell.nix) then
sets the `LIBRND_PREFIX` environment variable with its location.

The configure-scripts of the ringdove tools read the environment variable dn
know where to find librnd.

Other relevant library needs and tools needed (such as subversion) are provided
in the toplevel shell.nix

## Enable direnv

For a pleasent development experience set up direnv:

```bash
echo "use nix" > .envrc
direnv allow
```

## Check out all the projects

```bash
for project in pcb-rnd sch-rnd camv-rnd ; do
  svn co svn://us.repo.hu/$project/trunk $project
done
```

## Build
All tools require librnd and possibly fungw, and these are provided
by librnd.nix and fungw.nix and made available in the shell.nix already.

With these, it is now possible to just build all the other tools in a regular
way, so all the `./configure` and `make` experience as usual, and doing
local modifications.

Example here to build `sch-rnd`, with installation-dir `/tmp/install`
but works for all the other tools as well.

```bash
cd sch-rnd    # The directory of the project (or pcb-rnd, camv-rnd, ...)

./configure   # Need plain configure first to pick up LIBRND_PREFIX env-var

# Now, let packages.sh figure out all the plugin configuration options
( cd doc/developer/packaging; ./packages.sh )

# Now configure for real with the generates configure args and install in /tmp
# (alternatively of course, just manually provide the flags of interest)
./configure $(cat "doc/developer/packaging/auto/Configure.args") --prefix=/tmp/install

make

make install  #  installs the whole install tree in /tmp/install
```

# Using a local librnd

Right now, to the librnd is already provided by the nix derivation, but it
is also possible to check out a local librnd and compile the tools against
that.

For that, check out librnd `svn co svn://us.repo.hu/librnd/trunk librnd`,
then build the usual way (see above). Now after a `make install` the library
is in `/tmp/install` (which is our install directory there).

Now, set the `LIBRND_PREFIX` environment variable to the location where we
just installed it:


```bash
export LIBRND_PREFIX=/tmp/install
```

... and at that point, the librnd is picked up from the new location when
running the builds for the tools above.

[Ringdove]: http://www.repo.hu/projects/ringdove/
[librnd]: http://www.repo.hu/projects/librnd/
