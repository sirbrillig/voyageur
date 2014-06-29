/* globals domready, reqwest, EventEmitter, LocationsList */

domready( function() {
  reqwest({
    url: 'locations',
    type: 'json'
  }).then( function(data) {
    var emitter = new EventEmitter();
    emitter.on( 'locations', function( locations ) {
      renderLocationsList( locations );
    } );
    emitter.emit( 'locations', data );
  } );
});

function renderLocationsList( locations ) {
  var element = document.getElementsByClassName( 'library_locations' )[0];
  React.renderComponent(
    LocationsList({ locations: locations }),
    element
  );
}
