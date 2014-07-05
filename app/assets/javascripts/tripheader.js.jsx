/** @jsx React.DOM */

var TripHeader = React.createClass({ //jshint ignore:line
  metersToMiles: function( meters ) {
    var milesPerMeter = 0.000621371;
    return (meters * milesPerMeter).toFixed(1);
  },

  render: function() {
    return (
      <div className="summary">
        <nav className="actions">
          <a id="clear_trip" className="btn btn-warning clear-trip" href={"/trips/" + this.props.id + "/clear"}>
            <i className="icon-asterisk" />
            Clear Trip
          </a>
        </nav>
        <h1>Your Trip</h1>
        <h1 id="trip-distance">
          <span className="distance">{this.metersToMiles( this.props.distance )}</span>
          <span className="distance-label"> miles total</span>
        </h1>
      </div>
    );
  }
});


