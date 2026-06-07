document.addEventListener("DOMContentLoaded", function () {
  function escapeSelector(value) {
    if (window.CSS && CSS.escape) {
      return CSS.escape(value);
    }
    return value.replace(/([ #;?%&,.+*~\':"!^$[\]()=>|\/@])/g, "\\$1");
  }

  function clearHighlights() {
    document.querySelectorAll(".active-facs").forEach(function (el) {
      el.classList.remove("active-facs");
    });

    document.querySelectorAll(".active-text").forEach(function (el) {
      el.classList.remove("active-text");
    });
  }

  function findTextByZone(zoneId) {
    return document.querySelector(
      '#text-section [data-facs~="' + escapeSelector(zoneId) + '"]'
    );
  }

  function highlightFromText(textElement) {
    var facs = textElement.getAttribute("data-facs");
    if (!facs) return;

    var firstZoneId = facs.trim().split(/\s+/)[0];
    var zone = document.getElementById(firstZoneId);

    clearHighlights();

    textElement.classList.add("active-text");

    if (zone) {
      zone.classList.add("active-facs");

      var page = zone;
      if (page) {
        page.scrollIntoView({
          behavior: "smooth",
          block: "center",
        });
      }
    }
  }

  function highlightFromZone(zoneElement) {
    var zoneId =
      zoneElement.getAttribute("data-zone") || zoneElement.getAttribute("id");

    if (!zoneId) return;

    var textElement = findTextByZone(zoneId);

    clearHighlights();

    zoneElement.classList.add("active-facs");

    if (textElement) {
      textElement.classList.add("active-text");

      textElement.scrollIntoView({
        behavior: "smooth",
        block: "center",
      });
    }
  }

  function toggleHighlight(className) {
    const elements = document.querySelectorAll(
      "#text-section span." + className
    );

    elements.forEach(function (element) {
      element.classList.toggle("highlighted-entity");
      element.classList.toggle("highlighted-" + className);
    });
  }

  function resetHighlights() {
    const classes = ["persName", "placeName", "orgName", "date"];

    classes.forEach(function (className) {
      const elements = document.querySelectorAll(
        "#text-section span." + className
      );

      elements.forEach(function (element) {
        element.classList.remove("highlighted-entity");
        element.classList.remove("highlighted-" + className);
      });
    });
  }

  document
    .querySelectorAll("#text-section [data-facs]")
    .forEach(function (textElement) {
      textElement.addEventListener("click", function () {
        highlightFromText(textElement);
      });
    });

  document.querySelectorAll(".facsimile-zone").forEach(function (zoneElement) {
    zoneElement.addEventListener("click", function () {
      highlightFromZone(zoneElement);
    });
  });

  const highlightButtons = document.querySelectorAll(
    ".highlight-buttons button[data-highlight]"
  );

  const resetButton = document.getElementById("reset-highlights");

  highlightButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      const className = button.getAttribute("data-highlight");
      toggleHighlight(className);
    });
  });

  if (resetButton) {
    resetButton.addEventListener("click", function () {
      resetHighlights();
    });
  }
});