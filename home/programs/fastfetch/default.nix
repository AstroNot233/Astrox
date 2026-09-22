{ assets, ... }: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "kitty-direct";
        source = assets."NixOS.png";
        padding = {
          left = 1;
          right = 1;
        };
        position = "right";
        height = 25;
        width = 64;
      };
      display = {
        stat = false;
        showErrors = false;
        disableLinewrap = true;
        separator = " | ";
        key = {
          type = "icon";
          paddingLeft = 2;
        };
        common = {
          ndigits = 2;
          spaceBeforeUnit = "never";
        };
        size.binaryPrefix = "iec";
        temp.unit = "K";
        duration.abbreviation = true;
        percent.type = 3;
        constants = [
          "────────────────"
        ];
        color = {
          keys = "default";
          title = "bright_yellow";
          output = "default";
          separator = "bright_black";
        };
        bar = {
          width = 16;
          char = {
            elapsed = "━";
            total = "╌";
          };
        };
      };
      modules = [
        {
          type = "custom";
          format = "╭─{$1} {#1;94}Hardware{#} {$1}─╮";
        }
        {
          type = "host";
          keyColor = "blue";
        }
        {
          type = "cpu";
          keyColor = "blue";
        }
        {
          type = "gpu";
          keyColor = "blue";
        }
        {
          type = "memory";
          keyColor = "blue";
        }
        {
          type = "swap";
          keyColor = "blue";
        }
        {
          type = "disk";
          keyColor = "blue";
        }
        {
          type = "battery";
          keyColor = "blue";
        }
        {
          type = "display";
          keyColor = "blue";
        }
        {
          type = "bluetooth";
          keyColor = "blue";
        }
        {
          type = "uptime";
          keyColor = "blue";
        }

        {
          type = "custom";
          format = "╭─{$1} {#1;96}Software{#} {$1}─╮";
        }
        {
          type = "title";
          key = "Title";
          keyIcon = "";
          keyColor = "cyan";
        }
        {
          type = "os";
          keyColor = "cyan";
        }
        {
          type = "kernel";
          keyColor = "cyan";
        }
        {
          type = "locale";
          keyColor = "cyan";
        }
        {
          type = "lm";
          keyColor = "cyan";
        }
        {
          type = "de";
          keyColor = "cyan";
        }
        {
          type = "wm";
          keyColor = "cyan";
        }
        {
          type = "shell";
          keyColor = "cyan";
        }
        {
          type = "terminal";
          keyColor = "cyan";
        }
        {
          type = "terminalfont";
          keyColor = "cyan";
        }
        {
          type = "packages";
          keyColor = "cyan";
        }

        {
          type = "custom";
          format = "╭─{$1} {#1;92}Internet{#} {$1}─╮";
        }
        {
          type = "localip";
          compact = true;
          keyColor = "green";
        }
        {
          type = "publicip";
          timeout = 1000;
          keyColor = "green";
        }
        {
          type = "wifi";
          format = "{ssid}";
          keyColor = "green";
        }
        {
          type = "custom";
          format = "╭{$1}{#1;95} 󰏘 Colors 󰏘 {#}{$1}╮";
        }
        {
          type = "colors";
          paddingLeft = 11;
          symbol = "background";
        }
        {
          type = "custom";
          format = "           {#1}{##C10100}████{##FF6705}████{##FDB00B}████{##029B3B}████{##0088CC}████{##5A37BB}████{##FFFFFF}{#}";
        }
        {
          type = "custom";
          format = "╰{$1}─{#1}──────────{#}─{$1}╯";
        }
      ];
    };
  };
}
