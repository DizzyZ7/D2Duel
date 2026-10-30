(function () {
    "use strict";
    // Static preview only. Never infer entitlements from client state.
    var progress = $("#PassProgress");
    if (progress) {
        progress.text = "Level 0 / 50 - Preview";
    }
    // Future server-authenticated pass state must arrive via a trusted server event.
    // No purchase button, checkout, entitlement grant or XP claim is implemented.
})();
