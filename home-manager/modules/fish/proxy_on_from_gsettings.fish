set mode (string replace -a "'" "" (gsettings get org.gnome.system.proxy mode))
if test "$mode" = manual
    for protocol in http ftp socks
        set host (string replace -a "'" "" (gsettings get org.gnome.system.proxy.$protocol host))
        set port (string replace -a "'" "" (gsettings get org.gnome.system.proxy.$protocol port))
        if test -n "$host"
            set -gx {$protocol}_proxy "$protocol://$host:$port"
            set -gx (string upper $protocol)_PROXY $proxy
        end
    end
    set host (string replace -a "'" "" (gsettings get org.gnome.system.proxy.https host))
    set port (string replace -a "'" "" (gsettings get org.gnome.system.proxy.https port))
    if test -n "$host"
        set -gx https_proxy "http://$host:$port"
        set -gx HTTPS_PROXY $https_proxy
    end
    set ignore_hosts (gsettings get org.gnome.system.proxy ignore-hosts)
    if test -n "$ignore_hosts" -a "$ignore_hosts" != "[]"
        set ignore_hosts (string sub -s 2 -e -1 $ignore_hosts)  # 去掉 `[` 和 `]`
        set ignore_hosts (string replace -a ' ' '' $ignore_hosts)  # 去掉空格
        set ignore_hosts (string replace -a "'" "" $ignore_hosts)  # 去掉单引号
        set -gx no_proxy $ignore_hosts
        set -gx NO_PROXY $ignore_hosts
    end
end
if test (gsettings get org.gnome.system.proxy.http use-authentication) = true
    set -ge http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
end
