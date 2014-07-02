/** @jsx React.DOM */

var Triplocation = React.createClass({
  render: function() {
    return (
      <li className="location_block">
        <div className="location">
          <nav className="actions">
            <a className="btn btn-small remove-button">
              <i className="icon-minus-sign" />
              Remove
            </a>
          </nav>
          <h1 data-toggle="collapse" data-target={"#trip-address-" + this.props.id}>
            <i className="icon-resize-full" />
            {this.props.location.title}
          </h1>
          <p id={"trip-address-" + this.props.id} className="address collapse">
            {this.props.location.address}
          </p>
        </div>
      </li>
    );
  }
});

