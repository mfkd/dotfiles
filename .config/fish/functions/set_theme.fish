function set_theme
    # Only run this on macOS
    if test (uname) != "Darwin"
        return
    end

    set appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)
    if test "$appearance" = "Dark"
        dark
    else
        light
    end
end
