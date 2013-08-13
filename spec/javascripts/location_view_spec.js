#= require spec_helper

describe('Voyageur.Views.Location', function() {

  it('exists in the namespace', function() {
    expect(Voyageur.Views.Location).to.be.a('function');
  });

  describe('#add_location_to_trip', function() {
    before(function() {
      this.server = sinon.fakeServer.create();
      this.server.respondWith("PUT", "/trips/1",
        [ 200,
        { "Content-Type": "application/json" },
        '{"id": 1, "distance": 100, "triplocations": [ { "id": 101, "location_id": 1, "position": 1, "trip_id": 1, "user_id": 1 } ] }' ]);

      var tloc = new Voyageur.Models.Triplocation({ 'id': 4, 'position': 1 });
      this.trip = new Voyageur.Models.Trip({ 'id': 2, 'triplocations': [ tloc ] });
      this.model = new Voyageur.Models.Location({ 'address': '10 Main Street, Burlington VT', 'title': 'Location One', 'id': 5 });
      this.view = new Voyageur.Views.Location({ 'model': this.model });

      this.triplocation_spy = sinon.spy(Voyageur.Models, 'Triplocation');
      this.ajax_triplocation_spy = sinon.spy(jQuery, 'ajax');

      this.view.add_location_to_trip();

      this.server.respond();
    });
    
    it('creates a new triplocation', function() {
      expect(this.triplocation_spy.called).to.be.true;
    });

    it('assigns the location id to the new triplocation', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('location_id', this.model.id)));
    });

    it('assigns the location to the new triplocation', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('location', this.model))).to.be.true;
    });

    it('assigns the trip id to the new triplocation', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('trip_id', this.trip.id))).to.be.true;
    });

    it('adds the new triplocation to the trip collection', function() {
      expect(this.trip.triplocations).to.include(this.triplocation_spy.returnValues[0]);
    });

    it('sets the new triplocation position to the end of the list', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('position', 2))).to.be.true;
    });

    it('sends the trip model to the server', function() {
      expect(this.ajax_triplocation_spy.calledWith(sinon.match.has('trip_id', this.trip.id))).to.be.true;
    });

    it('updates the new triplocation with the id from the server', function() {
      expect(this.triplocation.get('id')).to.be.above(0);
    });

    it('updates the trip distance from the server', function() {
      expect(this.triplocation.get('distance')).to.be.above(0);
    });

  });

});
