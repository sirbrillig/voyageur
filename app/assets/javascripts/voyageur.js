/* globals domready, reqwest, LocationsList, Trip, Library, debug, emitter, Store */

var App = function() {
  var log = debug('voyageur:App');

  return {
    initialize: function() {
      log('---- initializing App ----');
      this.initializeDispatcher();
      this.renderTrip();
      this.renderLocations();
    },

    initializeDispatcher: function() {
      emitter.on( 'updateTriplocationsStore', this.updateTriplocationsStore.bind( this ) );
      emitter.on( 'updateLocationsStore', this.updateLocationsStore.bind( this ) );
      emitter.on( 'addToTrip', this.addTriplocation.bind( this ) );
      emitter.on( 'removeFromTrip', this.removeTriplocation.bind( this ) );
    },

    updateTriplocationsStore: function( data ) {
      log( '**event** updateTriplocationsStore', data );
      Store.replace( 'triplocations', data );
    },

    updateLocationsStore: function( data ) {
      log( '**event** updateLocationsStore', data );
      Store.replace( 'locations', data );
    },

    addTriplocation: function( id ) {
      log( '**event** addToTrip', id );
      var triplocation = this.createNewTriplocation( id );
      Store.add( 'triplocations', triplocation );
    },

    removeTriplocation: function( id ) {
      log( '**event** removeFromTrip', id );
      var triplocation = Store.getById( 'triplocations', id );
      Store.remove( 'triplocations', triplocation );
    },

    createNewTriplocation: function( locationId ) {
      var tripId = this.getTripId(),
      location = Store.getById( 'locations', locationId );
      return { id: 0, trip_id: tripId, location: location };
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
