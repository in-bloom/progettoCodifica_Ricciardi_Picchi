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
      '#text-section [data-facs~="' + escapeSelector(zoneId) + '"]',
    );
  }

  function highlightFromText(textElement) {
    var facs = textElement.getAttribute("data-facs");
    if (!facs) return;

    var zoneIds = facs.trim().split(/\s+/);

    clearHighlights();

    textElement.classList.add("active-text");

    zoneIds.forEach(function (zoneId) {
      var zone = document.getElementById(zoneId);

      if (zone) {
        zone.classList.add("active-facs");
      }
    });

    var firstZone = document.getElementById(zoneIds[0]);

    if (firstZone) {
      scrollZoneIntoView(firstZone);
    }
  }

  function scrollZoneIntoView(zone) {
    var imageSection = document.getElementById("image-section");
    if (!imageSection || !zone) return;

    var zoneBox = zone.getBoundingClientRect();
    var sectionBox = imageSection.getBoundingClientRect();

    var zoneCenter =
      zoneBox.top -
      sectionBox.top +
      imageSection.scrollTop +
      zoneBox.height / 2;

    imageSection.scrollTo({
      top: zoneCenter - imageSection.clientHeight / 2,
      behavior: "smooth",
    });
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
      "#text-section span." + className,
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
        "#text-section span." + className,
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
    ".highlight-buttons button[data-highlight]",
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

  const menuToggle = document.getElementById("menu-toggle");
  const highlightMenu = document.getElementById("highlight-menu");

  if (menuToggle && highlightMenu) {
    menuToggle.addEventListener("click", function () {
      const isOpen = highlightMenu.classList.toggle("is-open");
      menuToggle.classList.toggle("is-open", isOpen);
      menuToggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
    });
  }

  function initTextVersionSwitch() {
    const buttons = document.querySelectorAll(".version-button[data-version]");

    function setTextVersion(version) {
      const selectedVersion =
        version === "interpretative" ? "interpretative" : "diplomatic";

      const otherVersion =
        selectedVersion === "diplomatic" ? "interpretative" : "diplomatic";

      document.body.classList.remove("show-" + otherVersion);
      document.body.classList.add("show-" + selectedVersion);

      buttons.forEach(function (button) {
        const isActive = button.dataset.version === selectedVersion;

        button.classList.toggle("is-active", isActive);
        button.setAttribute("aria-pressed", isActive ? "true" : "false");
      });
    }

    buttons.forEach(function (button) {
      button.addEventListener("click", function () {
        setTextVersion(button.dataset.version);
      });
    });

    setTextVersion("diplomatic");
  }

  initTextVersionSwitch();
});
