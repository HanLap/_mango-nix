# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

with builtins;
with (import <nixpkgs> {}).lib;
let
  filterNix = list : filter (hasSuffix ".nix") list;

  nixFilesIn = dir: filterNix (map (name: "${dir}/${name}")
                                   (attrNames (readDir dir)));
in
{
  imports =
      [
        ./hardware-configuration.nix
        <nix-ld/modules/nix-ld.nix>
    #       <home-manager/nixos>
      ]
      ++ (nixFilesIn ./modules);



  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;



  # Set your time zone.
  time.timeZone = "Europe/Berlin";


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      defaultSession = "none+awesome";
      sddm.enable = false;
      gdm.enable = false;
      lightdm.enable = true;
    };

    desktopManager = {
      xterm.enable = false;
      plasma5.enable = false;
      gnome.enable = false;
      xfce = {
        enable = false;
        noDesktop = false;
        enableXfwm = true;
      };
    };

    windowManager = {
      awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks
        ];
      };
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages : [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
        ];
      };

    };

    layout = "us";
    xkbModel = "pc104";
    xkbVariant = "";
    xkbOptions = "compose:ralt";

    wacom.enable = true;
  };

  # environment.gnome.excludePackages = [
  #   pkgs.gnome.cheese
  #   pkgs.gnome-photos
  #   pkgs.gnome.gnome-music
  #   pkgs.gnome.gedit
  #   pkgs.epiphany
  #   pkgs.evince
  #   pkgs.gnome.gnome-characters
  #   pkgs.gnome.totem
  #   pkgs.gnome.tali
  #   pkgs.gnome.iagno
  #   pkgs.gnome.hitori
  #   pkgs.gnome.atomix
  #   pkgs.gnome-tour
  # ];


  virtualisation.docker.enable = true;


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  hardware.bluetooth.enable = true;

  hardware.opengl.extraPackages = [
    pkgs.intel-compute-runtime
  ];

  hardware.openrazer.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hannah = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "dialout" ];
  };

  # home-manager.users.hannah = { pkgs, ... }: {
    # home.packages = [ pkgs.atool pkgs.httpie ];
  #   programs.bash.enable = false;
  # };
  # home-manager.useUserPackages = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpilight
    autorandr
    bitwarden
    bitwarden-cli
    deno
    discord
    docker-compose
    dropbox
    file
    firefox
    fish
    fuse
    git
    github-cli
    glances
    htop
    i3lock-color
    icu
    imagemagick
    iw
    killall
    kitty
    man-pages
    man-pages-posix
    neofetch
    nix-index
    nodejs
    pamixer
    pavucontrol
    picom
    pciutils
    python310
    redshift
    rofi
    signal-desktop
    thunderbird
    tree
    unzip
    usbutils
    vscode-fhs
    wget
    xclip
    zip
    zoom-us
  ];

  fonts.fonts = with pkgs; [ fira-code fira-code-symbols ];

  programs.light.enable = true;
  programs.steam.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;

    logind.extraConfig = ''
        # don’t shutdown when power button is short-pressed
        HandlePowerKey=ignore
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
