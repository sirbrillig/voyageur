/** @jsx React.DOM */

/* globals Triplocation */

var TriplocationsList = React.createClass({ //jshint ignore:line
  setDraggedType: function( type ) {
    this.draggedType = type;
  },

  getDraggedType: function() {
    return this.draggedType;
  },

  render: function() {

    var locationNodes = this.props.triplocations.sort( function( loc1, loc2 ) {
      if ( loc1.position < loc2.position ) return -1;
      if ( loc1.position > loc2.position ) return 1;
      return 0;
    } ).map( function( triplocation ) {
      return <Triplocation key={triplocation.id} id={triplocation.id} location={triplocation.location}
      getDraggedType={this.getDraggedType} setDraggedType={this.setDraggedType} />;
    }.bind( this ) );

    return (
      <ul className="trip_locations">
        {locationNodes}
      </ul>
    );
  }
});

