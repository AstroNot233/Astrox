{ ... }: {
  backend = "webengine";
  qt.force_platform = "wayland";

  content.autoplay = false;
  content.pdfjs = true;
  content.cookies.accept = "all";
  content.javascript.enabled = true;
  content.javascript.alert = true;
  content.geolocation = "ask";
  content.notifications.enabled = "ask";
  content.headers.accept_language = "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7";
  content.headers.do_not_track = true;
  content.unknown_url_scheme_policy = "allow-from-user-interaction";

  downloads.location.directory = null;
  downloads.location.prompt = true;
  downloads.position = "top";
  downloads.remove_finished = -1;

  editor.command = [
    "ghostty"
    "-e"
    "hx"
    "{file}:{line}:{column0}"
  ];
  editor.encoding = "utf-8";
  editor.remove_file = true;

  fonts.default_family = [ "Noto Sans" ];
  fonts.default_size = "10pt";
  fonts.web.size.default = 16;
  fonts.web.size.default_fixed = 13;

  hints.auto_follow = "never";
  hints.auto_follow_timeout = 0;
  hints.chars = "abcdefghijklmnopqrstuvwxyz";
  hints.min_chars = 1;
  hints.scatter = true;

  input.forward_unbound_keys = "auto";
  input.insert_mode.auto_enter = true;
  input.insert_mode.auto_leave = true;
  input.mouse.back_forward_buttons = true;
  input.partial_timeout = 0;

  auto_save.session = false;
  confirm_quit = [ "never" ];
  session.lazy_restore = false;
  tabs.background = true;
  tabs.favicons.show = "always";
  tabs.last_close = "ignore";
  tabs.new_position.related = "next";
  tabs.new_position.unrelated = "last";
  tabs.position = "top";
  tabs.select_on_remove = "next";
  tabs.show = "always";
  tabs.wrap = true;

  scrolling.bar = "overlay";
  scrolling.smooth = false;
  statusbar.show = "always";
  statusbar.position = "bottom";
  statusbar.widgets = [
    "keypress"
    "search_match"
    "url"
    "scroll"
    "history"
    "tabs"
    "progress"
  ];

  url.auto_search = "naive";
  url.default_page = "www.bing.com";
  url.open_base_url = false;
  url.start_pages = [ "www.bing.com" ];
  url.yank_ignored_parameters = [
    "ref"
    "utm_source"
    "utm_medium"
    "utm_campaign"
    "utm_term"
    "utm_content"
    "utm_name"
  ];

  window.title_format = "{current_title}{title_sep}qutebrowser";
}
