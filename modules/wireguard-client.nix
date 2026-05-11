{ address }:
{ config, ... }:
let
  server_public_key = "dH6/8lXlvxUIbpvdimb6iVr0A+3iwP1PywxAxeRx5wQ=";
  server_endpoint = "192.168.122.134:42167";
in
{
  networking.wg-quick.interfaces.wg0 = {
    generatePrivateKeyFile = true;
    privateKeyFile = "/etc/wireguard/keys/wg0.key";

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