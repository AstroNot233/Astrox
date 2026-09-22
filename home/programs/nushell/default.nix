{ ... }: {
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    environmentVariables = {};
    loginFile.source = null;
    plugins = [];
    settings = {
      history                          = {
        file_format                      = "plaintext";
        max_size                         = 65536;
        sync_on_enter                    = true;
        isolation                        = false;
#       path                             = "";
        ignore_space_prefixed            = true;
                                       };

      show_banner                      = false;
      rm.always_trash                  = false;
      recursion_limit                  = 64;
#     max_last_result_size             = 512b;
      auto_cd_implicit                 = false;

      clip                             = {
        resident_mode                    = true;
        default_raw                      = false;
                                       };

      edit_mode                        = "emacs";
      buffer_editor                    = "hx";
      cursor_shape                     = {
        emacs                            = "inherit";
        vi_insert                        = "inherit";
        vi_normal                        = "inherit";
        helix_normal                     = "inherit";
        helix_select                     = "inherit";
        helix_insert                     = "inherit";
                                       };

      show_hints                       = true;
#     hinter.closure                   = null;
      completions                      = {
        algorithm                        = "substring";
        sort                             = "smart";
        case_sensitive                   = false;
        quick                            = true;
        partial                          = true;
        use_ls_colors                    = true;
        cache_size                       = 128;
        external                         = {
          enable                           = true;
          max_results                      = 128;
#         completer                        = null;
                                         };
                                       };

      use_kitty_protocol               = true;
      shell_integration                = {
        osc2                             = true;
        osc7                             = true;
        osc8                             = true;
        osc9_9                           = false;
        osc133                           = true;
        osc633                           = true;
        reset_application_mode           = true;
                                       };
      bracketed_paste                  = true;
      use_ansi_coloring                = "auto";

      error_style                      = "fancy";
      display_errors                   = {
        exit_code                        = true;
        termination_signal               = true;
                                       };
      error_lines                      = 1;

      footer_mode                      = "always";
      filesize                         = {
        unit                             = "binary";
        show_unit                        = true;
        precision                        = 2;
                                       };
      render_right_prompt_on_last_line = false;
      float_precision                  = 2;
      duration_max_unit                = "day";
      ls                               = {
        use_ls_colors                    = true;
        clickable_links                  = true;
                                       };
#     hooks                            = {};
    };

    shellAliases = {
      "ff" = "fastfetch";
    };
  };
}
