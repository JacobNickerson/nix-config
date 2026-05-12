{ address, server_public_key, server_endpoint }:
{ config, lib, ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    generatePrivateKeyFile = true;
    privateKeyFile = "/etc/wireguard/keys/wg0.key";
    autostart = false;

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
          "0.0.0.0/0"
          "::/0"
        ];
        persistentKeepalive = 25;
      }
    ];
  };
}