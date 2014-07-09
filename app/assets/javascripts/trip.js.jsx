/** @jsx React.DOM */

/* globals TriplocationsList, debug, reqwest, emitter, TripHeader */
/* globals TripMap, TripHelp, FluxStore, getTripId */
var Trip = ( function() { //jshint ignore:line

  var log = debug('voyageur:Trip');

  return React.createClass({

    getTrip: function() {
      var id = getTripId();
      reqwest({
        url: 'trips/' + id + '.json',
        type: 'json'
      }).then( function(data) {
        log('trip fetch returned', data);
        if ( this.lastTripTimestamp && data.timestamp < this.lastTripTimestamp ) {
          log( 'timestamp is out of date. ignoring trip data.', data );
        } else {
          log('distance is now', data.distance);
          this.lastTripTimestamp = data.timestamp;
          this.setState( { distance: data.distance, id: data.id, pending: false } );
        }
      }.bind( this ) ).fail( function() {
        log( 'trip fetch failed' );
        var message = 'Fetching the trip failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    showPending: function() {
      this.setState( { pending: true  } );
    },

    // TODO: this is not implemented yet
    //moveItem: function( item ) {
    //var peers = item.parentNode.childNodes,
    //updatedTriplocations = [].reduce.call( peers, function( prev, peer, position ) {
    //position += 1; // start positions at 1
    //var itemId = peer.getAttribute( 'data-triplocation-id' ),
    //triplocation = Store.getById( 'triplocations', itemId );
    //if ( triplocation.position === position ) return prev;
    //log( 'moving', triplocation, 'to', position );
    //triplocation.position = position;
    //return prev.concat( triplocation );
    //}, [] );
    //
    //updatedTriplocations.reverse().forEach( function( triplocation ) {
    //Store.updateById( 'triplocations', triplocation.id, triplocation );
    //} );
    //},

    getInitialState: function() {
      log( 'triplocations initialState', FluxStore.getStore( 'TriplocationsStore' ).getTriplocations() );
      return { triplocations: FluxStore.getStore( 'TriplocationsStore' ).getTriplocations(), distance: 0 };
    },

    componentDidMount: function() {
      FluxStore.getStore('TriplocationsStore').on( 'change', this.onChange );
      FluxStore.getStore('TriplocationsStore').fetch();
    },

    onChange: function() {
      if ( this.onChangeTimeout ) clearTimeout( this.onChangeTimeout );
      this.onChangeTimeout = setTimeout( this._onChange, 100 );
    },

    _onChange: function() {
      log( 'triplocations changed to', FluxStore.getStore( 'TriplocationsStore' ).getTriplocations() );
      this.setState( { triplocations: FluxStore.getStore( 'TriplocationsStore' ).getTriplocations() } );
      this.showPending();
      // Give the database time to update.
      if ( this.gettingTrip ) clearTimeout( this.gettingTrip );
      this.gettingTrip = setTimeout( this.getTrip, 200 );
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

