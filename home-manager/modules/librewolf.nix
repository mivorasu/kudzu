{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    profiles.default = {
      id = 0;
      isDefault = true;
      search = {
        default = "google";
        privateDefault = "google";
        force = true;
      };
      extensions.packages = with pkgs.firefox-addons; [
        ublock-origin
        bitwarden
        violentmonkey
        user-agent-string-switcher
        immersive-translate
      ];
      settings = {
        # 日期: 6 March 2025
        # 版本号: 135
        # 链接: https://github.com/arkenfox/user.js

        # 禁用 about:config 警告
        "browser.aboutConfig.showWarning" = false;

        # --- 启动设置 ---
        # 设置启动页 [设置-浏览器]
        # 0=空白，1=主页，2=上次访问的页面，3=恢复上次会话
        "browser.startup.page" = 1;
        # 设置主页和新窗口页
        # about:home=Firefox 主页，自定义 URL，about:blank
        "browser.startup.homepage" = "about:home";
        # 设置新标签页
        # true=Firefox 主页，false=空白页
        "browser.newtabpage.enabled" = true;
        # 禁用 Firefox 主页上的赞助内容（Activity Stream）
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.feeds.recommendationprovider" = false;
        # 清除默认的热门网站
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # 搜索建议
        "browser.urlbar.suggest.searches" = true;

        # 禁用 about:addons 中的推荐面板
        "extensions.getAddons.showPane" = false;
        # 禁用 about:addons 中的扩展和主题面板中的推荐
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        # 禁用 about:addons 和 AMO 中的个性化扩展推荐
        "browser.discovery.enabled" = false;
        # 禁用购物体验
        "browser.shopping.experience2023.enabled" = false;

        # --- 遥测 ---
        # 禁用新数据提交
        "datareporting.policy.dataSubmissionEnabled" = false;
        # 禁用健康报告
        "datareporting.healthreport.uploadEnabled" = false;
        # 禁用遥测
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        # 禁用遥测覆盖
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        # 禁用 Firefox Home（活动流）遥测
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # --- 研究 ---
        # 禁用研究
        "app.shield.optoutstudies.enabled" = false;
        # 禁用 Normandy/Shield
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        # --- CRASH REPORTS ---
        # 禁用崩溃报告
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        # 强制不提交积压的崩溃报告
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

        # --- OTHER ---
        # 禁用强制门户检测
        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false;
        # 禁用网络连接检查
        "network.connectivity-service.enabled" = false;

        # --- 安全浏览 (SB) ---
        # 禁用 SB (安全浏览)
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        # 禁用对下载内容的 SB 检查
        "browser.safebrowsing.downloads.enabled" = false;
        # 禁用对下载内容的远程 SB 检查
        "browser.safebrowsing.downloads.remote.enabled" = false;
        # 禁用对不受欢迎软件的 SB 检查
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;

        # --- 阻止隐式的出站连接 ---
        # 禁用链接预取
        "network.prefetch-next" = false;
        # 禁用 DNS 预取
        "network.dns.disablePrefetch" = true;
        # 禁用预测器 / 预取
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;
        # 禁用通过链接的鼠标悬停打开到链接服务器的连接
        "network.http.speculative-parallel-limit" = 0;
        # 禁用书签和历史记录上的鼠标按下推测性连接
        "browser.places.speculativeConnect.enabled" = false;

        # --- 密码 ---
        # 禁用自动填充用户名和密码表单字段
        "signon.autofillForms" = false;
        # 限制（或禁用）由子资源触发的 HTTP 认证凭据对话框
        "network.auth.subresource-http-auth-allow" = 1;

        # --- HTTPS (SSL/TLS / OCSP / CERTS / HPKP) ---
        # 要求安全协商
        "security.ssl.require_safe_negotiation" = true;

        # --- OCSP (在线证书状态协议) ---
        # 强制执行 OCSP 获取以确认证书的当前有效性
        "security.OCSP.enabled" = 1;
        # 将 OCSP 获取失败设置为软失败
        "security.OCSP.require" = false;

        # --- CERTS / HPKP (HTTP Public Key Pinning) ---
        # 启用严格的 PKP (公钥固定)
        "security.cert_pinning.enforcement_level" = 2;
        # 启用 CRLite
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        # --- 混合内容 ---
        # 在所有窗口中启用 HTTPS-Only 模式
        "dom.security.https_only_mode" = true;
        # 禁用 HTTP 后台请求
        "dom.security.https_only_mode_send_http_background_request" = false;

        # --- UI ---
        # 在挂锁上显示“安全性受损”的警告
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        # 在不安全连接警告页面上显示高级信息
        "browser.xul.error_pages.expert_bad_cert" = true;

        # --- 引荐者 ---
        # 控制要发送的跨源信息的数量
        "network.http.referer.XOriginTrimmingPolicy" = 2;

        # --- 插件 / 媒体 / WebRTC ---
        # 强制 WebRTC 在代理内部使用
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        # 强制 ICE 候选项生成使用单一网络接口
        "media.peerconnection.ice.default_address_only" = true;
        # DRM
        "media.eme.enabled" = true;

        # --- DOM ---
        # 防止脚本移动和调整打开的窗口
        "dom.disable_window_move_resize" = true;

        # --- 杂项 ---
        "browser.tabs.searchclipboardfor.middleclick" = false;
        # 标签页预览
        "browser.tabs.hoverPreview.showThumbnails" = false;
        # 禁用 UITour 后端
        "browser.uitour.enabled" = false;
        # 重置远程调试为禁用状态
        "devtools.debugger.remote-enabled" = false;
        # 移除某些 mozilla 域的特殊权限
        "permissions.manager.defaultsUrl" = "";
        # 删除网络通道白名单
        "webchannel.allowObject.urlWhitelist" = "";
        # 在国际化域名中使用双关编码
        "network.IDN_show_punycode" = true;
        # 下载设置
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.autohideButton" = true;
        # ETP（增强跟踪保护）
        "browser.contentblocking.category" = "custom";
        # 清除历史记录设置
        "privacy.cpd.cache" = true;
        "privacy.cpd.formdata" = true;
        "privacy.cpd.history" = true;
        "privacy.clearHistory.cache" = true;
        "privacy.clearHistory.historyFormDataAndDownloads" = true;
        "privacy.clearHistory.cookiesAndStorage" = false;
        "privacy.clearOnShutdown_v2.history" = false;
        "privacy.clearOnShutdown_v2.downloads" = false;
        "privacy.clearOnShutdown_v2.cookies" = false;
        "privacy.clearOnShutdown_v2.formdata" = false;
        "privacy.clearOnShutdown_v2.offlineApps" = false;
        "privacy.clearOnShutdown_v2.cache" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.clearSiteData.cookiesAndStorage" = false;
        # 系统颜色
        "browser.display.use_system_colors" = true;
        # 禁用扩展/功能推荐
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        # 禁用“最新消息”工具栏图标
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        # 禁用 Mozilla 产品推荐
        "browser.preferences.moreFromMozilla" = false;
        # 搜索建议
        "browser.search.suggest.enabled" = true;
        "browser.search.suggest.enabled.private" = true;
        # 书签栏可见性
        "browser.toolbars.bookmarks.visibility" = "always";
        # 禁用 Pocket
        "extensions.pocket.enabled" = false;
        # 字体设置
        "font.default.x-western" = "sans-serif";
        "font.language.group" = "zh-CN";
        "font.name.monospace.x-western" = "monospace";
        "font.name.monospace.zh-CN" = "等距更纱黑体 SC";
        "font.name.sans-serif.x-western" = "Noto Sans CJK SC";
        "font.name.sans-serif.zh-CN" = "更纱黑体 UI SC";
        "font.name.serif.x-western" = "Noto Serif CJK SC";
        "font.name.serif.zh-CN" = "Noto Serif CJK SC";
        "intl.locale.requested" = "zh-CN,en-US";
        "intl.accept_languages" = "zh,en-us,en";
        # 拼写检查
        "layout.spellcheckDefault" = 0;
        "devtools.accessibility.enabled" = false;
        # Cookie 行为
        "network.cookie.cookieBehavior" = 1;
        "privacy.cpd.cookies" = false;
        # 跟踪保护
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        # Firefox Relay
        "signon.firefoxRelay.feature" = "disabled";
        # 翻译
        "browser.translations.enable" = false;
        # 登录管理
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        # 不许出售或共享
        "privacy.globalprivacycontrol.enabled" = true;
        "browser.ping-centre.telemetry" = true;
        # WebGPU
        "webgl.disabled" = false;
        "dom.webgpu.enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.x11-egl.force-enabled" = true;
        # "media.av1.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.hls.enabled" = true;
        # 避免频繁的磁盘写入
        "browser.cache.disk.enable" = false; # 关闭磁盘缓存
        "browser.sessionstore.interval" = 600000; # 延长会话信息记录之间的间隔
        # 使用 xdg 文件选择器
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "middlemouse.paste" = false;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
        # 允许右键/粘贴
        "dom.events.testing.asyncClipboard" = true;

        # https://librewolf.net/docs/settings
        "identity.fxaccounts.enabled" = true;
        # 避免显示异常
        "privacy.resistFingerprinting" = false;
        "privacy.resistFingerprinting.letterboxing" = false;
        # 允许请求非英文网页
        "javascript.use_us_english_locale" = false;
        "privacy.spoof_english" = 1;
        # Container 身份
        "privacy.userContext.enabled" = false;
      };
    };
    policies = {
      # https://github.com/mozilla/policy-templates/blob/master/linux/policies.json
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      AutofillCreditCardEnabled = false;
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
        BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
      };
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableSecurityBypass.SafeBrowsing = false;
      DisableSetDesktopBackground = true;
      DisableSystemAddonUpdate = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Snippets = false;
        SponsoredPocket = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      HardwareAcceleration = true;
      Homepage = {
        URL = "about:home";
        StartPage = "homepage";
      };
      NetworkPrediction = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PromptForDownloadLocation = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      ShowHomeButton = true;
      SkipTermsOfUse = true;
      TranslateEnabled = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
      };
      UseSystemPrintDialog = true;
    };
  };
}
