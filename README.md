# dotfiles

This is a set of dotfiles for Linux, intended to be used with [GNU `stow`](https://www.gnu.org/software/stow/).

## Terminology

From [the `stow` docs](https://www.gnu.org/software/stow/manual/stow.html#Terminology):

> A _package_ is a related collection of files and directories that you wish to administer as a unit — e.g., Perl or Emacs — and that needs to be installed in a particular directory structure — e.g., with bin, lib, and man subdirectories.

Each of the directories in this repo acts as a `stow` package.

## Dependencies

You can install the system dependencies these dotfiles depend on using [Nix Flakes](https://nixos.wiki/wiki/Flakes). See [here]() to install the Nix package manager, and run the following command to enable Flakes:

```bash
echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf
```

For simplicity, a script is included that will properly install the dependencies. Use:

```bash
./dependencies.sh
```

This simply runs the `nix profile install` command with `--impure` and the proper target within the Flake.

To uninstall the dependencies, you can use:

```bash
./dependencies.sh remove
```

## Installing packages

To install specific packages, use:

```bash
stow -v <packages...>
```

For simplicity, a script is included that installs all packages. Use:

```bash
./packages.sh
```

This simply loops over the directories and runs `stow -v` on each one.

To uninstall a specific package, use:

```bash
stow -Dv <packages...>
```

Or, to uninstall all packages using the provided script:

```bash
./packages.sh remove
```
