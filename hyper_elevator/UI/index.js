$(document).ready(function() {
    $(".container").hide();

    function Post(endpoint, data) {
        $.post(`https://${GetParentResourceName()}/${endpoint}`, JSON.stringify(data || {}))
    }

    function CloseUI() {
        Post("Close");
        $(".container").fadeOut(500);
        $(".Bg").empty();
    }

    window.addEventListener("message", function(event) {
        let data = event.data;

        if (data.action === "Show") {
            $(".InformationText").text(data.info || "");
            $(".Bg").empty();

            (data.floors || []).forEach(function(floor) {
                let frame = $(`
                    <div class="Frame" data-id="${floor.id}">
                        <img src="images/ICON.png" class="Icon">
                        <label class="TopLabel">#${floor.id} Elevator</label>
                        <label class="BottomLabel">${floor.name}</label>
                        <button class="Confirm">Go To</button>
                    </div>`
                );
                $(".Bg").append(frame);
            });

            $(".container").fadeIn(500);
        } else if (data.action == "Hide") {
            $(".container").fadeOut(500);
            $(".Bg").empty();
        }
    });

    $(document).on("click", ".Confirm", function() {
        let id = $(this).closest(".Frame").data("id");
        Post("Confirm", { id: id });
    });

    $(document).on("click", ".Close", function() {
        CloseUI()
    });

    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            CloseUI()
        }
    });
});