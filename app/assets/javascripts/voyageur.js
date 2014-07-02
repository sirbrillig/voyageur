/* globals domready, reqwest, LocationsList, Trip, Library, debug, emitter, Store */

var App = function() {
  var log = debug('voyageur:App');

  return {
    initialize: function() {
      this.initializeDispatcher();
      this.renderTrip();
      this.renderLocations();
      this.getLocations();
      this.getTriplocations();
    },

    initializeDispatcher: function() {
      emitter.on( 'updateTriplocationsStore', function( triplocations ) {
        Store.triplocations.data = triplocations;
        Store.triplocations.emit( 'change', triplocations );
      }.bind( this ) );

      emitter.on( 'updateLocationsStore', function( locations ) {
        Store.locations.data = locations;
        Store.locations.emit( 'change', locations );
      }.bind( this ) );

      emitter.on( 'addToTrip', function( id ) {
        this.addTriplocation( id );
      }.bind( this ) );
    },

    addTriplocation: function( id ) {
      var tripId = this.getTripId(),
      data = { triplocation: { trip_id: tripId, location_id: id } },
      triplocation = this.createNewTriplocation( id );

      log('adding', id, 'to trip', tripId, 'data', data);

      this.storeNewTriplocation( triplocation );

      reqwest({
        url: 'triplocations/',
        type: 'json',
        method: 'post',
        data: data
      }).then( function(data) {
        log('post complete', data);
        this.getTriplocations();
      }.bind( this ) );
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

    storeNewTriplocation: function( triplocation ) {
      Store.triplocations.data.push( triplocation );
      Store.triplocations.emit( 'change', Store.triplocations.data );
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
