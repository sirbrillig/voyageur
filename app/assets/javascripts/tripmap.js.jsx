/** @jsx React.DOM */

/* globals emitter, debug, google */

var TripMap = ( function() { //jshint ignore:line
  var log = debug( 'voyageur:TripMap' );

  return React.createClass({

    displayName: 'TripMap',

    calculateRoute: function() {
      var addresses = this.props.triplocations.reduce( function( prev, triplocation ) {
        return prev.concat( triplocation.location.address );
      }, [] );
      if ( addresses.length < 2 ) return;
      this.linkMapToGoogle( addresses );
      var startAddress = addresses.shift();
      var endAddress = addresses.pop();
      var waypoints = addresses.reduce( function( prev, address ) {
        return prev.concat( { location: address, stopover: true } );
      }, [] );
      if ( waypoints.length > 8 ) {
        // TODO: warn the user here
        log( 'Too many waypoints, map will not be accurate', waypoints );
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
      log( 'calculateRoute sending request', request );
      this.directionsService.route( request, this.updateDirections );
    },

    updateDirections: function( result, status ) {
      log( 'updateDirections', result, status );
      if ( status === google.maps.DirectionsStatus.OK ) {
        this.directionsRenderer.setDirections( result );
      } else {
        log( 'Error loading map:', result, status );
        emitter.emit( 'error', 'Loading the map failed. Try reloading the page.' );
      }
    },

    linkMapToGoogle: function( addresses ) {
      if ( ! this.state.map ) return;
      var mapUrl = 'https://www.google.com/maps/dir/' + addresses.reduce( function( previous, address ) {
        return previous + encodeURIComponent( address ) + '/';
      }, '' );
      log( 'linkMapToGoogle', mapUrl );

      google.maps.event.clearListeners( this.state.map );
      google.maps.event.addListener( this.state.map, 'click', function() {
        log( 'Going to map', mapUrl );
        window.location = mapUrl;
      } );
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
      if ( ! window.google ) {
        log( 'google is not defined' );
        var message = 'The map failed to load because Google is not reachable. Try reloading the page.';
        emitter.emit( 'error', message );
        return;
      }
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

      log( 'creating map', mapOptions );
      var map = new google.maps.Map( this.getDOMNode(), mapOptions );
      this.directionsRenderer.setMap( map );

      this.setState( { map: map } );
      this.calculateRoute();
    },

    componentWillReceiveProps : function() {
      if ( ! window.google ) {
        log( 'google is not defined' );
        var message = 'The map failed to load because Google is not reachable. Try reloading the page.';
        emitter.emit( 'error', message );
        return;
      }
      this.calculateRoute();
    }

  });
})();
