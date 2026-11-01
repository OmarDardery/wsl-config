# NixOS-WSL

A small, flake-based NixOS development environment for Windows Subsystem for Linux.
Uses the official [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
module and integrated Home Manager.

## Layout

| File | Role |
| --- | --- |
| `flake.nix` | NixOS 26.05, NixOS-WSL, Home Manager inputs |
| `wsl.nix` | WSL integration, login user, system settings |
| `home.nix` | Everyday developer packages and Home Manager |
| `home/shell.nix` | Zsh, Starship, fzf, zoxide, aliases |
| `home/git.nix` | Git, Git LFS, GitHub CLI, Lazygit |
| `home/editor.nix`, `nvim/` | Neovim and minimal LazyVim setup |

The environment is deliberately CLI-first: Go, gopls, gofumpt, Nix tooling,
Git, Yazi, Neovim, and terminal utilities. No desktop, GPU driver, Docker daemon,
game packages, global Python environment, or Rust toolchain is installed.

## Initial installation

In **PowerShell**, update WSL:

```powershell
wsl --install --no-distribution
wsl --update
```

Install the latest NixOS-WSL `.wsl` distribution from the
[NixOS-WSL releases](https://github.com/nix-community/NixOS-WSL/releases).
Start it with `wsl -d NixOS`.

The official image normally starts as user `nixos`, whereas this configuration
uses `oad`. Changing the default WSL user on an existing installation requires a
**boot rebuild**, not an immediate switch. See the
[official username migration instructions](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html).

**Before the first boot rebuild:** check the image's original
`system.stateVersion` in `/etc/nixos/configuration.nix`. If it differs from
`26.05`, edit `wsl.nix` to preserve the original value. Never raise the
state version merely because nixpkgs was upgraded.

In the **initial NixOS-WSL shell**, run:

```sh
export NIX_CONFIG="experimental-features = nix-command flakes"
git clone https://github.com/OmarDardery/wsl-config.git ~/wsl-config
cd ~/wsl-config
nix flake lock
sudo env NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild boot --flake "path:$PWD#wsl"
```

If the image lacks Git, install or temporarily run it using
`nix shell nixpkgs#git`.

Exit the Linux shell. In **PowerShell**:

```powershell
wsl -t NixOS
wsl -d NixOS --user root -- true
wsl -t NixOS
wsl -d NixOS
```

Once logged in as `oad`, move the checkout into the new home directory:

```sh
sudo mv /home/nixos/wsl-config "$HOME/wsl-config"
sudo chown -R oad:users "$HOME/wsl-config"
sudo nixos-rebuild switch --flake "path:$HOME/wsl-config#wsl"
```

## Everyday use

```sh
up                 # Rebuild and activate NixOS-WSL
nbuild             # Build without switching
nupdate            # Update flake inputs
cconf              # Go to the config checkout
cnf                # Edit the config in Neovim
y                  # Yazi, with shell directory tracking
gh auth login      # Authenticate GitHub CLI (one time)
```

Changes to tracked Nix files can be rebuilt with `up`. The LazyVim configuration
lives in `nvim/` and is linked by Home Manager; edit those **repository sources**
rather than the generated symlinks in `~/.config/nvim`. Plugins are fetched by
Lazy on first launch. Mason and automatic compiler-dependent parsers are disabled;
add project-specific tools through `nix develop` / `.envrc`.

The initial `nix flake lock` creates `flake.lock`. **Commit this file** to pin
dependencies and keep rebuilds reproducible. To update it later, use `nupdate`.

## Windows integration

Keep actively developed Linux projects under `/home/oad`, not `/mnt/c`, to
avoid cross-filesystem performance penalties. Windows drives appear under
`/mnt`. Use `explorer.exe .` (or the `win` alias) to open the current folder
in File Explorer.

`programs.nix-ld` is enabled to assist Windows-hosted VS Code-compatible
remote servers, but the exact Remote-WSL extension and server support depends
on the Windows editor build. No Linux GUI VSCodium package is installed.
Windows PATH interoperability remains enabled.

Docker Desktop integration is **not** enabled by default. If you install Docker
Desktop and enable its WSL integration, you may set
`wsl.docker-desktop.enable = true;` in `wsl.nix`; don't start a second Docker
daemon without a specific need.

## Verification

```sh
nix flake check "path:$HOME/wsl-config" --no-build
nix eval --raw "path:$HOME/wsl-config#nixosConfigurations.wsl.config.networking.hostName"
go version
git --version
nvim --version
wslpath -w "$HOME"
```

The NixOS configuration targets **x86_64 WSL2**. This repository has not yet
been built inside the target WSL installation; validate before considering it
production-ready.
