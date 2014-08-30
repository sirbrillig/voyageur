/** @jsx React.DOM */

/* globals TriplocationsList, debug, TripHeader */
/* globals TripMap, TripHelp, FluxStore */
var Trip = ( function() { //jshint ignore:line

  var log = debug('voyageur:Trip');

  return React.createClass({

    displayName: 'Trip',

    getInitialState: function() {
      log( 'triplocations initialState', FluxStore.getStore( 'TriplocationsStore' ).getTriplocations() );
      return {
        triplocations: FluxStore.getStore( 'TriplocationsStore' ).getTriplocations(),
        distance: FluxStore.getStore( 'TripStore' ).getDistance(),
        pending: false
      };
    },

    componentDidMount: function() {
      FluxStore.getStore('TriplocationsStore').on( 'change', this.onChange );
      FluxStore.getStore('TripStore').on( 'change', this.updateDistance );
      FluxStore.getStore('TriplocationsStore').fetch();
      FluxStore.getStore('TripStore').fetch();
    },

    updateDistance: function() {
      log( 'distance changed to', FluxStore.getStore( 'TripStore' ).getDistance() );
      this.setState( { distance: FluxStore.getStore( 'TripStore' ).getDistance(), pending: false } );
    },

    onChange: function() {
      log( 'triplocations changed to', FluxStore.getStore( 'TriplocationsStore' ).getTriplocations() );
      this.setState( { triplocations: FluxStore.getStore( 'TriplocationsStore' ).getTriplocations(), pending: true } );
    },

    render: function() {
      var map = <TripMap triplocations={this.state.triplocations} />;
      return (
        <div>
          <TripHeader distance={this.state.distance} pending={this.state.pending}/>
          {this.state.triplocations.length > 1 ? map : ''}
          <TriplocationsList triplocations={this.state.triplocations} />
          <TripHelp triplocations={this.state.triplocations} locationCount={FluxStore.getStore('LocationsStore').getLocations().length}/>
        </div>
      );
    }
  });
})();

