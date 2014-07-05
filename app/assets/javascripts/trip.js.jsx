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
      }.bind( this ) );
    },

    getTriplocations: function() {
      reqwest({
        url: 'triplocations',
        type: 'json'
      }).then( function(data) {
        TripView.log('triplocations fetch returned', data);
        emitter.emit( 'updateTriplocationsStore', data );
      } );
    },

    getTrip: function() {
      var id = Store.get( 'trips' )[0];
      reqwest({
        url: 'trips/' + id,
        type: 'json'
      }).then( function(data) {
        TripView.log('trip fetch returned', data);
        TripView.log('distance', data.distance);
        this.setState( { distance: data.distance, id: data.id } );
      }.bind( this ) );
    },

    removeTriplocation: function( triplocation ) {
      TripView.log('removing triplocation', triplocation);
      reqwest({
        url: 'triplocations/' + triplocation.id,
        type: 'json',
        method: 'delete'
      }).then( function() {
        this.getTriplocations();
      }.bind( this ) );
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
      TripView.log( 'triplocations changed to', Store.get( 'triplocations' ) );
      this.setState( { triplocations: Store.get( 'triplocations' ) } );
      this.getTrip();
    },

    render: function() {
      return (
        <div>
          <TripHeader distance={this.state.distance} id={this.state.id} />
          <TripMap triplocations={this.state.triplocations} />
          <TriplocationsList triplocations={this.state.triplocations} />
          <TripHelp triplocations={this.state.triplocations} locationCount={Store.get('locations').length}/>
        </div>
      );
    }
  })
};

var Trip = TripView.Trip; //jshint ignore:line

