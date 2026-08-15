{ config, lib, ... }:
let
  cfg = config.myModules.wg-clients;
in
{
  options.myModules.wg-clients = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
      options = {
        autostart = lib.mkEnableOption "Autostart a defined WireGuard interface"; 
        use_split_tunnel = lib.mkEnableOption "Only route traffic through either VPN host or local subnet";
        device_address = lib.mkOption {
          type = lib.types.str;
          description = "Device VPN address";
          example = "10.100.0.2/32";
        };
        dns = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "DNS servers to use when connected to the VPN, if left undefined will default to system default";
          example = [ "8.8.8.8" ]; 
        };
        server_public_key = lib.mkOption {
          type = lib.types.str;
          description = "VPN host public key";
        };
        split_tunnel_routes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "List of subnets to route through the VPN host";
          default = [];
          example = [ "192.168.1.0/24" "10.100.0.0/16" ];
        };
        server_endpoint = lib.mkOption {
          type = lib.types.str;
          description = "VPN host address" ;
          example = "xxx.xxx.xxx.xxx:yyyyy";
        };
      };
    }));
    default = [];
    description = "Wireguard interfaces to configure";
    example = {
      wg0 = {
        autostart = true;
        use_split_tunnel = true;
        device_address = "10.100.0.2/32";
        dns = [ "10.100.0.1" ];
        server_public_key = "example-public-key";
        split_tunnel_routes = [ "192.168.1.0/24" "10.100.0.0/16" ];
        server_endpoint = "47.69.42.137:42067";
      };
    };
  };
  config = lib.mkIf (cfg.interfaces != {}) {
    networking.wg-quick.interfaces = lib.mapAttrs' (name: iface: {
      name = name;
      value = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/etc/wireguard/keys/${name}.key";
        autostart = iface.autostart;

        dns = iface.dns;

        address = [
          iface.device_address
        ];
        peers = [
          {
            publicKey = iface.server_public_key;
            endpoint = iface.server_endpoint;
            allowedIPs = if iface.use_split_tunnel
            then iface.split_tunnel_routes
            else [
              "0.0.0.0/0"
              "::0/0"
            ];
          }
        ];
      };
    }) cfg;
  };
}