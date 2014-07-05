/* globals EventEmitter, debug */

function StoreObject() {
  EventEmitter.call( this );
  this.data = [];
  return( this );
}
StoreObject.prototype = Object.create( EventEmitter.prototype );

var emitter = new StoreObject();
var Store = {
  log: debug('voyageur:Store'),

  stores: {},

  createKey: function( key ) {
    if ( ! Store.stores[key] ) {
      Store.log('creating new store key', key);
      Store.stores[key] = new StoreObject();
    }
  },

  add: function( key, data ) {
    Store.log('### adding', key, data);
    Store.createKey( key );
    Store.stores[key].data.push( data );
    Store.stores[key].emit( 'add', data );
    Store.stores[key].emit( 'change', Store.stores[key].data );
  },

  remove: function( key, data ) {
    Store.log('### removing', key, data);
    Store.createKey( key );
    var index = Store.stores[key].data.indexOf( data );
    Store.stores[key].data.splice( index, 1 );
    Store.stores[key].emit( 'remove', data );
    Store.stores[key].emit( 'change', Store.stores[key].data );
  },

  replace: function( key, data ) {
    Store.log('### replacing', key, data);
    Store.createKey( key );
    Store.stores[key].data = data;
    Store.stores[key].emit( 'change', data );
  },

  get: function( key ) {
    Store.createKey( key );
    return Store.stores[key].data;
  },

  getById: function( key, id ) {
    return Store.get( key ).filter( function( obj ) {
      return ( obj.id === id );
    } )[0];
  },

  listenTo: function( key, event, callback ) {
    Store.createKey( key );
    Store.stores[key].on( event, callback );
  }
};
