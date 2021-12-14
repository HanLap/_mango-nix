{ ... }:

{
  networking = {
    hostName = "carrot"; # Define your hostname.


    useDHCP = false;
    interfaces.wlp2s0.useDHCP = true;

    networkmanager.enable = true;

    wireless = {
      enable = false;  # Enables wireless support via wpa_supplicant.

      networks = {
        "send nudes" = {
          psk = "( . Y . )";
        };
        "wlan-369469" = {
          psk = "SP-399469699769999";
        };
        eduroam = {
          extraConfig = ''
            key_mgmt=WPA-EAP
            pairwise=CCMP
            group=CCMP TKIP
            eap=TTLS
            ca_cert="/etc/eduroam.pem"
            identity="hannah.lappe@uni-ulm.de"
            altsubject_match="DNS:radius.uni-ulm.de"
            phase2="auth=PAP"
            password="gB6GWZLn"
            anonymous_identity="anonymous.PKIv2@uni-ulm.de"
          '';
        };
      };
    };

  };
}
