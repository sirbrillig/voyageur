/* globals domready, reqwest, EventEmitter, LocationsList, TriplocationsList */

var emitter = new EventEmitter();
var Store = { locations: [], triplocations: [] };
var StoreObject = function() {
  EventEmitter.call( this );
  return( this );
};

// Control Functions

var App = function() {
  return {
    initialize: function() {
      this.initializeDispatcher();
      this.store = new StoreObject();
      this.initializeStoreListeners();
      this.getLocations();
      this.getTriplocations();
    },

    initializeDispatcher: function() {
      emitter.on( 'updateTriplocationsStore', function( triplocations ) {
        Store.triplocations = triplocations;
        this.renderTriplocationsList( triplocations );
      }.bind( this ) );

      emitter.on( 'updateLocationsStore', function( locations ) {
        Store.locations = locations;
        this.renderLocationsList( locations );
      }.bind( this ) );

      emitter.on( 'addToTrip', function( id ) {
        this.addTriplocation( id );
      }.bind( this ) );
    },

    initializeStoreListeners: function() {
      //this.store.locations.on( 'change', this.renderLocationsList );
    },

    addTriplocation: function( id ) {
      var tripId = this.getTripId(),
      data = { triplocation: { trip_id: tripId, location_id: id } },
      location = this.getLocationById( id ),
      triplocation = { id: 0, location: location };

      console.log('adding', id, 'to trip', tripId, 'data', data);

      this.addTriplocationToData( triplocation );

      reqwest({
        url: 'triplocations/',
        type: 'json',
        method: 'post',
        data: data
      }).then( function(data) {
        console.log('post complete', data);
        this.getTriplocations();
      }.bind( this ) );
    },

    getLocationById: function( id ) {
      return Store.locations.filter( function( location ) {
        return ( location.id === id );
      } )[0];
    },

    addTriplocationToData: function( triplocation ) {
      Store.triplocations.push( triplocation );
      this.renderTriplocationsList( Store.triplocations );
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
        console.log('triplocations', data);
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
