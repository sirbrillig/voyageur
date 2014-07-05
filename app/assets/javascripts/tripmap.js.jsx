/** @jsx React.DOM */

var TripMap = React.createClass({ //jshint ignore:line
  render: function() {
    var map = (
      <div id="map_canvas" />
    );
    return (
      <div className="map">
        {this.props.triplocations.length > 1 ? map : ''}
      </div>
    );
  }
});



