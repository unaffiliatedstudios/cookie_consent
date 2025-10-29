/**
 * Cookie Consent Hook for Phoenix LiveView
 * 
 * Handles GDPR/CCPA cookie consent and loads Google Analytics
 * and Meta Pixel after user consent.
 */

export const CookieConsent = {
  mounted() {
    // Get tracking IDs from data attributes
    this.gaId = this.el.dataset.gaId;
    this.metaPixelId = this.el.dataset.metaPixelId;

    // Check if user has already made a choice
    const consent = this.getConsent();
    
    if (consent) {
      // User already consented, hide banner and load scripts
      this.pushEvent("close_banner", {});
      this.loadScripts(consent);
    }

    // Listen for consent events from LiveView
    this.handleEvent("cookie-consent", (data) => {
      const consent = {
        analytics: data.analytics,
        marketing: data.marketing
      };
      this.saveConsent(consent);
      this.loadScripts(consent);
    });
  },

  getConsent() {
    const stored = localStorage.getItem("cookie_consent");
    return stored ? JSON.parse(stored) : null;
  },

  saveConsent(consent) {
    localStorage.setItem("cookie_consent", JSON.stringify(consent));
    localStorage.setItem("cookie_consent_date", new Date().toISOString());
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
    // Load gtag.js
    const script = document.createElement('script');
    script.async = true;
    script.src = `https://www.googletagmanager.com/gtag/js?id=${this.gaId}`;
    document.head.appendChild(script);

    // Initialize gtag
    script.onload = () => {
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', this.gaId, {
        'anonymize_ip': true,
        'cookie_flags': 'SameSite=None;Secure'
      });
      window.GA_LOADED = true;
      console.log('[CookieConsent] Google Analytics loaded');
    };
  },

  loadMetaPixel() {
    !function(f,b,e,v,n,t,s)
    {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};
    if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
    n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];
    s.parentNode.insertBefore(t,s)}(window, document,'script',
    'https://connect.facebook.net/en_US/fbevents.js');
    
    fbq('init', this.metaPixelId);
    fbq('track', 'PageView');
    window.META_LOADED = true;
    console.log('[CookieConsent] Meta Pixel loaded');
  }
};