#= require spec_helper

describe "Voyageur.Models.Trip", ->

  trip = new Voyageur.Models.Trip id: 1

  describe "initialize", ->

    it "sets the id", ->
      trip.id.should.eql 1

    it "sets the user_id to the default", ->
      expect(trip.get('user_id')).to.be.null

    it "sets the distance to the default", ->
      trip.get('distance').should.eql 0

    it "sets the num_avail_locations to the default", ->
      trip.get('num_avail_locations').should.eql 0

    it "sets the triplocations to an empty collection", ->
      expect( trip.get('triplocations').models ).to.be.empty

  describe "fetch", ->

    beforeEach () ->
      @server = sinon.fakeServer.create()
      @callback = sinon.spy()
      @server.respondWith("GET", "/trips/1",
        [ 200,
        { "Content-Type": "application/json" },
        '{"id": 1, "distance": 100, "triplocations": [ { "id": 101, "location_id": 1, "position": 1, "trip_id": 1, "user_id": 1 } ] }' ])
      trip.bind 'change', @callback
      trip.fetch()
      @server.respond()

    afterEach () ->
      @server.restore()

    it "triggers the object's changed event", () ->
      expect(@callback.called).to.be.true

    it "updates the model", () ->
      expect(trip.get('distance')).to.equal(100)

    it "updates the model with triplocations", () ->
      expect(trip.get('triplocations').models).to.not.be.empty

    it "updates the model with a triplocation collection", () ->
      expect(trip.get('triplocations').constructor.name).to.equal 'Triplocations'

    it "updates the model with a triplocation object", () ->
      expect(trip.get('triplocations').models[0].constructor.name).to.equal 'Triplocation'
