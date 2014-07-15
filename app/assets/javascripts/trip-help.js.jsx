/** @jsx React.DOM */

var TripHelp = React.createClass({ //jshint ignore:line
  getHelpBox: function() {
    if ( this.props.triplocations.length === 1 ) {
      return (
        <div className="help_box">
          <i className="icon-bell" />
          <h1> Add another location to this trip from your Locations.</h1>
        </div>
      );
    } else if ( this.props.triplocations.length === 0 ) {
      if ( this.props.locationCount > 1 ) {
        return (
          <div className="help_box">
            <i className="icon-bell" />
            <h1> Add a location to this trip from your Locations.</h1>
          </div>
        );
      } else if ( this.props.locationCount === 1 ) {
        return (
          <div className="help_box">
            <i className="icon-bell" />
            <h1> Add another location to the list by clicking the 'Add Location' button.</h1>
          </div>
        );
      } else if ( this.props.locationCount === 0 ) {
        return (
          <div className="help_box">
            <i className="icon-bell" />
            <h1> Add a location to the list by clicking the 'Add Location' button.</h1>
          </div>
        );
      }
    }
  },

  render: function() {
    var helpBox = this.getHelpBox();
    return (
      <div className="help">
        {helpBox}
      </div>
    );
  }
});
