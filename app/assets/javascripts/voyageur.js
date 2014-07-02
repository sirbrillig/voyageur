/* globals domready, reqwest, LocationsList, Trip, Library, debug, emitter, Store */

var App = function() {
  var log = debug('voyageur:App');

  return {
    initialize: function() {
      log('---- initializing App ----');
      this.initializeDispatcher();
      this.renderTrip();
      this.renderLocations();
      this.getLocations();
      this.getTriplocations();
    },

    initializeDispatcher: function() {
      emitter.on( 'updateTriplocationsStore', Store.triplocations.replace.bind( Store.triplocations ) );
      emitter.on( 'updateLocationsStore', Store.locations.replace.bind( Store.locations ) );
      emitter.on( 'addToTrip', this.addTriplocation.bind( this ) );
      emitter.on( 'removeFromTrip', this.removeTriplocation.bind( this ) );
    },

    addTriplocation: function( id ) {
      var tripId = this.getTripId(),
      data = { triplocation: { trip_id: tripId, location_id: id } },
      triplocation = this.createNewTriplocation( id );

      log('adding location ' + id + ' to trip ' + tripId, 'data', data);

      Store.add( 'triplocations', triplocation );

      reqwest({
        url: 'triplocations/',
        type: 'json',
        method: 'post',
        data: data
      }).then( function() {
        this.getTriplocations();
      }.bind( this ) );
    },

    removeTriplocation: function( id ) {
      var tripId = this.getTripId(),
      triplocation = this.getTriplocationById( id );

      log('removing triplocation ' + id + ' from trip ' + tripId);

      Store.remove( 'triplocations', triplocation );

      reqwest({
        url: 'triplocations/' + id,
        type: 'json',
        method: 'delete'
      }).then( function() {
        this.getTriplocations();
      }.bind( this ) );
    },

    getTriplocationById: function( id ) {
      return Store.triplocations.data.filter( function( triplocation ) {
        return ( triplocation.id === id );
      } )[0];
    },

    getLocationById: function( id ) {
      return Store.locations.data.filter( function( location ) {
        return ( location.id === id );
      } )[0];
    },

    createNewTriplocation: function( locationId ) {
      var tripId = this.getTripId(),
      location = this.getLocationById( locationId );
      return { id: 0, trip_id: tripId, location: location };
    },

    getLocations: function() {
      reqwest({
        url: 'locations',
        type: 'json'
      }).then( function(data) {
        log('locations fetch returned', data);
        emitter.emit( 'updateLocationsStore', data );
      } );
    },

    getTriplocations: function() {
      reqwest({
        url: 'triplocations',
        type: 'json'
      }).then( function(data) {
        log('triplocations fetch returned', data);
        emitter.emit( 'updateTriplocationsStore', data );
      } );
    },

    getTripId: function() {
      var element = document.getElementsByClassName( 'trip_locations' )[0];
      return element.getAttribute( 'trip-id' );
    },

    renderLocationsList: function( locations ) {
      var element = document.getElementsByClassName( 'library_locations' )[0];
      React.renderComponent(
        LocationsList({ locations: locations }),
        element
      );
    },

    renderTrip: function() {
      var element = document.getElementsByClassName( 'trip_locations' )[0];
      React.renderComponent(
        Trip(),
        element
      );
    },

    renderLocations: function() {
      var element = document.getElementsByClassName( 'library_locations' )[0];
      React.renderComponent(
        Library(),
        element
      );
    }
  };
};


// Begin App
domready( function() {
  var app = new App();
  app.initialize();
});
