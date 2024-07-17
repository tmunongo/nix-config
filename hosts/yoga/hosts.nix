{ config, pkgs, ... }:

{ networking.extraHosts = ''

127.0.0.1 spd-mothership.local
127.0.0.1 spd-locations.local
127.0.0.1 spd-orders.local
127.0.0.1 spd-zapiet-rates.local
127.0.0.1 spd-carriers.local
127.0.0.1 dbd-mothership.local
127.0.0.1 dbz-mothership.local
127.0.0.1 partners.local
127.0.0.1 phpmyadmin.local
127.0.0.1 product-rates.local
127.0.0.1 product-options.local
127.0.0.1 eats-mothership.local
127.0.0.1 api.eats-mothership.local

127.0.0.1 scrollwize.local

'';
}
