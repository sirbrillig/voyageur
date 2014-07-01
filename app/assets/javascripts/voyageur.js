/* globals domready, reqwest, EventEmitter, LocationsList, TriplocationsList, debug */

var StoreObject = function() {
  EventEmitter.call( this );
  return( this );
};
StoreObject.prototype = Object.create( EventEmitter.prototype );
StoreObject.prototype.data = [];

var emitter = new StoreObject();
var log = debug('voyageur');

// Control Functions

var App = function() {
  return {
    initialize: function() {
      this.initializeDispatcher();
      this.initializeStore();
      this.initializeStoreListeners();
      this.getLocations();
      this.getTriplocations();
    },

    initializeDispatcher: function() {
      emitter.on( 'updateTriplocationsStore', function( triplocations ) {
        this.store.triplocations.data = triplocations;
        this.store.triplocations.emit( 'change', triplocations );
      }.bind( this ) );

      emitter.on( 'updateLocationsStore', function( locations ) {
        this.store.locations.data = locations;
        this.store.locations.emit( 'change', locations );
      }.bind( this ) );

      emitter.on( 'addToTrip', function( id ) {
        this.addTriplocation( id );
      }.bind( this ) );
    },

    initializeStore: function() {
      this.store = {};
      this.store.locations = new StoreObject();
      this.store.triplocations = new StoreObject();
    },

    initializeStoreListeners: function() {
      this.store.locations.on( 'change', this.renderLocationsList );
      this.store.triplocations.on( 'change', this.renderTriplocationsList );
    },

    addTriplocation: function( id ) {
      var tripId = this.getTripId(),
      data = { triplocation: { trip_id: tripId, location_id: id } },
      location = this.getLocationById( id ),
      triplocation = { id: 0, location: location };

      log('adding', id, 'to trip', tripId, 'data', data);

      this.addTriplocationToData( triplocation );

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
      return this.store.locations.data.filter( function( location ) {
        return ( location.id === id );
      } )[0];
    },

    addTriplocationToData: function( triplocation ) {
      this.store.triplocations.data.push( triplocation );
      this.store.triplocations.emit( 'change', this.store.triplocations.data );
    },

    getLocations: function() {
      reqwest({
        url: 'locations',
        type: 'json'
      }).then( function(data) {
        emitter.emit( 'updateLocationsStore', data );
      } );
    },

    getTriplocations: function() {
      reqwest({
        url: 'triplocations',
        type: 'json'
      }).then( function(data) {
        log('triplocations', data);
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

    renderTriplocationsList: function( triplocations ) {
      var element = document.getElementsByClassName( 'trip_locations' )[0];
      React.renderComponent(
        TriplocationsList({ triplocations: triplocations }),
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
