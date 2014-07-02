/** @jsx React.DOM */

/* globals LocationsList, Store, debug */
var LibraryView = {

  log: debug('voyageur:Library'),

  Library: React.createClass({
    getInitialState: function() {
      LibraryView.log( 'locations initialState', Store.locations.data );
      return { locations: Store.locations.data };
    },

    componentDidMount: function() {
      Store.locations.on( 'change', this.onChange );
    },

    onChange: function() {
      LibraryView.log( 'locations changed to', Store.locations.data );
      this.setState( { locations: Store.locations.data } );
    },

    render: function() {
      return (
        <LocationsList locations={this.state.locations}/>
      );
    }
  })
};

var Library = LibraryView.Library;


