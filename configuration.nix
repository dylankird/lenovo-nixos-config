# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


# Todo:
# Add aliases (one that's great is alias nix-shell-unfree='NIXPKGS_ALLOW_UNFREE=1 nix-shell')
# Add vimrc
# create multi system config
# set up vscode
# set up stm32cubeide
# gaming mode script
# transparent blur
# make ctrl+shift+esc open resources
# fix the print screen button
# remap the copilot button
# maybe remap the home, end, pg up, pg down buttons
# fix the speakers
# update the install instructions from your surface book 2
# fix the touchscreen
# add lspci as well as other basic terminal programs and add gpu related tools like 
# set up easyeffects: https://mynixos.com/home-manager/options/services.easyeffects
# set up syncthing
# find ssh config from old machine
# Lower scroll speed for touchpad



{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Add flakes:
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "lenovo-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    #LC_TIME = "en_US.UTF-8";
    # Set the date/time format locale to Ireland to get Monday as the first day of the week
    LC_TIME="en_IE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

# Modern NixOS uses hardware.graphics (was hardware.opengl before 24.11)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # helpful for Steam/proton
  };

  services.xserver.videoDrivers = [
    "modesetting"  # Intel iGPU side for PRIME
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;

    # For newer GPUs you must choose open vs proprietary kernel modules.
    # RTX 50-series/Blackwell requires the open kernel modules.
    open = true;  # important for this generation :contentReference[oaicite:1]{index=1}

    nvidiaSettings = true;

    powerManagement = {
      enable = true;
      finegrained = true; # lets the dGPU fully power down when idle (when supported)
    };

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true; # gives you `nvidia-offload` :contentReference[oaicite:2]{index=2}

      intelBusId = "PCI:0:2:0";   # <-- replace with yours
      nvidiaBusId = "PCI:1:0:0";  # <-- replace with yours
    };
  };

 
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan Kirdahy";
    extraGroups = [ "networkmanager" "wheel" "plugdev" "input" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# Added this in hopes that it fixes easyeffects missing gtk file chooser
programs.dconf.enable = true;


  # For my razer mouse:
  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["dylan"];

  # Stuff for KVM so I can used GNOME boxes
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["dylan"];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };


    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

  # Terminal programs
  vim
  btop
  git
  syncthing
  neofetch
  appimage-run # appimage-run program-name.appimage
  steam-run # steam-run ./program-name.appimage
  distrobox 
    # Notes (desktop):
	# Ran distrobox create --root --name archlinux --init --image archlinux:latest
	# To enter: Run distrobox enter --root archlinux
  joycond-cemuhook # Make sure you run this as root
  usbutils
  pciutils
  claude-code
  nmap
  python3

  # GUI programs	
  thunderbird
  signal-desktop
  gnome-tweaks
  joplin-desktop
  protonmail-bridge-gui
  errands
  freecad-wayland
  freetube
  tidal-hifi
  spotify
  exhibit
  kicad
  iotas
  gnome-extension-manager
  fragments
  resources
  boxes
  protonvpn-gui
  brave
  steam
  vlc
  warp
  xournalpp
  discord
  telegram-desktop
  onlyoffice-desktopeditors
  inkscape
  arduino-ide
  rednotebook
  prusa-slicer
  ryubing
  impression
  dolphin-emu
  razergenie
  vscode-fhs
  rpi-imager

  # Gaming
  # sm64ex


  # Appearance
  adw-gtk3

  # Audio
  alsa-utils
  alsa-tools
  pavucontrol
  easyeffects

  # Supporting packages
  nautilus-python # Allows for integration with nautilus - for instance nextcloud

  # GNOME Extensions
  gnomeExtensions.panel-corners
  gnomeExtensions.weather-or-not
  gnomeExtensions.blur-my-shell
  gnomeExtensions.hot-edge
  gnomeExtensions.gsconnect
  gnomeExtensions.astra-monitor
  gnomeExtensions.night-theme-switcher
  # Use gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3" to switch to light
  # Use gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark" to switch to dark
  gnomeExtensions.adw-gtk3-colorizer
  gnomeExtensions.grand-theft-focus
  gnomeExtensions.light-style
  gnomeExtensions.accent-directories
  gnomeExtensions.caffeine
  gnomeExtensions.tiling-assistant
  gnomeExtensions.battery-indicator-icon
  gnomeExtensions.battery-time-2
  gnomeExtensions.hide-top-bar
  gnomeExtensions.shaderpaper-gnome

  # These packages are for the shaderpaper extension:
  gtksourceview5
  gtksourceview4
  ];

  # For the shaderpaper extension:
  environment.sessionVariables.GI_TYPELIB_PATH =
    lib.makeSearchPath "lib/girepository-1.0" [
      pkgs.gtksourceview5
      pkgs.gtksourceview4
    ];



  # Enable input-remapper (not necessary on laptop)
  #services.input-remapper.enable = true;
	# Mapped the Pause/Break key on keyboard (Barcode Scanner) to KEY_PLAYPAUSE

  home-manager.users.dylan = { pkgs, ... }: {
    home.packages = [ 
    ];

    programs.bash.enable = true;

  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;


  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "Default";
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          # see: https://github.com/nix-community/nur-combined/blob/2691dd44ce8664be1d33f61ed808aca7de38a82f/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
          darkreader
          ublock-origin
          bitwarden
	];
      };
    };
  };



  # Switch Caps Lock and escape keys
dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # Swap Caps Lock and Escape
      xkb-options = [ "caps:swapescape" ];
    };
  };

  # Add keyboard shortcut for terminal
dconf.settings = {
    # Register the custom keybinding path
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/open-kgx/"
      ];

      # (Optional) clear any distro default for "terminal" to avoid conflicts
      terminal = [ ];
    };

    # Define the binding itself
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/open-kgx" = {
      name = "Open Terminal (kgx)";
      command = "kgx";              # or "kgx --new-window"
      binding = "<Primary><Alt>t";  # Ctrl+Alt+T
    };

	"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/open-firefox" = {
      name = "Open Firefox";
      command = "firefox";                # Flatpak? use: "flatpak run org.mozilla.firefox"
      binding = "<Primary><Alt>f";        # Ctrl+Alt+F
    };
  };

  # Add proper fractional scaling
  dconf.settings = {
    "org/gnome/mutter" = {
      # Enables Wayland fractional scaling in Displays (125%, 150%, 175%…)
      # and keeps XWayland apps sharp under fractional scales.
      experimental-features = [
        # Let's see how regular scaling works first
        #"scale-monitor-framebuffer"
        #"xwayland-native-scaling"
        "variable-refresh-rate"
      ];
    };

	"org/gnome/desktop/wm/keybindings" = {
      # Disable the app-level switcher
      "switch-applications" = [ ];
      "switch-applications-backward" = [ ];

      # Make Alt-Tab switch windows instead
      "switch-windows" = [ "<Alt>Tab" ];
      "switch-windows-backward" = [ "<Shift><Alt>Tab" ];
    };
  };
 
  # This value determines the Home Manager release that your configuration is 
  # compatible with. This helps avoid breakage when a new Home Manager release 
  # introduces backwards incompatible changes. 
  #
  # You should not change this value, even if you update Home Manager. If you do 
  # want to update the value, then make sure to first check the Home Manager 
  # release notes. 
  home.stateVersion = "25.11"; # Please read the comment before changing. 
};


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # This block is for allowing KDE Connect
  networking.firewall = {
  enable = true;  # usually true by default
  allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
};

# Added this to try to get the switch2 pro controller working
hardware.steam-hardware.enable = true;
services.udev.extraRules = ''
SUBSYSTEM=="usb", ATTR{idVendor}=="057e", ATTR{idProduct}=="2066", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="057e", ATTR{idProduct}=="2067", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="057e", ATTR{idProduct}=="2069", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="057e", ATTR{idProduct}=="2073", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2066", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2067", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2069", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2073", MODE="0666"
  '';





  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
