/**
 * Bot Factory — Navigation Module
 *
 * Handles left nav active state and section show/hide toggling.
 */

function showSection(sectionId) {
  // Hide all sections
  document.querySelectorAll("main.main-content > .section").forEach((s) => {
    s.style.display = "none";
  });

  // Show the target section
  const target = document.getElementById(sectionId);
  if (target) {
    target.style.display = "block";
  }
}

document.querySelectorAll(".site-nav a").forEach((link) => {
  link.addEventListener("click", function (e) {
    const href = this.getAttribute("href");
    if (href && href.startsWith("#") && href.length > 1) {
      e.preventDefault();

      // Update active state
      document
        .querySelectorAll(".site-nav a")
        .forEach((a) => a.classList.remove("active"));
      this.classList.add("active");

      // Show the target section
      showSection(href.substring(1));
    }
  });
});

// Show the initial active section on page load
const activeLink = document.querySelector(".site-nav a.active");
if (activeLink) {
  const href = activeLink.getAttribute("href");
  if (href && href.startsWith("#")) {
    showSection(href.substring(1));
  }
}
