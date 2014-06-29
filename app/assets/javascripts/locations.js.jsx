/** @jsx React.DOM */

/* globals Location */

var LocationsList = React.createClass({
	render: function() {
		var locationNodes = this.props.locations.map( function( location ) {
			return <Location key={location.id} id={location.id} title={location.title} address={location.address} />;
		} );
		return (
			<div className="locations">
				{locationNodes}
			</div>
		);
	}
});
