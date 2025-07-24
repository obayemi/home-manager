{ config, pkgs, ... }: {
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "standalone";
        profile.outputs = [{
          criteria = "eDP-1";
          status = "enable";
          scale = 1.175;
          mode = "2256x1504";
        }];
      }
      {
        profile.name = "cinema";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Panasonic Industry Company Panasonic-PJ 0x01010101";
            status = "enable";
            mode = "1920x1080";
            scale = 1.5;
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "work";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.333333;
            mode = "2256x1504";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2518D 3C4YP95TBJ5L";
            status = "enable";
            mode = "2560x1440";
            position = "1693,0";
          }
          {
            criteria = "Dell Inc. DELL U2518D 3C4YP95TBQ5L";
            status = "enable";
            mode = "2560x1440";
            position = "4253,0";
          }
        ];
      }
      {
        profile.name = "centaurus";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.333333;
            mode = "2256x1504";
            position = "0,0";
          }
          {
            criteria = "XMD Mi TV 0x00000001";
            status = "enable";
            scale = 2.0;
            mode = "3840x2160";
            position = "1693,0";
          }
        ];
      }
      {
        profile.name = "phenix";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.333333;
            mode = "2256x1504";
            position = "0,0";
          }
          {
            criteria =
              "Philips Consumer Electronics Company Philips FTV 0x01010101";
            status = "enable";
            scale = 2.0;
            mode = "3840x2160";
            position = "1693,0";
          }
        ];
      }
      {
        profile.name = "jeremy";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.333333;
            mode = "2256x1504";
            position = "1000,1080";
          }
          {
            criteria = "Samsung Electric Company LF24T450F HK7X301589";
            status = "enable";
            mode = "1920x1080";
            position = "0,0";
          }
          {
            criteria = "Samsung Electric Company LF24T450F HK7W701209";
            status = "enable";
            mode = "1920x1080";
            position = "1920,0";
          }
        ];
      }
      #   profile lan {
      #     output 'AOC AG241QG4 0x00000151' enable position 0,0 mode 2560x1440
      #     output eDP-1 scale 1.2 position 2560,0 mode 2256x1504
      #   }
    ];
  };
}
