{ pkgs, ... }:
let
  pinMicBoost =
    name:
    pkgs.runCommandLocal "alsa-card-profile-${name}.conf" { } ''
      awk '/^\[Element /{ pinned = ($0 ~ /^\[Element (Internal )?Mic Boost\]$/) }
           pinned && /^volume = merge$/ { print "volume = zero"; next }
           { print }' \
        ${pkgs.pipewire}/share/alsa-card-profile/mixer/paths/${name}.conf > $out
    '';
in
{
  environment.etc = {
    "alsa-card-profile/paths/analog-input-internal-mic.conf".source =
      pinMicBoost "analog-input-internal-mic";
    "alsa-card-profile/paths/analog-input-mic.conf".source = pinMicBoost "analog-input-mic";
  };
}
