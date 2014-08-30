/** @jsx React.DOM */

/* globals emitter, debug */

var SearchArea = ( function() { //jshint ignore:line

  var log = debug('voyageur:SearchArea');

  return React.createClass({

    displayName: 'SearchArea',

    getInitialState: function() {
      return { value: '', placeholderText: "Search by pressing '/'" };
    },

    componentDidMount: function() {
      document.body.addEventListener('keyup', function(evt) {
        // pressing forward slash focuses the search field
        if (evt.keyCode === 191) this.focusSearch();
        // pressing escape clears the search field
        if (evt.keyCode === 27) this.clearSearch();
        // pressing enter also clears the search (after adding takes place)
        if (evt.keyCode === 13) this.clearSearch();
      }.bind( this ));
    },

    focusSearch: function() {
      var searchField = document.querySelector('.location-search');
      if (searchField) searchField.focus();
    },

    clearSearch: function() {
      this.setState({value: ''});
      emitter.emit('filterLocations', '');
    },

    onChange: function(event) {
      var value = event.target.value;
      log( 'onChange', value );
      if ( /^\s+/.test(value) ) return;
      this.setState({value: value});
      emitter.emit('filterLocations', value);
    },

    onFocus: function() {
      var placeholderText = "Search by pressing '/'";
      if ( document.activeElement === document.querySelector('.location-search') ) placeholderText = "Search by typing here";
      this.setState({placeholderText: placeholderText});
    },

    render: function() {
      var placeholderText = "Search by pressing '/'";
      if ( document.activeElement === document.querySelector('.location-search') ) placeholderText = "Search by typing here";
      return (
        <input type="search" className="location-search"
          placeholder={this.state.placeholderText}
          value={this.state.value}
          onChange={this.onChange}
          onFocus={this.onFocus}
          onBlur={this.onFocus}
          />
      );
    }
  });
})();


