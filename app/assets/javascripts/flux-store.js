/* globals objectAssign, EventEmitter */

var FluxStore = {
  stores: {},

  createStore: function( emitter, key, methods ) {
    if ( FluxStore.stores[ key ] ) throw new Error( 'Cannot create store ' + key + '. That store already exists.' );
    var store = FluxStore._createStoreObject( emitter, methods );
    FluxStore.stores[ key ] = store;
    return store;
  },

  _createStoreObject: function( emitter, methods ) {
    var Obj = objectAssign( FluxStore.FluxStoreObject, EventEmitter.prototype, methods );
    var store = Object.create( Obj );
    store.emitter = emitter;
    FluxStore._bindAllMethods( store );
    store.initialize();
    return store;
  },

  _bindAllMethods: function( obj ) {
    for ( var method in obj ) {
      if ( typeof obj[method] === 'function' ) {
        obj[method] = obj[method].bind( obj );
      }
    }
  },

  getStore: function( key ) {
    return FluxStore.stores[ key ];
  },

  FluxStoreObject: {
    initialize: function() {
      console.log('default init');
    },

    bindActions: function( actions ) {
      for ( var action in actions ) {
        this.emitter.on( action, actions[action] );
      }
    }
  }
};
