# Appended verbatim to the generated config.py, i.e. after every c.aliases[...]
# the home-manager module emits. Appending the alias file instead of dropping it
# into the repository directory keeps the removal below last, so the built-in
# qa/wq/wqa do not come back.

# Aliases that are no longer wanted. c.aliases arrives with the upstream table
# (q/w/qa/wq/wqa), so "overriding" q and w only means assigning them again in
# default.nix -- deleting needs an explicit pop.
for _name in ("qa", "wq", "wqa"):
    c.aliases.pop(_name, None)


# Focusing an element with role=textbox / role=combobox that is not an <input>
# or <textarea> -- ARIA "edit boxes" built from a <div contenteditable>, as used
# by WhatsApp Web, Slack, Gemini, Twitch, Yandex Translate -- raises
#
#     ERROR: JS: [userscript:_qute_js:477] Uncaught TypeError:
#     Cannot read properties of undefined (reading 'length')
#
# Upstream: https://github.com/qutebrowser/qutebrowser/issues/7846 (open since
# 2023, reported as cosmetic). The traceback is
#   WebEngineElement.click -> _click_editable -> _move_text_cursor
#   -> webelem.js move_cursor_to_end -> elem.value.length
# and it fires because _move_text_cursor only checks is_text_input(), which
# accepts the ARIA roles, while webelem.js forces such an element's value to ""
# (it only keeps strings and numbers), leaving move_cursor_to_end to read
# `.length` off the real DOM property, which is undefined there.
#
# The deserialized dict cannot tell the two apart: an empty <input> also arrives
# as value="". caret_position -- the element's own selectionStart -- does
# distinguish them, because only form fields that support the selection API
# report a number, so gate the cursor move on that.
from qutebrowser.browser.webengine.webengineelem import WebEngineElement
from qutebrowser.misc import objects


def _safe_move_text_cursor(self):
    if (
        self.is_text_input()
        and self.is_editable()
        and isinstance(self.caret_position(), int)
    ):
        self._js_call("move_cursor_to_end")


try:
    # At config load time objects.backend is still NoBackend(), a sentinel that
    # raises AssertionError on any attribute access -- it is neither None nor
    # Backend.QtWebEngine, so a plain identity check would skip the patch.
    _is_webengine = objects.backend.name == "QtWebEngine"
except AssertionError:
    _is_webengine = True  # not selected yet; webengine is the packaged backend
if _is_webengine:
    WebEngineElement._move_text_cursor = _safe_move_text_cursor

