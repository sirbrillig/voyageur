/* globals debug, FluxStore, emitter, reqwest */

(function() {
  var log = debug('voyageur:LocationsStore');

  return FluxStore.createStore( emitter, 'LocationsStore', {
    initialize: function() {
      log('initialize LocationsStore');
      this.locations = [];
    },

    getLocations: function() {
      return this.locations;
    },

    getById: function( id ) {
      return this.locations.filter( function( obj ) {
        return ( parseInt( obj.id, 10 ) === parseInt( id, 10 ) );
      } )[0];
    },

    fetch: function() {
      reqwest({
        url: 'locations.json',
        type: 'json'
      }).then( function(data) {
        log('locations fetch returned', data);
        this.locations = data;
        this.emit( 'change' );
      }.bind( this ) ).fail( function() {
        log( 'location fetch failed' );
        var message = 'Fetching locations failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    }
  } );
} )();

