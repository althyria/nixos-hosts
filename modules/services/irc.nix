{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tmux
    weechat
  ];
}
