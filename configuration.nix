{ config, pkgs, ... }:

{
  # ============================================
  # Boot and Discs setings (btrfs)
  # ============================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

{
  # Точки монтирования
  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };
}

  # Network
  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # User
  users.users.dmitrj = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "input" ];
    shell = pkgs.bash;
  };

  # NOPASSWD
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  # LOGIN MANAGER - LY
  services.displayManager.ly.enable = true;

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # env
  environment.variables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
  };

  # System pkgs
  environment.systemPackages = with pkgs; [
    # Системные утилиты
    git
    neovim
    wget
    curl
    htop
    fastfetch
    

    # Sound (PipeWire)
    pipewire
    wireplumber
    pulsemixer
  ];

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # setings FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  hardware.enableRedistributableFirmware = true;

  # Time/Time zone
  time.timeZone = "Europe/Moscow";

  # Version nixos
  system.stateVersion = "26.05";
}
