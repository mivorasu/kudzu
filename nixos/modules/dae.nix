{ ... }:
{
  services.dae = {
    enable = true;
    # subscription can be a url return the subscription, or a file path that contains the subscription.
    # the subscription config is something like:
    #   ```
    #   subscription {
    #     'https://www.example.com/subscription/link'
    #   }
    #   node {
    #     node_a: 'vless://'
    #   }
    #   ```
    config = ''
      include {
        extra-config.dae
      }
      global {
        wan_interface: auto
        log_level: info
        auto_config_kernel_parameter: true
        check_tolerance: 60ms
        check_interval: 600s
        allow_insecure: false
        tls_implementation: utls
        utls_imitate: chrome_auto
        enable_local_tcp_fast_redirect: true
        mptcp: true
        dial_mode: ip
      }
      dns {
        upstream {
          googledns: 'tcp+udp://dns.google:53'
          cloudflaredns: 'tcp+udp://one.one.one.one:53'
        }
        routing {
          request {
            qtype(https) -> reject
            fallback: googledns
          }
          response {
            upstream(cloudflaredns) -> accept
            ip(geoip:private) && !qname(geosite:cn) -> cloudflaredns
            fallback: accept
          }
        }
      }
      group {
        proxy {
          policy: min_moving_avg
        }
      }
      routing {
        pname(systemd-networkd, systemd-resolved, nc, nscd, nsncd, sshd, sing-box, v2ray, xray, clash, clash-meta, mihomo, FlClash, FlClashCore) -> must_direct
        pname(NetworkManager) -> direct
        dip(224.0.0.0/3, 'ff00::/8') -> direct
        l4proto(udp) && dport(443) -> block
        dip(geoip:private) -> direct
        dip(geoip:cn) -> direct
        domain(geosite:cn) -> direct
        fallback: proxy
      }
    '';
  };
  systemd.services.dae.serviceConfig.LoadCredential = [
    "extra-config.dae:/etc/dae/extra-config.dae"
  ];
}
