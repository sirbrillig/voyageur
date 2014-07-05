/* globals EventEmitter, debug */

function StoreObject() {
  EventEmitter.call( this );
  return( this );
}
StoreObject.prototype = Object.create( EventEmitter.prototype );
StoreObject.prototype.data = [];

var emitter = new StoreObject();
var Store = {
  log: debug('voyageur:Store'),

  add: function( key, data ) {
    Store.log('adding', key, data);
    Store[key].data.push( data );
    Store[key].emit( 'add', data );
    Store[key].emit( 'change', Store[key].data );
  },

  remove: function( key, data ) {
    Store.log('removing', key, data);
    var index = Store[key].data.indexOf( data );
    Store[key].data.splice( index, 1 );
    Store[key].emit( 'remove', data );
    Store[key].emit( 'change', Store[key].data );
  },

  replace: function( key, data ) {
    Store.log('replacing', key, data);
    Store[key].data = data;
    Store[key].emit( 'change', data );
  },

  get: function( key ) {
    return Store[key].data;
  },

  listenTo: function( key, event, callback ) {
    Store[key].on( event, callback );
  }
};

Store.locations = new StoreObject();
Store.triplocations = new StoreObject();
