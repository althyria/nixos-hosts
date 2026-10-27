{...}: {
  age.secrets = {
    paperless-admin = {
      rekeyFile = ./paperless-admin.age;
    };
    paperless-env = {
      rekeyFile = ./paperless-env.age;
    };
  };
}
