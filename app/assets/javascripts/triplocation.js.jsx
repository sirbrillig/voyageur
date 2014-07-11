/** @jsx React.DOM */

/* globals emitter, debug */

var Triplocation = (function() { //jshint ignore:line

  var log = debug( 'voyageur:Triplocation' );

  return React.createClass({

    displayName: 'Triplocation',

    startDrag: function( evt ) {
      log('drag started', this.props.id);
      var dataTransfer = evt.nativeEvent.dataTransfer;
      dataTransfer.effectAllowed = 'move';
      dataTransfer.setData( 'text/plain', this.props.location.title );
      dataTransfer.setData( 'draggedItem', this.props.id );
    },

    dragOver: function( evt ) {
      evt.preventDefault();
    },

    drop: function( evt ) {
      var draggedId = parseInt( evt.dataTransfer.getData( 'draggedItem' ), 10 );
      if ( draggedId === this.props.id ) return;
      log('drag dropped from', draggedId, 'to', this.props.id );
      emitter.emit( 'moveTriplocation', { from: draggedId, to: this.props.id } );
    },

    removeFromTrip: function() {
      emitter.emit( 'removeFromTrip', this.props.id );
    },

    render: function() {
      return (
        <li className="location_block" data-triplocation-id={this.props.id} draggable="true" onDragStart={this.startDrag} onDragOver={this.dragOver} onDrop={this.drop}>
          <div className="location">
            <nav className="actions">
              <a className="btn btn-small remove-button" onClick={this.removeFromTrip}>
                <i className="icon-minus-sign" />
                Remove
              </a>
            </nav>
            <h1 data-toggle="collapse" data-target={"#trip-address-" + this.props.id}>
              <i className="icon-resize-full" />
              {this.props.location.title}
            </h1>
            <p id={"trip-address-" + this.props.id} className="address collapse">
              {this.props.location.address}
            </p>
          </div>
        </li>
      );
    }
  });
})();

