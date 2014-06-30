/* globals domready, reqwest, EventEmitter, LocationsList, TriplocationsList */

var emitter = new EventEmitter();
var Store = { locations: [], triplocations: [] };

domready( function() {
  getLocations();
  getTriplocations();
});

emitter.on( 'triplocations', function( triplocations ) {
  Store.triplocations = triplocations;
  renderTriplocationsList( triplocations );
} );

emitter.on( 'locations', function( locations ) {
  Store.locations = locations;
  renderLocationsList( locations );
} );

emitter.on( 'addToTrip', function( id ) {
  addTriplocation( id );
} );

function addTriplocation( id ) {
  var tripId = getTripId(),
  data = { triplocation: { trip_id: tripId, location_id: id } },
  location = getLocationById( id ),
  triplocation = { id: 0, location: location };

  console.log('adding', id, 'to trip', tripId, 'data', data);

  addTriplocationToData( triplocation );

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

function getLocationById( id ) {
  return Store.locations.filter( function( location ) {
    return ( location.id === id );
  } )[0];
}

function addTriplocationToData( triplocation ) {
  Store.triplocations.push( triplocation );
  renderTriplocationsList( Store.triplocations );
}

function getLocations() {
  reqwest({
    url: 'locations',
    type: 'json'
  }).then( function(data) {
    emitter.emit( 'locations', data );
  } );
}

function getTriplocations() {
  reqwest({
    url: 'triplocations',
    type: 'json'
  }).then( function(data) {
    console.log('triplocations', data);
    emitter.emit( 'triplocations', data );
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
