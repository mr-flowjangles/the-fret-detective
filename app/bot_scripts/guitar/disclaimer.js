// ── AI Disclaimer / Terms of Use ──────────────────────────
(function () {
  const STORAGE_KEY = "fretdetective_terms_accepted";

  function hasAccepted() {
    return localStorage.getItem(STORAGE_KEY) === "true";
  }

  function markAccepted() {
    localStorage.setItem(STORAGE_KEY, "true");
  }

  function showBanner() {
    const banner = document.getElementById("ai-disclaimer-banner");
    if (banner) banner.classList.remove("hidden");
  }

  function hideBanner() {
    const banner = document.getElementById("ai-disclaimer-banner");
    if (banner) banner.classList.add("hidden");
  }

  function handleDecline() {
    // Redirect or lock the UI — adjust to taste
    hideBanner();
    document.body.innerHTML =
      '<div style="display:flex;height:100vh;align-items:center;justify-content:center;' +
      'background:#1a1a2e;color:#e0e0e0;font-family:sans-serif;text-align:center;padding:24px;">' +
      '<div><h2 style="color:#e8a020;">Access Restricted</h2>' +
      "<p>You must agree to the Terms of Use to use The Fret Detective.</p>" +
      '<button onclick="location.reload()" style="margin-top:16px;padding:10px 24px;' +
      'background:#e8a020;border:none;border-radius:6px;cursor:pointer;font-weight:bold;">Go Back</button>' +
      "</div></div>";
  }

  document.addEventListener("DOMContentLoaded", function () {
    if (hasAccepted()) return; // already agreed — show nothing

    showBanner();

    document
      .getElementById("ai-disclaimer-accept")
      .addEventListener("click", function () {
        markAccepted();
        hideBanner();
      });

    document
      .getElementById("ai-disclaimer-decline")
      .addEventListener("click", handleDecline);

    document
      .getElementById("terms-link")
      .addEventListener("click", function (e) {
        e.preventDefault();
        document.getElementById("terms-modal").classList.remove("hidden");
      });

    document
      .getElementById("close-terms")
      .addEventListener("click", function () {
        document.getElementById("terms-modal").classList.add("hidden");
      });

    // Close modal on backdrop click
    document
      .getElementById("terms-modal")
      .addEventListener("click", function (e) {
        if (e.target === this) this.classList.add("hidden");
      });
  });
})();
