#= require spec_helper

describe "Voyageur.Views.Trip", ->

  beforeEach ->
    @view = new Voyageur.Views.Trip
    @trip_stub = sinon.stub(Voyageur, 'get_trip_id').returns(1)
    @triplocation = new Voyageur.Models.Triplocation id: 101
    @trip = new Voyageur.Models.Trip id: 1
    @trip.get('triplocations').add(@triplocation)
    @view.model = @trip

  afterEach ->
    @trip_stub.restore()
    @view.remove()
    @trip.destroy()
    @triplocation.destroy()

  it "can contain a trip", ->
    expect(@view.model.constructor.name).to.equal('Trip')

  it "can contain a trip with triplocations", ->
    expect(@view.model.get('triplocations').models).to.not.be.empty

  describe "#clear_trip", ->

    beforeEach ->
      @view.clear_trip()

    it "empties the model's collection of triplocations", ->
      expect(@view.model.get('triplocations').models).to.be.empty

  describe "#meters_to_miles", ->

    it "converts 1609 meters to 1 mile", ->
      expect(@view.meters_to_miles(1609.34)).to.equal('1.0')

  describe '#add_location', ->

    beforeEach ->
      @server = sinon.fakeServer.create()
      @server.respondWith("GET", "/trips/1",
        [ 200,
        { "Content-Type": "application/json" },
        '{"id": 1, "distance": 100, "triplocations": [ { "id": 102, "location_id": 1, "position": 1, "trip_id": 1, "user_id": 1 } ] }' ])

      @location_data = { 'location': { 'address': '10 Main Street, Burlington VT', 'title': 'Location One' }, 'location_id': 5 }
      @view.add_location(@location_data)

    afterEach ->
      @server.restore()

    it 'increases the size of the triplocation collection by one', ->
      expect(@trip.get('triplocations').length).to.equal 2

    it 'adds the new triplocation to the trip collection', ->
      last_triplocation = @trip.get('triplocations').models[@trip.get('triplocations').length - 1]
      expect(last_triplocation.attributes).to.have.property('location_id', 5)

    it 'sets the new triplocation position to the end of the list', ->
      last_triplocation = @trip.get('triplocations').models[@trip.get('triplocations').length - 1]
      expect(last_triplocation.attributes).to.have.property('position', 2)

    it 'updates the new triplocation with an ID from the server', ->
      @server.respond()
      last_triplocation = @trip.get('triplocations').models[@trip.get('triplocations').length - 1]
      expect(last_triplocation.attributes).to.have.property('id', 102)
