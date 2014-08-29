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
        'clearTrip': this.clearTrip,
        'moveTriplocation': this.moveTriplocation
      } );
    },

    getTriplocations: function() {
      return this.triplocations;
    },

    moveTriplocation: function( data ) {
      log('**event** moveTriplocation', data);
      var fromTriplocation = this.getById( data.from );
      var toTriplocation = this.getById( data.to );
      if ( fromTriplocation.position > toTriplocation.position ) {
        // dragging up the list
        log( 'dragging up' );
        this.reorder( { direction: 'up', from: fromTriplocation, to: toTriplocation } );
      } else {
        // dragging down the list
        log( 'dragging down' );
        this.reorder( { direction: 'down', from: fromTriplocation, to: toTriplocation } );
      }
    },

    reorder: function( data ) {
      log( 'reorder', data, 'moving ' + data.from.position + ' to ' + data.to.position );
      data.from.position = data.to.position;

      var startMoving = false;
      ( data.direction === 'down' ? this.triplocations.reverse() : this.triplocations).forEach( function( triplocation ) {
        if ( triplocation.id === data.from.id ) return;
        if ( startMoving || ( triplocation.id === data.to.id ) ) {
          startMoving = true;
          if ( data.direction === 'down' ) {
            triplocation.position -= 1;
          } else {
            triplocation.position += 1;
          }
          // We don't need to update the server here because the server
          // recalculates the other positions itself.
          //this._updateServer( this.move, data.from );
        }
      }, this );
      this._updateServer( this.move, data.from );
      this.emit( 'change' );
    },

    addLocationToTrip: function( libraryLocation ) {
      log('**event** addLocationToTrip', libraryLocation);
      var triplocation = this.createNewTriplocation( libraryLocation );
      this.triplocations.push( triplocation );
      this.emit( 'change' );
      this._updateServer( this.create, triplocation );
    },

    removeFromTrip: function( id ) {
      log('**event** removeFromTrip', id );
      var triplocation = this.getById( id );
      var index = this.triplocations.indexOf( triplocation );
      this.triplocations.splice( index, 1 );
      this.emit( 'change' );
      this._updateServer( this.destroy, triplocation );
    },

    clearTrip: function() {
      log('**event** clearTrip');
      var toDelete = this.triplocations.slice();
      this.triplocations = [];
      this.emit( 'change' );
      this._updateServer( this._deleteItems, toDelete );
    },

    _updateServer: function( func, arg ) {
      setTimeout( func.bind( this, arg ), 100 );
    },

    _deleteItems: function( items ) {
      items.forEach( this.destroy.bind( this ) );
    },

    getById: function( id ) {
      return this.triplocations.filter( function( obj ) {
        return ( parseInt( obj.id, 10 ) === parseInt( id, 10 ) );
      } )[0];
    },

    create: function( triplocation ) {
      log('create', triplocation);
      var data = { triplocation: { trip_id: triplocation.trip_id, location_id: triplocation.location.id } };
      reqwest({
        url: 'triplocations.json',
        type: 'json',
        method: 'post',
        data: data
      }).then( function() {
        log('create complete');
        this.fetch();
      }.bind( this ) ).fail( function() {
        log( 'triplocation create failed' );
        var message = 'Adding a triplocation failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    createNewTriplocation: function( locationId ) {
      var tripId = getTripId(),
      libraryLocation = FluxStore.getStore('LocationsStore').getById( locationId );
      return { id: Math.floor( Math.random() * 1000 ), trip_id: tripId, location: libraryLocation };
    },

    move: function( triplocation ) {
      log('move', triplocation);
      var data = { id: triplocation.id, triplocation: triplocation };
      reqwest({
        url: 'triplocations/' + triplocation.id + '.json',
        type: 'json',
        method: 'put',
        data: data
      }).then( function(data) {
        log('move returned', data);
        this.fetch();
      }.bind( this ) ).fail( function() {
        log( 'triplocation move failed' );
        var message = 'Moving a triplocation failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    destroy: function( triplocation ) {
      log('destroy', triplocation);
      reqwest({
        url: 'triplocations/' + triplocation.id + '.json',
        type: 'json',
        method: 'delete'
      }).then( function(data) {
        log('destroy returned', data);
        this.fetch();
      }.bind( this ) ).fail( function() {
        log( 'triplocation destroy failed' );
        var message = 'Removing a triplocation failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    fetch: function() {
      // Throttle calls to fetch.
      if ( this.fetchTimeout ) clearTimeout( this.fetchTimeout );
      this.fetchTimeout = setTimeout( this._fetch.bind( this ), 100 );
    },

    _fetch: function() {
      reqwest({
        url: 'triplocations.json',
        type: 'json'
      }).then( function(data) {
        log('triplocations fetch returned', data);
        this.setTriplocations(data);
      }.bind( this ) ).fail( function() {
        log( 'triplocation fetch failed' );
        var message = 'Fetching triplocations failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    setTriplocations: function( triplocations ) {
      if ( ! this.sameTrip(triplocations) ) {
        log('trip has changed, sending change event');
        this.triplocations = triplocations;
        this.emit( 'change' );
      } else {
        log('trip has not changed, silently updating');
        this.triplocations = triplocations;
      }
    },

    sameTrip: function( data ) {
      var newData = data.map( function(item) { return item.location.id; } );
      var oldData = this.triplocations.map( function(item) { return item.location.id; } );
      return (newData.length === oldData.length && newData.every( function(val, index) { return val === oldData[index]; } ));
    }
  } );
} )();
