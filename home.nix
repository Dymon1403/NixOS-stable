{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;

    alias bt="bluetoothctl"
    alias ff="fastfetch"
    alias nixup = "sudo nix flake update && sudo nixos-rebuild switch --flake .#thinkpad";
    };
  };

  # ПАКЕТЫ ДЛЯ ПОЛЬЗОВАТЕЛЯ
  home.packages = with pkgs; [
    alacritty
    firefox
    yazi
    tree
    rofi
    waybar

    # Изображения
    swayimg
    grim
    hyprshot # скриншоты (Wayland)
    slurp          # выделение области для скриншотов

    # Мультимедиа
    mpv
    ffmpeg

    # Шрифты
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # ХРАНЕНИЕ SECRETS (опционально)
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # КОНФИГИ ДЛЯ ПРОГРАММ (через home-manager)
  programs.git = {
    enable = true;
    userName = "Dymon1403";
    userEmail = "dymaroxer1403@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  # Neovim минимальный конфиг (с нуля)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };


  # ДОМАШНИЕ КАТАЛОГИ
  home.stateVersion = "26.05";
}
