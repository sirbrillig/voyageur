/* globals debug, FluxStore, emitter, reqwest, getTripId */

(function() {
  var log = debug('voyageur:TripStore');

  return FluxStore.createStore( emitter, 'TripStore', {
    initialize: function() {
      log('initialize TripStore');
      this.distance = 0;

      this.bindActions( {
        'updateDistance': this.fetch
      } );
    },

    setDistance: function( distance ) {
      this.distance = distance;
      this.emit( 'change' );
    },

    getDistance: function() {
      return this.distance;
    },

    fetch: function() {
      if ( this.fetchTripTimeout ) clearTimeout( this.fetchTripTimeout );
      this.fetchTripTimeout = setTimeout( this._fetchTrip.bind(this), 200 );
    },

    _fetchTrip: function() {
      var id = getTripId();
      reqwest({
        url: 'trips/' + id + '.json',
        type: 'json'
      }).then( function(data) {
        log('trip fetch returned', data);
        if ( this.lastTripTimestamp && data.timestamp < this.lastTripTimestamp ) {
          log( 'timestamp is out of date. ignoring trip data.', data );
        } else {
          log('distance is now', data.distance);
          this.lastTripTimestamp = data.timestamp;
          this.setDistance( data.distance );
        }
      }.bind( this ) ).fail( function() {
        log( 'trip fetch failed' );
        var message = 'Fetching the trip failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    }

  } );
} )();

