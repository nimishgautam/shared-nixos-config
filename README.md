# Shared Nix Configuration Modules

This directory contains portable Nix configuration modules that can be used across NixOS systems and standalone home-manager installations (e.g., on Ubuntu, macOS, or other Linux distributions).

## Modules

### 1. `fish-shell.nix`
- Fish shell configuration with custom aliases and functions
- Bobthefish theme with powerline fonts
- Zoxide integration for smart directory jumping
- Custom functions: `cl` (cd + ls), smart `less` (uses bat/glow/jless), `fkill` (interactive process killer)

### 2. `enhanced-cli.nix`
- Modern replacements for traditional Unix utilities:
  - `bat` (cat), `eza` (ls), `duf` (df), `dust` (du), `bottom` (top/htop)
  - `delta` (diff), `ripgrep` (grep), `tre` (tree), `tldr` (man)
- Essential tools: git, fzf, lazygit, xclip
- Designed to work with the fish shell aliases

### 3. `neovim.nix`
- Complete Neovim configuration with modern plugins
- Telescope (fuzzy finder), nvim-tree (file explorer), leap (motion)
- LSP support ready, with gitsigns, which-key, and more
- Uses a separate `init-nix-nvim.lua` for configuration
- Catppuccin colorscheme

## Using These Modules on Ubuntu (or other non-NixOS systems)

### Step 1: Install Nix

Install the Nix package manager with the daemon (multi-user) install:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

After installation, restart your shell or run:
```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Step 2: Enable Nix Flakes and Commands (Optional but Recommended)

Create or edit `~/.config/nix/nix.conf`:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Step 3: Install Home Manager

Add the home-manager channel:

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

Install home-manager:

```bash
nix-shell '<home-manager>' -A install
```

### Step 4: Create Your Home Configuration

Create a `~/.config/home-manager/home.nix` file (or clone this repo and reference it):

```nix
{ config, pkgs, ... }:

{
  # Import the shared modules
  imports = [
    /path/to/this/repo/shared-nixos-config/fish-shell.nix
    /path/to/this/repo/shared-nixos-config/enhanced-cli.nix
    /path/to/this/repo/shared-nixos-config/neovim.nix
  ];

  # Basic home-manager settings
  home.username = "your-username";  # Replace with your Ubuntu username
  home.homeDirectory = "/home/your-username";  # Replace with your home directory
  home.stateVersion = "25.05";  # Don't change this after initial setup

  # Enable XDG base directories
  xdg.enable = true;

  # Optional: Add any Ubuntu-specific overrides here
  # programs.git.userName = "Your Name";
  # programs.git.userEmail = "your@email.com";
}
```

### Step 5: Apply the Configuration

Apply your home-manager configuration:

```bash
home-manager switch
```

This will install all packages and set up your shell, neovim, and CLI tools.

### Step 6: Set Fish as Your Default Shell (One-time)

After the first `home-manager switch`, set fish as your default shell:

```bash
# Add fish to the list of valid shells
echo ~/.nix-profile/bin/fish | sudo tee -a /etc/shells

# Change your default shell
chsh -s ~/.nix-profile/bin/fish
```

Log out and log back in for the shell change to take effect.

## Updating Your Configuration

After making changes to any of the modules or your `home.nix`:

```bash
home-manager switch
```

## Troubleshooting

### Fish Shell Not Found
Make sure you've added fish to `/etc/shells` and that `~/.nix-profile/bin` is in your PATH.

### Fonts Missing (Powerline/Nerd Fonts)
The bobthefish theme requires powerline fonts. Install them with:

```bash
# On Ubuntu/Debian
sudo apt install fonts-powerline

# Or via Nix (add to home.nix)
home.packages = with pkgs; [ nerd-fonts.monaspace ];
```

### XClip Not Working on Ubuntu
Make sure you're running in an X11 or Wayland session with display access. For Wayland, you might need `wl-clipboard` instead.

## Benefits of This Approach

✅ **Reproducible**: Same environment across all your machines  
✅ **Isolated**: Nix packages don't conflict with Ubuntu system packages  
✅ **No sudo**: Everything installs to your home directory  
✅ **Version controlled**: Keep your entire dev environment in git  
✅ **Rollback**: Easy to revert changes with `home-manager generations`  

## Rolling Back Changes

List previous generations:
```bash
home-manager generations
```

Rollback to a previous generation:
```bash
/nix/store/xxx-home-manager-generation/activate
```

Replace `xxx` with the actual generation path from the list.

## garbage collecting

# This deletes ALL old generations and orphaned packages
nix-collect-garbage -d

# To also optimize the Nix store (deduplication)
nix-store --optimise

(less aggressive)
# Delete all old generations except the current one
home-manager expire-generations "-0 days"

# Then garbage collect
nix-collect-garbage -d

(expire)
# Or delete generations older than 30 days
home-manager expire-generations "-30 days"

# Then run garbage collection to actually free the space
nix-collect-garbage
