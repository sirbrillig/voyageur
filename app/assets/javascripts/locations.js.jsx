/** @jsx React.DOM */

/* globals Location */

var LocationsList = React.createClass({ //jshint ignore:line
  render: function() {
    var locationNodes = this.props.locations.sort( function( loc1, loc2 ) {
      if ( loc1.position < loc2.position ) return -1;
      if ( loc1.position > loc2.position ) return 1;
      return 0;
    } ).map( function( location, index ) {
      var selected = this.isLocationSelected( index );
      return <Location key={location.id} id={location.id} title={location.title} address={location.address} position={location.position} selected={selected}/>;
    }.bind( this ) );
    return (
      <div className="locations">
        {locationNodes}
      </div>
    );
  },

  isLocationSelected: function( index ) {
    return ( index === this.props.selectedIndex );
  }
});
