$(document).ready(function() {
    $(".container").hide();
    $(".Bg").empty();

    window.addEventListener("message", function(event) {
        let data = event.data;

        if (data.action === "Show") {

        }
    });
});