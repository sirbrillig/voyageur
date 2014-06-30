/** @jsx React.DOM */

/* globals Triplocation */

var TriplocationsList = React.createClass({
  render: function() {
    var locationNodes = this.props.triplocations.map( function( triplocation ) {
      return <Triplocation key={triplocation.id} id={triplocation.id} location={triplocation.location} />;
    } );
    return (
      <div className="triplocations">
        {locationNodes}
      </div>
    );
  }
});

