#= require spec_helper

describe "Trip", ->

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

    afterEach () ->
      @server.restore()

    it "triggers the object's changed event", () ->
      @server.respondWith("GET", "/trips/1", [ 200, { "Content-Type": "application/json" }, '{"id": 1, "distance": 100 }' ])
      trip.bind 'change', @callback
      trip.fetch()
      @server.respond()
      expect(@callback.called).to.be.true
