#= require spec_helper

describe('Voyageur.Views.Location', function() {

  it('exists in the namespace', function() {
    expect(Voyageur.Views.Location).to.be.a('function');
  });

  describe('#add_location_to_trip', function() {
    before(function() {
      this.model = new Voyageur.Models.Location({ 'address': '10 Main Street, Burlington VT', 'title': 'Location One' });
      this.view = new Voyageur.Views.Location({'model': this.model});
      this.triplocation_spy = sinon.spy(Voyageur.Models, 'Triplocation');
      this.view.add_location_to_trip();
    });
    
    it('creates a new triplocation', function() {
      expect(this.triplocation_spy.called).to.be.true;
    });
    it('assigns the location to the new triplocation');
    it('assigns the trip id to the new triplocation');
    it('adds the new triplocation to the trip collection');
    it('sets the new triplocation position to the end of the collection');
    it('sends the trip model to the server');
    it('updates the new triplocation with the id from the server');
    it('updates the trip distance from the server');

  });

});
