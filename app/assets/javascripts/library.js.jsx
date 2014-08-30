/** @jsx React.DOM */

/* globals SearchArea, LocationsList, debug, FluxStore */

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
      FluxStore.getStore('LocationsStore').on( 'change', this.onChange );
      FluxStore.getStore('LocationsStore').fetch();
    },

    onChange: function() {
      log( 'locations changed to', FluxStore.getStore('LocationsStore').getLocations(), 'with selectedIndex', FluxStore.getStore('LocationsStore').getSelectedIndex() );
      this.setState( {
        locations: FluxStore.getStore('LocationsStore').getLocations(),
        selectedIndex: FluxStore.getStore('LocationsStore').getSelectedIndex()
      } );
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

