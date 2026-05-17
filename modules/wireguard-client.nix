{ config, lib, ... }:
let
  cfg = config.myModules.wg-client;
in
{
  options.myModules.wg-client = {
    enable = lib.mkEnableOption "Enable a systemd managed wireguard quick interface for connecting to a Wireguard vpn";
    address = lib.mkOption {
      type = lib.types.str;
      description = "Device VPN address";
    };
    server_public_key = lib.mkOption {
      type = lib.types.str;
      description = "VPN host public key";
    };
    server_endpoint = lib.mkOption {
      type = lib.types.str;
      description = "VPN host address";
    };
    use_split_tunnel = lib.mkOption {
      type = lib.types.bool;
      description = "Use a split tunnel instead of a full tunnel";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0 = {
      generatePrivateKeyFile = true;
      privateKeyFile = "/etc/wireguard/keys/wg0.key";
      autostart = true;

      dns = [ 
        "1.1.1.1"
        "8.8.8.8"
      ];
      address = [
        cfg.address
      ];
      peers = [
        {
          publicKey = cfg.server_public_key;
          endpoint = cfg.server_endpoint;
          allowedIPs = if cfg.use_split_tunnel
          then [
            "192.168.5.0/24"
            "10.100.0.0/24"
          ] else [
            "0.0.0.0/0"
            "::0/0"
          ];
        }
      ];
    };
  };
}