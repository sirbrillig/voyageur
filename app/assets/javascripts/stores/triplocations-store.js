/* globals debug, FluxStore, emitter, reqwest, getTripId */

(function() {
  var log = debug('voyageur:TriplocationsStore');

  return FluxStore.createStore( emitter, 'TriplocationsStore', {
    initialize: function() {
      log('initialize TriplocationsStore');
      this.triplocations = [];

      this.bindActions( {
        'addLocationToTrip': this.addLocationToTrip,
        'removeFromTrip': this.removeFromTrip,
        'clearTrip': this.clearTrip
      } );
    },

    getTriplocations: function() {
      return this.triplocations;
    },

    addLocationToTrip: function( location ) {
      log('**event** addLocationToTrip', location);
      var triplocation = this.createNewTriplocation( location );
      this.triplocations.push( triplocation );
      this.emit( 'change' );
      this.create( triplocation );
    },

    removeFromTrip: function( id ) {
      log('**event** removeFromTrip', id );
      var triplocation = this.getById( id );
      var index = this.triplocations.indexOf( triplocation );
      this.triplocations.splice( index, 1 );
      this.emit( 'change' );
      this.destroy( triplocation );
    },

    clearTrip: function() {
      log('**event** clearTrip');
      this.triplocations.forEach( this.destroy.bind( this ) );
      this.triplocations = [];
    },

    getById: function( id ) {
      return this.triplocations.filter( function( obj ) {
        return ( parseInt( obj.id, 10 ) === parseInt( id, 10 ) );
      } )[0];
    },

    create: function( triplocation ) {
      log('adding triplocation', triplocation);
      var data = { triplocation: { trip_id: triplocation.trip_id, location_id: triplocation.location.id } };
      reqwest({
        url: 'triplocations.json',
        type: 'json',
        method: 'post',
        data: data
      }).then( function() {
        log('triplocation add complete');
        this.fetch();
      }.bind( this ) ).fail( function() {
        log( 'triplocation add failed' );
        var message = 'Adding a triplocation failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    createNewTriplocation: function( locationId ) {
      var tripId = getTripId(),
      location = FluxStore.getStore('LocationsStore').getById( locationId );
      return { id: Math.floor( Math.random() * 1000 ), trip_id: tripId, location: location };
    },

    destroy: function( triplocation ) {
      log('removing triplocation', triplocation);
      reqwest({
        url: 'triplocations/' + triplocation.id + '.json',
        type: 'json',
        method: 'delete'
      }).then( function(data) {
        log('triplocation delete returned', data);
        this.fetch();
      }.bind( this ) ).fail( function() {
        log( 'triplocation remove failed' );
        var message = 'Removing a triplocation failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    fetch: function() {
      reqwest({
        url: 'triplocations.json',
        type: 'json'
      }).then( function(data) {
        log('triplocations fetch returned', data);
        this.triplocations = data;
        this.emit( 'change' );
      }.bind( this ) ).fail( function() {
        log( 'triplocation fetch failed' );
        var message = 'Fetching triplocations failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    }
  } );
} )();
