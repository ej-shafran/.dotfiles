# dotfiles

This is a set of dotfiles for Linux, intended to be used with [GNU `stow`](https://www.gnu.org/software/stow/).

## Terminology

From [the `stow` docs](https://www.gnu.org/software/stow/manual/stow.html#Terminology):

> A _package_ is a related collection of files and directories that you wish to administer as a unit — e.g., Perl or Emacs — and that needs to be installed in a particular directory structure — e.g., with bin, lib, and man subdirectories.

Each of the directories in this repo acts as a `stow` package.

## Installing packages

To install specific packages, use

```bash
stow -v <packages...>
```

To install all packages, use the `all.sh` script:

```bash
./all.sh
```

## Uninstall

To uninstall specific packages, use

```bash
stow -Dv <packages...>
```

To uninstall all packages, use the `all.sh` script:

```bash
./all.sh -D
```

## Dependencies

The general dependencies needed for this entire repository are:

- [`git`](./DEPENDENCIES.md#git)
- [`curl`](./DEPENDENCIES.md#curl)
- [`tar`](./DEPENDENCIES.md#tar)
- [`stow`](./DEPENDENCIES.md#stow)

Each package will also have a **Dependencies** section which sums up which dependencies it specifically needs.
