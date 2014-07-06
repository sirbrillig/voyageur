/** @jsx React.DOM */

/* globals emitter, debug, google */

var TripMapView = {
  log: debug( 'voyageur:TripMap' ),

  TripMap: React.createClass({

    calculateRoute: function() {
      var addresses = this.props.triplocations.reduce( function( prev, triplocation ) {
        return prev.concat( triplocation.location.address );
      }, [] );
      if ( addresses.length < 2 ) return;
      var startAddress = addresses.shift();
      var endAddress = addresses.pop();
      var waypoints = addresses.reduce( function( prev, address ) {
        return prev.concat( { location: address, stopover: true } );
      }, [] );
      if ( waypoints.length > 8 ) {
        // TODO: warn the user here
        TripMapView.log( 'Too many waypoints, map will not be accurate', waypoints );
        return;
      }
      var request = {
        origin: startAddress,
        destination: endAddress,
        waypoints: waypoints,
        travelMode: google.maps.TravelMode.DRIVING
      };
      if ( this.requestDirectionsTimeout ) clearTimeout( this.requestDirectionsTimeout );
      this.requestDirectionsTimeout = setTimeout( this.requestDirections.bind( this, request ), 400 );
    },

    requestDirections: function( request ) {
      TripMapView.log( 'calculateRoute sending request', request );
      this.directionsService.route( request, this.updateDirections );
    },

    updateDirections: function( result, status ) {
      TripMapView.log( 'updateDirections', result, status );
      if ( status === google.maps.DirectionsStatus.OK ) {
        this.directionsRenderer.setDirections( result );
      } else {
        TripMapView.log( 'Error loading map:', result, status );
        emitter.emit( 'error', 'Loading the map failed. Try reloading the page.' );
      }
    },

    getInitialState: function() {
      return {
        map : null
      };
    },

    getDefaultProps: function() {
      return {
        zoom: 11
      };
    },

    render: function() {
      return (
        <div className="map" id="map_canvas"></div>
      );
    },

    componentDidMount : function() {
      this.directionsService = new google.maps.DirectionsService();
      this.directionsRenderer = new google.maps.DirectionsRenderer();

      var mapOptions = {
        zoom: this.props.zoom,
        center: new google.maps.LatLng( 0, 0 ),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        overviewMapControl: false,
        scaleControl: false,
        streetViewControl: false,
        zoomControl: false,
        mapTypeControl: false
      };

      TripMapView.log( 'creating map', mapOptions );
      var map = new google.maps.Map( this.getDOMNode(), mapOptions );
      this.directionsRenderer.setMap( map );

      this.setState( { map: map } );
      this.calculateRoute();
    },

    componentWillReceiveProps : function() {
      this.calculateRoute();
    }

  })
};

var TripMap = TripMapView.TripMap; //jshint ignore:line
