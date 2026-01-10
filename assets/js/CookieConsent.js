/**
 * Cookie Consent Hook for Phoenix LiveView
 *
 * Handles GDPR/CCPA cookie consent and loads Google Analytics
 * and Meta Pixel after user consent.
 */

export const CookieConsent = {
  mounted() {
    this.gaId = this.el.dataset.gaId;
    this.metaPixelId = this.el.dataset.metaPixelId;
    this.cspNonce = this.el.dataset.cspNonce;
    this.debug = this.el.dataset.debug === "true";
    this.hideBanner();

    // Check if user has already made a choice
    const consent = this.getConsent();

    if (consent) {
      // User already consented, load scripts immediately
      this.loadScripts(consent);
    } else {
      this.showBanner();
    }

    // Listen for consent events from LiveView
    this.handleEvent("cookie-consent", (data) => {
      const consent = {
        analytics: data.analytics,
        marketing: data.marketing,
      };
      this.saveConsent(consent);
      this.loadScripts(consent);
      this.hideBanner();
    });

    // Expose method to check consent (for parent apps)
    window.getCookieConsent = () => this.getConsent();
  },

  getConsent() {
    try {
      const stored = localStorage.getItem("cookie_consent");
      return stored ? JSON.parse(stored) : null;
    } catch (error) {
      // If localStorage is unavailable or data is corrupted, clear it and return null
      if (this.debug) {
        console.error("[CookieConsent] Error reading consent data:", error);
      }
      try {
        localStorage.removeItem("cookie_consent");
      } catch (e) {
        // Ignore errors when clearing
      }
      return null;
    }
  },

  saveConsent(consent) {
    try {
      localStorage.setItem("cookie_consent", JSON.stringify(consent));
      localStorage.setItem("cookie_consent_date", new Date().toISOString());
    } catch (error) {
      // Handle cases where localStorage might be disabled or full
      if (this.debug) {
        console.error("[CookieConsent] Error saving consent data:", error);
      }
    }
  },
  showBanner() {
    this.el.classList.add("cookie-consent-visible");
  },
  hideBanner() {
    this.el.classList.remove("cookie-consent-visible");
  },

  loadScripts(consent) {
    if (consent.analytics && !window.GA_LOADED && this.gaId) {
      this.loadGoogleAnalytics();
    }

    if (consent.marketing && !window.META_LOADED && this.metaPixelId) {
      this.loadMetaPixel();
    }
  },

  loadGoogleAnalytics() {
    if (this.debug) {
      console.log("[CookieConsent] Loading Google Analytics");
    }
    // Load gtag.js
    const script = document.createElement("script");
    script.async = true;
    script.src = `https://www.googletagmanager.com/gtag/js?id=${this.gaId}`;
    script.nonce = this.cspNonce || "";
    document.head.appendChild(script);

    // Initialize gtag
    script.onload = () => {
      window.dataLayer = window.dataLayer || [];
      function gtag() {
        dataLayer.push(arguments);
      }
      window.gtag = gtag;
      gtag("js", new Date());
      gtag("config", this.gaId, {
        anonymize_ip: true,
        cookie_flags: "SameSite=None;Secure",
      });
      window.GA_LOADED = true;
      if (this.debug) {
        console.log("[CookieConsent] Google Analytics loaded successfully");
      }
    }.bind(this);

    script.onerror = () => {
      if (this.debug) {
        console.error("[CookieConsent] Failed to load Google Analytics");
      }
    }.bind(this);
  },

  loadMetaPixel() {
    if (this.debug) {
      console.log("[CookieConsent] Loading Meta Pixel");
    }

    !(function (f, b, e, v, n, t, s) {
      if (f.fbq) return;
      n = f.fbq = function () {
        n.callMethod
          ? n.callMethod.apply(n, arguments)
          : n.queue.push(arguments);
      };
      if (!f._fbq) f._fbq = n;
      n.push = n;
      n.loaded = !0;
      n.version = "2.0";
      n.queue = [];
      t = b.createElement(e);
      t.async = !0;
      t.src = v;
      t.nonce = this.cspNonce || "";
      s = b.getElementsByTagName(e)[0];
      s.parentNode.insertBefore(t, s);
    })(
      window,
      document,
      "script",
      "https://connect.facebook.net/en_US/fbevents.js"
    );

    fbq("init", this.metaPixelId);
    fbq("track", "PageView");
    window.META_LOADED = true;
    if (this.debug) {
      console.log("[CookieConsent] Meta Pixel loaded successfully");
    }
  },
};