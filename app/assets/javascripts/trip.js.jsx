/** @jsx React.DOM */

/* globals TriplocationsList, Store, debug, reqwest, emitter, TripHeader */
/* globals TripMap, TripHelp */
var TripView = {

  log: debug('voyageur:Trip'),

  Trip: React.createClass({

    addTriplocation: function( triplocation ) {
      TripView.log('adding triplocation', triplocation);
      var data = { triplocation: { trip_id: triplocation.trip_id, location_id: triplocation.location.id } };
      reqwest({
        url: 'triplocations/',
        type: 'json',
        method: 'post',
        data: data
      }).then( function() {
        TripView.log('triplocation add complete');
        this.getTriplocations();
      }.bind( this ) ).fail( function() {
        TripView.log( 'triplocation add failed' );
        var message = 'Adding a triplocation failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    getTriplocations: function() {
      reqwest({
        url: 'triplocations',
        type: 'json'
      }).then( function(data) {
        TripView.log('triplocations fetch returned', data);
        emitter.emit( 'updateTriplocationsStore', data );
      } ).fail( function() {
        TripView.log( 'triplocation fetch failed' );
        var message = 'Fetching triplocations failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    getTrip: function() {
      var id = Store.get( 'trips' )[0];
      reqwest({
        url: 'trips/' + id,
        type: 'json'
      }).then( function(data) {
        TripView.log('trip fetch returned', data);
        if ( this.lastTripTimestamp && data.timestamp < this.lastTripTimestamp ) {
          TripView.log( 'timestamp is out of date. ignoring trip data.', data );
        } else {
          TripView.log('distance is now', data.distance);
          this.lastTripTimestamp = data.timestamp;
          this.setState( { distance: data.distance, id: data.id, pending: false } );
        }
      }.bind( this ) ).fail( function() {
        TripView.log( 'trip fetch failed' );
        var message = 'Fetching the trip failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    removeTriplocation: function( triplocation ) {
      TripView.log('removing triplocation', triplocation);
      reqwest({
        url: 'triplocations/' + triplocation.id,
        type: 'json',
        method: 'delete'
      }).then( function(data) {
        TripView.log('triplocation delete returned', data);
        this.getTriplocations();
      }.bind( this ) ).fail( function() {
        TripView.log( 'triplocation remove failed' );
        var message = 'Removing a triplocation failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    showPending: function() {
      this.setState( { pending: true  } );
    },

    moveItem: function( item ) {
      var peers = item.parentNode.childNodes,
      updatedTriplocations = [].reduce.call( peers, function( prev, peer, position ) {
        position += 1; // start positions at 1
        var itemId = peer.getAttribute( 'data-triplocation-id' ),
        triplocation = Store.getById( 'triplocations', itemId );
        if ( triplocation.position === position ) return prev;
        TripView.log( 'moving', triplocation, 'to', position );
        triplocation.position = position;
        return prev.concat( triplocation );
      }, [] );

      updatedTriplocations.reverse().forEach( function( triplocation ) {
        Store.updateById( 'triplocations', triplocation.id, triplocation );
      } );
    },

    getInitialState: function() {
      TripView.log( 'triplocations initialState', Store.get( 'triplocations' ) );
      return { triplocations: Store.get( 'triplocations' ), distance: 0 };
    },

    componentDidMount: function() {
      Store.listenTo( 'triplocations', 'add', this.addTriplocation );
      Store.listenTo( 'triplocations', 'remove', this.removeTriplocation );
      Store.listenTo( 'triplocations', 'change', this.onChange );
      this.getTriplocations();
    },

    onChange: function() {
      if ( this.onChangeTimeout ) clearTimeout( this.onChangeTimeout );
      this.onChangeTimeout = setTimeout( this._onChange, 100 );
    },

    _onChange: function() {
      TripView.log( 'triplocations changed to', Store.get( 'triplocations' ) );
      this.setState( { triplocations: Store.get( 'triplocations' ) } );
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
          <TripHelp triplocations={this.state.triplocations} locationCount={Store.get('locations').length}/>
        </div>
      );
    }
  })
};

var Trip = TripView.Trip; //jshint ignore:line

