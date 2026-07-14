/* AceBank — shared front-end helpers (no external dependencies) */
(function () {
  "use strict";

  document.addEventListener("click", function (e) {
    // Public/landing mobile nav
    if (e.target.closest(".nav-toggle")) {
      var links = document.querySelector(".nav-links");
      if (links) links.style.display = links.style.display === "flex" ? "" : "flex";
    }
    // App sidebar (authenticated pages)
    if (e.target.closest("#navToggle")) {
      var app = document.getElementById("app");
      if (app) app.classList.toggle("nav-open");
    }
  });

  // Password show/hide toggles: any [data-toggle-password] targets the previous input
  document.addEventListener("click", function (e) {
    var btn = e.target.closest("[data-toggle-password]");
    if (!btn) return;
    var input = btn.parentNode.querySelector("input");
    if (input) input.type = input.type === "password" ? "text" : "password";
  });
})();
