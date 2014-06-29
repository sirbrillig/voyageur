/* globals domready, reqwest, EventEmitter */

domready( function() {
	reqwest({
		url: 'locations',
		type: 'json'
	}).then( function(data) {
		var emitter = new EventEmitter();
		emitter.on( 'locations', function( locations ) {
			console.log( 'locations', locations );
		} );
		emitter.emit( 'locations', data );
	} );
});
