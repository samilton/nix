{ config, pkgs, ... }:

{
  time.timeZone = "America/New_York";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.sam = {
    openssh.authorizedKeys.keys = [
    ];

    isNormalUser = true;
    description = "Sam Hamilton";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  environment.systemPackages = with pkgs; [
    git # for checking out github.com/stapelberg/configfiles
    rsync
    zsh
    neovim
    (import ./emacs-config.nix {
      inherit pkgs;
    })
    wget
    curl
    rxvt-unicode # for terminfo
    btop
    dool # dstat clone
    ncdu # often useful to get a sense of data
    lsof
    psmisc # for killall
  ];

  programs.zsh.enable = true;
  services.openssh.enable = true;

  # Adding michael as trusted user means
  # we can upgrade the system via SSH (see Makefile).
  nix.settings.trusted-users = [
    "sam"
    "root"
  ];

  # Enable flakes for interactive usage.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Clean the Nix store every week.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
