/** @jsx React.DOM */

/* globals emitter, SearchArea, LocationsList, debug, FluxStore */

var Library = ( function() { //jshint ignore:line

  var log = debug('voyageur:Library');

  return React.createClass({

    displayName: 'Library',

    getInitialState: function() {
      log( 'locations initialState', FluxStore.getStore('LocationsStore').getLocations() );
      return {
        locations: FluxStore.getStore('LocationsStore').getLocations(),
        selectedIndex: FluxStore.getStore('LocationsStore').getSelectedIndex()
      };
    },

    componentDidMount: function() {
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
      FluxStore.getStore('LocationsStore').on( 'change', this.onChange );
      FluxStore.getStore('LocationsStore').fetch();
    },

    componentDidUpdate: function() {
      this.scrollToLocation();
    },

    onChange: function() {
      log( 'locations changed to', FluxStore.getStore('LocationsStore').getLocations(), 'with selectedIndex', FluxStore.getStore('LocationsStore').getSelectedIndex() );
      this.setState( {
        locations: FluxStore.getStore('LocationsStore').getLocations(),
        selectedIndex: FluxStore.getStore('LocationsStore').getSelectedIndex()
      } );
    },

    moveSelectUp: function() {
      emitter.emit('decrementSelectedIndex');
    },

    moveSelectDown: function() {
      emitter.emit('incrementSelectedIndex');
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

    render: function() {
      return (
        <div>
          <div className="library-info location">Press '/' to Search, 'esc' to clear, up/down to select and 'enter' to add.</div>
          <SearchArea />
          <LocationsList locations={this.state.locations} selectedIndex={this.state.selectedIndex} />
        </div>
      );
    }
  });
})();

