/** @jsx React.DOM */

var Location = React.createClass({
	render: function() {
		return (
			<li className="location">
				<nav className="actions">
					<a className="btn btn-small edit-button" href={"/locations/" + this.props.id + "/edit"}>
						<i className="icon-edit" />
						Edit
					</a>
					&nbsp;
					<a className="btn btn-small add-button btn-custom">
						<i className="icon-road" />
						Add
					</a>
				</nav>
				<h1 data-toggle="collapse" data-target={"#address-" + this.props.id}>
					<i className="icon-resize-full" />
					{this.props.title}
				</h1>
				<p id={"address-" + this.props.id} className="address collapse">
					{this.props.address}
				</p>
			</li>
		);
	}
});

