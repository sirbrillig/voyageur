/** @jsx React.DOM */

/* globals Location */

var LocationsList = React.createClass({ //jshint ignore:line
  render: function() {
    var locationNodes = this.props.locations.sort( function( loc1, loc2 ) {
      if ( loc1.position < loc2.position ) return -1;
      if ( loc1.position > loc2.position ) return 1;
      return 0;
    } ).map( function( location ) {
      return <Location key={location.id} id={location.id} title={location.title} address={location.address} />;
    } );
    return (
      <div className="locations">
        {locationNodes}
      </div>
    );
  }
});
