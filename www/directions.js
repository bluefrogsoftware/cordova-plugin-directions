
var exec = require("cordova/exec");

var Directions = function () {
    this.name = "Directions";
};

Directions.prototype.navigateTo = function (latitude, longitude, showSource, directionsMode) {
    showSource = (showSource == null ? true : showSource);
    directionsMode = (directionsMode == null ? "driving" : directionsMode);
    exec(null, null, "Directions", "navigateTo", [{latitude: latitude, longitude: longitude, showSource: showSource, directionsMode: directionsMode}]);
};

Directions.prototype.navigateToAddress = function (destinationAddress, originAddress, showSource, directionsMode) {
    showSource = (showSource == null ? true : showSource);
    directionsMode = (directionsMode == null ? "driving" : directionsMode);
    exec(null, null, "Directions", "navigateTo", [{destinationAddress: destinationAddress, originAddress: originAddress, showSource: showSource, directionsMode: directionsMode}]);
};

module.exports = new Directions();
