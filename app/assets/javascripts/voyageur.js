/* globals domready, reqwest, EventEmitter, LocationsList */

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
  //reqwest({
  //url: 'trip/' + tripId + '/update',
  //type: 'json',
  //method: 'post',
  //data: tripLocations
  //}).then( function(data) {
  //} );
  console.log('adding', id);
} );

function renderLocationsList( locations ) {
  var element = document.getElementsByClassName( 'library_locations' )[0];
  React.renderComponent(
    LocationsList({ locations: locations }),
    element
  );
}
