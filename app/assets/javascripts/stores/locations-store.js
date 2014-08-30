/* globals debug, FluxStore, emitter, reqwest */

(function() {
  var log = debug('voyageur:LocationsStore');

  return FluxStore.createStore( emitter, 'LocationsStore', {
    initialize: function() {
      log('initialize LocationsStore');
      this.allLocations = [];
      this.locations = [];
      this.selectedIndex = 0;
      this.currentFilter = '';

      this.bindActions( {
        'moveLocation': this.moveLocation,
        'filterLocations': this.filterLocations,
        'incrementSelectedIndex': this.incrementSelectedIndex,
        'decrementSelectedIndex': this.decrementSelectedIndex
      } );
    },

    incrementSelectedIndex: function() {
      if ( this.selectedIndex === this.locations.length - 1 ) return;
      this.selectedIndex += 1;
      this.emit( 'change' );
    },

    decrementSelectedIndex: function() {
      if ( this.selectedIndex === 0 ) return;
      this.selectedIndex -= 1;
      this.emit( 'change' );
    },

    getSelectedIndex: function() {
      return this.selectedIndex;
    },

    getSelectedLocation: function() {
      return this.locations[ this.selectedIndex ];
    },

    filterLocations: function( value ) {
      log('**event** filterLocations', value, 'currentFilter', this.currentFilter);
      if ( this.currentFilter === value ) return log('currentFilter has not changed');
      this.currentFilter = value;
      this.locations = this.allLocations;
      this.locations = this.locations.filter( function(locationObject) {
        return this.doesLocationMatch(locationObject, value);
      }.bind( this ) );
      this.selectedIndex = 0;
      this.emit( 'change' );
    },

    doesLocationMatch: function( locationObject, value ) {
      value = value.toLowerCase();
      if (~ locationObject.title.toLowerCase().indexOf(value)) return true;
      if (~ locationObject.address.toLowerCase().indexOf(value)) return true;
      return false;
    },

    setLocations: function( locations ) {
      this.allLocations = locations;
      this.locations = locations;
    },

    moveLocation: function( data ) {
      log('**event** moveLocation', data);
      var fromLocation = this.getById( data.from );
      var toLocation = this.getById( data.to );
      if ( fromLocation.position > toLocation.position ) {
        // dragging up the list
        log( 'dragging up' );
        this.reorder( { direction: 'up', from: fromLocation, to: toLocation } );
      } else {
        // dragging down the list
        log( 'dragging down' );
        this.reorder( { direction: 'down', from: fromLocation, to: toLocation } );
      }
    },

    reorder: function( data ) {
      log( 'reorder', data, 'moving ' + data.from.position + ' to ' + data.to.position );
      data.from.position = data.to.position;

      var startMoving = false;
      ( data.direction === 'down' ? this.locations.reverse() : this.locations).forEach( function( location ) {
        if ( location.id === data.from.id ) return;
        if ( startMoving || ( location.id === data.to.id ) ) {
          startMoving = true;
          if ( data.direction === 'down' ) {
            location.position -= 1;
          } else {
            location.position += 1;
          }
          // We don't need to update the server here because the server
          // recalculates the other positions itself.
          //this._updateServer( this.move, data.from );
        }
      }, this );
      this._updateServer( this.move, data.from );
      this.emit( 'change' );
    },

    getLocations: function() {
      return this.locations;
    },

    getById: function( id ) {
      return this.locations.filter( function( obj ) {
        return ( parseInt( obj.id, 10 ) === parseInt( id, 10 ) );
      } )[0];
    },

    _updateServer: function( func, arg ) {
      setTimeout( func.bind( this, arg ), 100 );
    },

    move: function( location ) {
      log('move', location);
      var data = { id: location.id, location: location };
      reqwest({
        url: 'locations/' + location.id + '.json',
        type: 'json',
        method: 'put',
        data: data
      }).then( function(data) {
        log('move returned', data);
        this.fetch();
      }.bind( this ) ).fail( function() {
        log( 'location move failed' );
        var message = 'Moving a location failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    fetch: function() {
      reqwest({
        url: 'locations.json',
        type: 'json'
      }).then( function(data) {
        log('locations fetch returned', data);
        this.setLocations( data );
        this.emit( 'change' );
      }.bind( this ) ).fail( function() {
        log( 'location fetch failed' );
        var message = 'Fetching locations failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    }
  } );
} )();

