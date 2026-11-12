(function () {
  var KEY = "cv-dark-mode";
  var btn = document.getElementById("toggle-dark");
  var label = btn ? btn.querySelector(".label") : null;
  var icon = btn ? btn.querySelector("i") : null;

  function read() {
    try { return localStorage.getItem(KEY) === "1"; } catch (e) { return false; }
  }
  function save(on) {
    try { localStorage.setItem(KEY, on ? "1" : "0"); } catch (e) {}
  }
  function apply(on) {
    document.body.classList.toggle("dark-mode", on);
    if (!btn) return;
    if (label) label.textContent = on ? btn.dataset.labelLight : btn.dataset.labelDark;
    if (icon) icon.className = (on ? "fas fa-sun" : "fas fa-moon") + " me-1";
    btn.setAttribute("aria-pressed", on ? "true" : "false");
  }

  apply(read());
  if (btn) {
    btn.addEventListener("click", function () {
      var on = !document.body.classList.contains("dark-mode");
      apply(on);
      save(on);
    });
  }

  // Año del footer siempre actualizado
  var year = document.getElementById("year");
  if (year) year.textContent = new Date().getFullYear();
})();
