/** @jsx React.DOM */

/* globals LocationsList, debug, FluxStore */

var Library = ( function() { //jshint ignore:line

  var log = debug('voyageur:Library');

  return React.createClass({

    displayName: 'Library',

    getInitialState: function() {
      log( 'locations initialState', FluxStore.getStore('LocationsStore').getLocations() );
      return { locations: FluxStore.getStore('LocationsStore').getLocations() };
    },

    componentDidMount: function() {
      FluxStore.getStore('LocationsStore').on( 'change', this.onChange );
      FluxStore.getStore('LocationsStore').fetch();
    },

    onChange: function() {
      log( 'locations changed to', FluxStore.getStore('LocationsStore').getLocations() );
      this.setState( { locations: FluxStore.getStore('LocationsStore').getLocations() } );
    },

    render: function() {
      return (
        <LocationsList locations={this.state.locations} />
      );
    }
  });
})();

