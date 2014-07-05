/** @jsx React.DOM */

/* globals Triplocation */

var TriplocationsList = React.createClass({ //jshint ignore:line
  render: function() {
    var locationNodes = this.props.triplocations.map( function( triplocation ) {
      return <Triplocation key={triplocation.id} id={triplocation.id} location={triplocation.location} />;
    } );
    return (
      <ul className="trip_locations">
        {locationNodes}
      </ul>
    );
  }
});

