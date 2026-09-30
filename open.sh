# Optional desktop opening helpers, sourced from ~/.bashrc.
# shellcheck shell=bash

# --- Files, folders and URLs ------------------------------------------------
# open: send each target to the right application, in sequence.
#   open index.html ~/Downloads note.pdf https://example.com
#
# Folders go to the file manager, text files to $EDITOR in this terminal, and
# everything else through xdg-open. A function rather than an alias so that
# several targets can be passed at once and these three cases separated.
open() {
    if [ "$#" -eq 0 ]; then
        printf 'usage: open <file|folder|url> ...\n' >&2
        return 2
    fi
    local target status=0 filetype
    for target in "$@"; do
        # xdg-open on a directory execs the file manager in the foreground: it
        # floods the terminal with GTK warnings and blocks. Worse, Nautilus only
        # forks and returns when its daemon is already running; on a cold start
        # it stays in the foreground for ~15s. Launch it fully detached instead.
        if [ -d "$target" ]; then
            explore "$target" || status=1
            continue
        fi
        filetype="$(xdg-mime query filetype "$target" 2>/dev/null)"
        # An .html that sniffs as text/plain (a fragment with no <html> tag)
        # should still open in a browser. gio launch is the stock way to force
        # an association; it returns immediately, so no & or setsid is needed.
        # Guarded on the entry existing: naming a desktop file that is not on
        # disk is silently dropped by GLib, which fails quietly and confusingly.
        case "$target" in
            *.html | *.htm | *.xhtml)
                if [ "$filetype" = "text/plain" ] &&
                    [ -r "$HOME/.local/share/applications/chromium-noctalia.desktop" ]; then
                    gio launch "$HOME/.local/share/applications/chromium-noctalia.desktop" \
                        "$target" >/dev/null 2>&1 || status=1
                    continue
                fi
                ;;
        esac
        # Types with a real GUI application go to it, not to $EDITOR. text/html
        # is the important one: a complete .html file is text/html and must
        # reach the browser, while text/plain is what a fragment or a plain text
        # file sniffs as. Do not blanket-match text/*, or full .html files end up
        # in the editor.
        case "$filetype" in
            text/html | text/xml | application/pdf | image/* | audio/* | video/*)
                xdg-open "$target" || status=1
                continue
                ;;
        esac
        # Everything else text-like goes to $EDITOR in this terminal. Not via
        # xdg-open: the handler there is whatever claims the type, which ignores
        # $EDITOR, and a Terminal=true handler such as nvim.desktop core-dumps
        # when launched that way. Foreground also means several targets run in
        # sequence and the last one keeps the terminal.
        case "$filetype" in
            text/* | application/x-shellscript | application/json | application/x-perl | application/x-python | application/x-ruby)
                if [ -z "${EDITOR:-}" ]; then
                    printf 'open: EDITOR is not set\n' >&2
                    status=1
                else
                    "$EDITOR" "$target" || status=1
                fi
                continue
                ;;
        esac
        xdg-open "$target" || status=1
    done
    return "$status"
}

# Open a directory with the configured desktop handler.
explore() {
    local target="${1:-$PWD}"
    if [ -n "${DOTFILES_FILE_MANAGER:-}" ]; then
        "$DOTFILES_FILE_MANAGER" "$target"
    elif command -v nautilus >/dev/null 2>&1 && command -v setsid >/dev/null 2>&1; then
        setsid -f nautilus --new-window "$target" 2>/dev/null < /dev/null
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$target"
    else
        printf 'explore: set DOTFILES_FILE_MANAGER or install xdg-open\n' >&2
        return 127
    fi
}
