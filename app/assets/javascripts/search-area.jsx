/** @jsx React.DOM */

/* globals emitter, debug */

var SearchArea = ( function() { //jshint ignore:line

  var log = debug('voyageur:SearchArea');

  return React.createClass({

    displayName: 'SearchArea',

    getInitialState: function() {
      return { value: '', placeholderText: "Search by pressing '/'" };
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


