#= require spec_helper

describe('Voyageur.Views.Location', function() {

  it('exists in the namespace', function() {
    expect(Voyageur.Views.Location).to.be.a('function');
  });

  describe('#add_location_to_trip', function() {
    before(function() {
      tloc = new Voyageur.Models.Triplocation({ 'id': 4, 'position': 1 });
      this.trip = new Voyageur.Models.Trip({ 'id': 2, 'triplocations': [ tloc ] });
      this.model = new Voyageur.Models.Location({ 'address': '10 Main Street, Burlington VT', 'title': 'Location One', 'id': 5 });
      this.view = new Voyageur.Views.Location({ 'model': this.model });
      this.triplocation_spy = sinon.spy(Voyageur.Models, 'Triplocation');
      this.view.add_location_to_trip();
    });
    
    it('creates a new triplocation', function() {
      expect(this.triplocation_spy.called).to.be.true;
    });

    it('assigns the location id to the new triplocation', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('location_id', this.model.id));
    });

    it('assigns the location to the new triplocation', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('location', this.model));
    });

    it('assigns the trip id to the new triplocation', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('trip_id', this.trip.id));
    });

    it('adds the new triplocation to the trip collection', function() {
      expect(this.trip.triplocations).to.include(this.triplocation_spy.returnValues[0]);
    });

    it('sets the new triplocation position to the end of the list', function() {
      expect(this.triplocation_spy.returned(sinon.match.has('position', 2));
    });

    it('sends the trip model to the server');
    it('updates the new triplocation with the id from the server');
    it('updates the trip distance from the server');

  });

});
