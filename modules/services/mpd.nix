{...}: let
  althyria = "192.168.50.100";
in {
  services.mpd = {
    enable = true;
    openFirewall = true;
    settings = {
      music_directory = "/srv/multimedia/library/music";
      bind_to_address = "any";
      port = 6600;
      audio_output = [
        {
          type = "null";
          name = "This server does not need to play music.";
        }
      ];
    };
  };

  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
    exports = ''
      /srv/multimedia/library/music ${althyria}(ro,nohide,insecure,no_subtree_check)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [111 2049 4000 4001 4002 20048];
    allowedUDPPorts = [111 2049 4000 4001 4002 20048];
  };
}
