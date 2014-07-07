/** @jsx React.DOM */

/* globals LocationsList, Store, debug, emitter, reqwest */
var LibraryView = {

  log: debug('voyageur:Library'),

  Library: React.createClass({

    getLocations: function() {
      reqwest({
        url: 'locations.json',
        type: 'json'
      }).then( function(data) {
        LibraryView.log('locations fetch returned', data);
        emitter.emit( 'updateLocationsStore', data );
      } ).fail( function() {
        LibraryView.log( 'locations fetch failed' );
        var message = 'Fetching the locations failed because the request returned an error. Try reloading the page.';
        emitter.emit( 'error', message );
      } );
    },

    getInitialState: function() {
      LibraryView.log( 'locations initialState', Store.get( 'locations' ) );
      return { locations: Store.get( 'locations' ) };
    },

    componentDidMount: function() {
      Store.listenTo( 'locations', 'change', this.onChange );
      this.getLocations();
    },

    onChange: function() {
      LibraryView.log( 'locations changed to', Store.get( 'locations' ) );
      this.setState( { locations: Store.get( 'locations' ) } );
    },

    render: function() {
      return (
        <LocationsList locations={this.state.locations}/>
      );
    }
  })
};

var Library = LibraryView.Library;


