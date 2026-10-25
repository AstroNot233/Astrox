{ pkgs, ... }: {
  # Vial reaches keyboards over hidraw and tags its serial with this magic number.
  # 59-, not 99-: uaccess tags must be set before 73-seat-late applies the ACLs.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "vial-udev-rules";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
      destination = "/etc/udev/rules.d/59-vial.rules";
    })
  ];
}
