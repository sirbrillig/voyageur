/* globals domready, reqwest, EventEmitter, LocationsList */

var emitter = new EventEmitter();

domready( function() {
  reqwest({
    url: 'locations',
    type: 'json'
  }).then( function(data) {
    emitter.emit( 'locations', data );
  } );

  reqwest({
    url: 'triplocations',
    type: 'json'
  }).then( function(data) {
    console.log('triplocations', data);
  } );
});

emitter.on( 'locations', function( locations ) {
  renderLocationsList( locations );
} );

emitter.on( 'addToTrip', function( id ) {
  var tripId = getTripId(),
  data = { triplocation: { trip_id: tripId, location_id: id, position: 1 } };

  console.log('adding', id, 'to trip', tripId, 'data', data);
  reqwest({
    url: 'triplocations/',
    type: 'json',
    method: 'post',
    data: data
  }).then( function(data) {
    console.log('post complete', data);
  } );
} );

function getTripId() {
  var element = document.getElementsByClassName( 'trip_locations' )[0];
  return element.getAttribute( 'trip-id' );
}

function renderLocationsList( locations ) {
  var element = document.getElementsByClassName( 'library_locations' )[0];
  React.renderComponent(
    LocationsList({ locations: locations }),
    element
  );
}
