/* globals domready, Trip, Library, debug, emitter */

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
      document.body.addEventListener('keyup', function(evt) {
        // pressing forward slash focuses the search field
        if (evt.keyCode === 191) this.focusSearch();
      }.bind( this ));
    },

    focusSearch: function() {
      var searchField = document.getElementsByClassName('location-search');
      if (searchField.length < 1) return;
      searchField = searchField[0];
      searchField.focus();
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
