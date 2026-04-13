function iphone_release_countdown --description "Show the predicted next iPhone release date"
    if test (uname) != Darwin
        echo "iphone_release_countdown requires macOS/BSD date."
        return 1
    end

    set -l accent_hex fab387
    switch "$fish_terminal_color_theme"
        case light
            set accent_hex fe640b
    end

    set -l use_color 0
    if isatty stdout
        set use_color 1
    end

    set -l today_date (date "+%Y-%m-%d")
    set -l today_year (date "+%Y")
    # Parse both dates at UTC noon so the countdown stays on calendar days.
    set -l today_epoch (env TZ=UTC date -j -f "%Y-%m-%d %H:%M:%S" "$today_date 12:00:00" "+%s")
    set -l release_year $today_year
    set -l release_date
    set -l release_epoch

    while true
        set -l september_first "$release_year-09-01"
        set -l september_first_weekday (env TZ=UTC date -j -f "%Y-%m-%d %H:%M:%S" "$september_first 12:00:00" "+%w")
        set -l first_friday_offset (math "(5 - $september_first_weekday + 7) % 7")
        set -l third_friday_day (math "1 + $first_friday_offset + 14")
        set release_date "$release_year-09-"(string pad -w 2 -c 0 "$third_friday_day")
        set release_epoch (env TZ=UTC date -j -f "%Y-%m-%d %H:%M:%S" "$release_date 12:00:00" "+%s")

        if test $today_epoch -le $release_epoch
            break
        end

        set release_year (math "$release_year + 1")
    end

    set -l days_left (math "($release_epoch - $today_epoch) / 86400")
    set -l countdown_cursor $today_date
    set -l months_left 0

    while true
        set -l next_month_date (env TZ=UTC date -j -v+1m -f "%Y-%m-%d" "$countdown_cursor" "+%Y-%m-%d")
        set -l next_month_epoch (env TZ=UTC date -j -f "%Y-%m-%d %H:%M:%S" "$next_month_date 12:00:00" "+%s")

        if test $next_month_epoch -gt $release_epoch
            break
        end

        set countdown_cursor $next_month_date
        set months_left (math "$months_left + 1")
    end

    set -l countdown_cursor_epoch (env TZ=UTC date -j -f "%Y-%m-%d %H:%M:%S" "$countdown_cursor 12:00:00" "+%s")
    set -l breakdown_days (math "($release_epoch - $countdown_cursor_epoch) / 86400")
    set -l months_label months
    set -l breakdown_days_label days

    if test $months_left -eq 1
        set months_label month
    end

    if test $breakdown_days -eq 1
        set breakdown_days_label day
    end

    set -l today_pretty (date -j -f "%Y-%m-%d" "$today_date" "+%d %B %Y")
    set -l release_pretty (date -j -f "%Y-%m-%d" "$release_date" "+%A, %d %B %Y")

    echo "Today: $today_pretty"
    printf 'Predicted iPhone release date: '
    if test $use_color -eq 1
        set_color "$accent_hex"
    end
    echo "$release_pretty"
    if test $use_color -eq 1
        set_color normal
    end

    switch "$days_left"
        case 0
            echo "Today is the predicted release day."
        case 1
            if test $use_color -eq 1
                set_color "$accent_hex"
            end
            printf '1'
            if test $use_color -eq 1
                set_color normal
            end
            printf ' day left (%s %s, %s %s).\n' "$months_left" "$months_label" "$breakdown_days" "$breakdown_days_label"
        case '*'
            if test $use_color -eq 1
                set_color "$accent_hex"
            end
            printf '%s' "$days_left"
            if test $use_color -eq 1
                set_color normal
            end
            printf ' days left (%s %s, %s %s).\n' "$months_left" "$months_label" "$breakdown_days" "$breakdown_days_label"
    end
end
