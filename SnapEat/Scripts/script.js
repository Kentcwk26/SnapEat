document.addEventListener("DOMContentLoaded", function () {
    let foodTab = document.querySelector("#foodDropdown");

    if (window.location.pathname.toLowerCase().includes("/food")) {
        foodTab.classList.add("active-link");
    }

    let dropdowns = document.querySelectorAll(".dropdown");
    dropdowns.forEach(dropdown => {
        dropdown.addEventListener("mouseenter", function () {
            let menu = this.querySelector(".dropdown-menu");
            if (menu) {
                menu.classList.add("show");
            }
        });

        dropdown.addEventListener("mouseleave", function () {
            let menu = this.querySelector(".dropdown-menu");
            if (menu) {
                menu.classList.remove("show");
            }
        });
    });
});
