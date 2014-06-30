/* globals domready, reqwest, EventEmitter, LocationsList, TriplocationsList */

var emitter = new EventEmitter();

domready( function() {
  reqwest({
    url: 'locations',
    type: 'json'
  }).then( function(data) {
    emitter.emit( 'locations', data );
  } );
});

emitter.on( 'locations', function( locations ) {
  renderLocationsList( locations );
} );

emitter.on( 'addToTrip', function( id ) {
  addTriplocation( id );
} );

function addTriplocation( id ) {
  var tripId = getTripId(),
  data = { triplocation: { trip_id: tripId, location_id: id } };

  // TODO: add the location to the list before updating the server
  //var triplocation = { id: 0, location: location };

  console.log('adding', id, 'to trip', tripId, 'data', data);
  reqwest({
    url: 'triplocations/',
    type: 'json',
    method: 'post',
    data: data
  }).then( function(data) {
    console.log('post complete', data);
    getTriplocations();
  } );
}

function getTriplocations() {
  reqwest({
    url: 'triplocations',
    type: 'json'
  }).then( function(data) {
    console.log('triplocations', data);
    renderTriplocationsList( data );
  } );
}

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

function renderTriplocationsList( triplocations ) {
  var element = document.getElementsByClassName( 'trip_locations' )[0];
  React.renderComponent(
    TriplocationsList({ triplocations: triplocations }),
    element
  );
}
