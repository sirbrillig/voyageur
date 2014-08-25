/** @jsx React.DOM */

/* globals emitter, debug */

var SearchArea = ( function() { //jshint ignore:line

  var log = debug('voyageur:SearchArea');

  return React.createClass({

    displayName: 'SearchArea',

    getInitialState: function() {
      return { value: '' };
    },

    onChange: function(event) {
      var value = event.target.value;
      log( 'onChange', value );
      if ( /^\s+/.test(value) ) return;
      this.setState({value: value});
      // TODO: debounce filtering
      emitter.emit('filterLocations', value);
    },

    render: function() {
      return (
        <input type="search" className="location-search" placeholder="Search" value={this.state.value} onChange={this.onChange} />
      );
    }
  });
})();


