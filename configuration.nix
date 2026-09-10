{ config, pkgs, ... }:

{
  # ============================================
  # ЗАГРУЗЧИК И ДИСКИ (btrfs)
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

  # СЕТЬ
  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ПОЛЬЗОВАТЕЛЬ
  users.users.dmitrj = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "input" ];
    shell = pkgs.bash;
  };

  # sudo без пароля
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

  # СИСТЕМНЫЕ ПАКЕТЫ
  environment.systemPackages = with pkgs; [
    # Системные утилиты
    git
    neovim
    wget
    curl
    htop
    fastfetch
    

    # Звук (PipeWire)
    pipewire
    wireplumber
    pulsemixer
  ];

  # ЗВУК
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # НАСТРОЙКИ FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  hardware.enableRedistributableFirmware = true;

  # ЧАСОВОЙ ПОЯС
  time.timeZone = "Europe/Moscow";

  # ОСТАЛЬНОЕ
  system.stateVersion = "26.05";
}
