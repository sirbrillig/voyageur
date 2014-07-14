/** @jsx React.DOM */

/* globals emitter, debug */

var Location = (function() { // jshint ignore:line

  var log = debug( 'voyageur:Location' );

  return React.createClass({

    displayName: 'Location',

    getInitialState: function() {
      return { moving: false, movingOver: false };
    },

    startDrag: function( evt ) {
      log('drag started', this.props.id);
      var dataTransfer = evt.nativeEvent.dataTransfer;
      dataTransfer.effectAllowed = 'move';
      dataTransfer.setData( 'librarylocation', true );
      dataTransfer.setData( 'draggedItem', this.props.id );
      this.setState( { moving: true } );
    },

    dragOver: function( evt ) {
      var types = evt.dataTransfer.types;
      if ( ! types ) {
        console.error( 'dataTransfer types not found when dragging. dataTransfer=', evt.dataTransfer );
        return;
      }
      var sameType = types.contains( 'librarylocation' );
      if ( ! sameType ) return true;
      evt.preventDefault();
      this.setState( { movingOver: true } );
    },

    dragLeave: function() {
      this.setState( { movingOver: false } );
    },

    dragEnd: function() {
      this.setState( { moving: false, movingOver: false } );
    },

    drop: function( evt ) {
      var draggedId = parseInt( evt.dataTransfer.getData( 'draggedItem' ), 10 );
      this.setState( { moving: false, movingOver: false } );
      if ( draggedId === this.props.id ) return;
      log('drag dropped from', draggedId, 'to', this.props.id );
      emitter.emit( 'moveLocation', { from: draggedId, to: this.props.id } );
    },

    addToTrip: function() {
      emitter.emit( 'addLocationToTrip', this.props.id );
    },

    render: function() {
      return (
        <li className={"location" + ( this.state.movingOver ? ' moving-over' : '' ) + ( this.state.moving ? ' moving' : '' )}
          data-triplocation-id={this.props.id}
          data-library-position={this.props.position}
          draggable="true"
          onDragStart={this.startDrag}
          onDragOver={this.dragOver}
          onDragLeave={this.dragLeave}
          onDragEnd={this.dragEnd}
          onDrop={this.drop} >
          <nav className="actions">
            <a className="btn btn-small edit-button" href={"/locations/" + this.props.id + "/edit"}>
              <i className="icon-edit" />
              Edit
            </a>
            &nbsp;
            <a className="btn btn-small add-button btn-custom" onClick={this.addToTrip}>
              <i className="icon-road" />
              Add
            </a>
          </nav>
          <h1 data-toggle="collapse" data-target={"#address-" + this.props.id}>
            <i className="icon-resize-full" />
            {this.props.title}
          </h1>
          <p id={"address-" + this.props.id} className="address collapse">
            {this.props.address}
          </p>
        </li>
      );
    }
  });
})();
