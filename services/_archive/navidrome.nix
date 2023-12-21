{ config, ... }:
{
  services.navidrome = {
    enable = true;
    settings = {
      Port = 4533;
      MusicFolder = '/mnt/music';
      DataFolder = 
    };
  };
}
