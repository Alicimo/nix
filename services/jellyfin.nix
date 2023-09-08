{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ 
      intel-media-driver 
      jellyfin-ffmpeg
    ];
  };

  # 2. do not forget to enable jellyfin
  services.jellyfin.enable = true; 
}
