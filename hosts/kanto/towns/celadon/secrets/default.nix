{...}: {
  age.secrets = {
    borgmatic = {
      rekeyFile = ./celadon-borg.age;
      path = "/etc/borgmatic/celadon.txt";
    };

    rclone-mount-conf = {
      rekeyFile = ./rclone-mount.age;
      path = "/etc/rclone-mount.conf";
    };
  };
}
