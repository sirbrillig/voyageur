#= require spec_helper

describe('Voyageur.Views.Location', function() {

  it('exists in the namespace', function() {
    expect(Voyageur.Views.Location).to.be.a('function');
  });

  describe('#add_location_to_trip', function() {
    before(function() {
      this.trip_stub = sinon.stub(Voyageur, 'get_trip_id').returns(2);

      Voyageur.trip_view = new Voyageur.Views.Trip();
      Voyageur.trip_view.add_location({ 'id': 4, 'position': 1});
      this.trip = Voyageur.trip_view.model;
      this.model = new Voyageur.Models.Location({ 'address': '10 Main Street, Burlington VT', 'title': 'Location One', 'id': 5 });
      this.view = new Voyageur.Views.Location({ 'model': this.model });

      this.trip_view_spy = sinon.spy(Voyageur.trip_view, 'add_location');
      this.triplocation_spy = sinon.spy(this.model, 'triplocation_json');

      this.view.add_location_to_trip();
    });
    
    it('creates triplocation data from the location', function() {
      expect(this.triplocation_spy.called).to.be.true;
    });

    it('assigns the location id to the new triplocation', function() {
      expect(this.triplocation_spy.returnValues[0]).to.have.property('location_id', this.model.get('id'));
    });

    it('assigns the location to the new triplocation', function() {
      expect(this.triplocation_spy.returnValues[0]).to.have.property('location', this.model);
    });

    it('assigns the trip id to the new triplocation', function() {
      expect(this.triplocation_spy.returnValues[0]).to.have.property('trip_id', this.trip.get('id'));
    });

    it('adds the triplocation data to the trip', function() {
      expect(this.trip_view_spy.called).to.be.true;
    });

  });

});
