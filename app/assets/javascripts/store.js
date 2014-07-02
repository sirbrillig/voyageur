/* globals EventEmitter */

function StoreObject() {
  EventEmitter.call( this );
  return( this );
}
StoreObject.prototype = Object.create( EventEmitter.prototype );
StoreObject.prototype.data = [];
StoreObject.prototype.add = function( data ) {
  this.data.push( data );
  this.emit( 'change', this.data );
};
StoreObject.prototype.replace = function( data ) {
  this.data = data;
  this.emit( 'change', data );
};

var emitter = new StoreObject();
var Store = {
  add: function( key, data ) {
    Store[key].data.push( data );
    Store[key].emit( 'change', Store[key].data );
  },

  remove: function( key, data ) {
    var index = Store[key].data.indexOf( data );
    Store[key].data.splice( index, 1 );
    Store[key].emit( 'change', data );
  },

  replace: function( key, data ) {
    Store[key].data = data;
    Store[key].emit( 'change', data );
  }
};

Store.locations = new StoreObject();
Store.triplocations = new StoreObject();
