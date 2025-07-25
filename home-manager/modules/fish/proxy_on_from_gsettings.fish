function clean
    string replace -a "'" "" $argv | string replace -a " " "" | string replace -a "[" "" | string replace -a "]" ""
end

function set_proxy_for
    set protocol $argv[1]
    set host (gsettings get org.gnome.system.proxy.$protocol host | clean)
    set port (gsettings get org.gnome.system.proxy.$protocol port | clean)
    if test -n "$host"
        set -gx ${protocol}_proxy "$protocol://$host:$port"
        set -gx (string upper $protocol)_PROXY "$protocol://$host:$port"
    end
end

set mode (gsettings get org.gnome.system.proxy mode | clean)

if test "$mode" = "manual"
    for p in http ftp socks
        set_proxy_for $p
    end

    set host (gsettings get org.gnome.system.proxy.https host | clean)
    set port (gsettings get org.gnome.system.proxy.https port | clean)
    if test -n "$host"
        set -gx https_proxy "http://$host:$port"
        set -gx HTTPS_PROXY "http://$host:$port"
    end

    set raw_ignore (gsettings get org.gnome.system.proxy ignore-hosts)
    if test -n "$raw_ignore" -a "$raw_ignore" != "[]"
        set ignore (echo $raw_ignore | clean | string split ",")
        set ignore_hosts (string join , $ignore)
        set -gx no_proxy $ignore_hosts
        set -gx NO_PROXY $ignore_hosts
    end
end

if test (gsettings get org.gnome.system.proxy.http use-authentication) = "true"
    set -ge http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
end
