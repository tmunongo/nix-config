# courtesy of ZaneyOS 
# https://gitlab.com/Zaney/zaneyos/-/blob/main/modules/nvidia-prime-drivers.nix

{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia-prime;
in
{
  options.drivers.nvidia-prime = {
    enable = mkEnableOption "Enable Nvidia Prime Hybrid GPU Offload";
    intelBusID = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
    };
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:0:2:0";
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "${cfg.intelBusID}";
        nvidiaBusId = "${cfg.nvidiaBusID}";
      };
    };
  };
}
