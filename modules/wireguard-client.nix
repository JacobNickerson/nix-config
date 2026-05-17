{ address, server_public_key, server_endpoint }:
{ config, lib, ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    generatePrivateKeyFile = true;
    privateKeyFile = "/etc/wireguard/keys/wg0.key";
    autostart = true;

    dns = [ 
      "1.1.1.1"
      "8.8.8.8"
    ];
    address = [
      address
    ];
    peers = [
      {
        publicKey = server_public_key;
        endpoint = server_endpoint;
        allowedIPs = [
          "192.168.5.0/24"
          "10.100.0.0/24"
        ];
        persistentKeepalive = 25;
      }
    ];
  };
}