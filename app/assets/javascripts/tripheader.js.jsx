/** @jsx React.DOM */

/* globals emitter */

var TripHeader = React.createClass({ //jshint ignore:line
  metersToMiles: function( meters ) {
    var milesPerMeter = 0.000621371;
    return (meters * milesPerMeter).toFixed(1);
  },

  clearTrip: function() {
    emitter.emit( 'clearTrip' );
  },

  render: function() {
    return (
      <div className="summary">
        <nav className="actions">
          <a id="clear_trip" className="btn btn-warning clear-trip" onClick={this.clearTrip}>
            <i className="icon-asterisk" />
            Clear Trip
          </a>
        </nav>
        <h1>Your Trip</h1>
        <h1 id="trip-distance">
          <span className={"distance" + (this.props.pending ? ' hidden' : '')}>{this.metersToMiles( this.props.distance )}</span>
          <span className={"distance distance-label" + (this.props.pending ? ' hidden' : '')}> miles total</span>
          <span className={"distance distance-pending" + (this.props.pending ? '' : ' hidden')}>loading distance...</span>
        </h1>
      </div>
    );
  }
});


