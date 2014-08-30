/* globals domready, Trip, Library, debug, emitter, FluxStore */

var App = function() {
  var log = debug('voyageur:App');

  return {
    initialize: function() {
      log('---- initializing App ----');
      emitter.on( 'error', this.warnUser.bind( this ) );
      this.renderLocations();
      this.renderTrip();
      this.listenToTyping();
    },

    listenToTyping: function() {
      document.body.addEventListener('keydown', function(evt) {
        // pressing up and down changes the selected location
        if (evt.keyCode === 40) {
          evt.preventDefault();
          this.moveSelectDown();
        }
        if (evt.keyCode === 38) {
          evt.preventDefault();
          this.moveSelectUp();
        }
        // pressing enter adds the selected location
        if (evt.keyCode === 13) this.addSelectedLocationToTrip();
      }.bind( this ));
    },

    getSearchField: function() {
      var searchField = document.getElementsByClassName('location-search');
      if (searchField.length < 1) return;
      return searchField[0];
    },

    moveSelectUp: function() {
      emitter.emit('decrementSelectedIndex');
      this.scrollToLocation();
    },

    moveSelectDown: function() {
      emitter.emit('incrementSelectedIndex');
      this.scrollToLocation();
    },

    scrollToLocation: function() {
      var element = document.getElementsByClassName('selected-location')[0];
      if ( ! element ) return;
      window.scrollTo( 0, element.offsetTop - ( window.innerHeight / 2 ) );
    },

    addSelectedLocationToTrip: function() {
      var selectedLocation = FluxStore.getStore('LocationsStore').getSelectedLocation();
      log('addSelectedLocationToTrip', selectedLocation);
      if ( selectedLocation ) emitter.emit( 'addLocationToTrip', selectedLocation.id );
    },

    warnUser: function( message ) {
      log( '**event** error', message );
      if ( this.warnUserTimeout ) clearTimeout( this.warnUserTimeout );
      // Throttle actual warnings to prevent overwhelming the user with alerts.
      this.warnUserTimeout = setTimeout( this._warnUser.bind( this, message ), 400 );
    },

    _warnUser: function( message ) {
      console.warn( message );
      alert( message );
    },

    renderTrip: function() {
      var element = document.getElementsByClassName( 'trip' )[0];
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
  if ( ! /locations$/.test(window.location) ) return;
  var app = new App();
  app.initialize();
});
