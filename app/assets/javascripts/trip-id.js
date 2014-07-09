
var getTripId = function() { //jshint ignore:line
  var element = document.getElementsByClassName( 'trip-id' )[0];
  return element.getAttribute( 'data-trip-id' );
};

