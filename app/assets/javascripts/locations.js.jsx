/** @jsx React.DOM */

/* globals Location */

var LocationsList = React.createClass({ //jshint ignore:line
  setDraggedType: function( type ) {
    this.draggedType = type;
  },

  getDraggedType: function() {
    return this.draggedType;
  },

  render: function() {

    var locationNodes = this.props.locations.sort( function( loc1, loc2 ) {
      if ( loc1.position < loc2.position ) return -1;
      if ( loc1.position > loc2.position ) return 1;
      return 0;
    } ).map( function( location ) {
      return <Location key={location.id} id={location.id} title={location.title} address={location.address}
      getDraggedType={this.getDraggedType} setDraggedType={this.setDraggedType} />;
    }.bind( this ) );

    return (
      <div className="locations">
        {locationNodes}
      </div>
    );
  }
});
