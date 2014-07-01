/** @jsx React.DOM */

/* globals TriplocationsList, Store, debug */
var TripView = {

  log: debug('voyageur:Trip'),

  Trip: React.createClass({
    getInitialState: function() {
      TripView.log( 'triplocations initialState', Store.triplocations.data );
      return { triplocations: Store.triplocations.data };
    },

    componentDidMount: function() {
      Store.triplocations.on( 'change', this.onChange );
    },

    onChange: function() {
      TripView.log( 'triplocations changed to', Store.triplocations.data );
      this.setState( { triplocations: Store.triplocations.data } );
    },

    render: function() {
      return (
        <TriplocationsList triplocations={this.state.triplocations}/>
      );
    }
  })
};

var Trip = TripView.Trip;

