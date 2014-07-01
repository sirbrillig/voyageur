/* globals EventEmitter */

function StoreObject() {
  EventEmitter.call( this );
  return( this );
}
StoreObject.prototype = Object.create( EventEmitter.prototype );
StoreObject.prototype.data = [];

var emitter = new StoreObject();
var Store = {};

Store.locations = new StoreObject();
Store.triplocations = new StoreObject();
