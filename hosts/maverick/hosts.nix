{ config, pkgs, ... }:

{ networking.extraHosts = ''

127.0.0.1 scrollwize.local
127.0.0.1 localhost nextcloud.sslwarp.local

'';
}
