/** @jsx React.DOM */

/* globals LocationsList, Store, debug, emitter, reqwest */
var LibraryView = {

  log: debug('voyageur:Library'),

  Library: React.createClass({

    getLocations: function() {
      reqwest({
        url: 'locations',
        type: 'json'
      }).then( function(data) {
        LibraryView.log('locations fetch returned', data);
        emitter.emit( 'updateLocationsStore', data );
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


