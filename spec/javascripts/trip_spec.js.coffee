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
    it "sets the triplocations to the default", ->
      trip.get('triplocations').should.be.empty
  describe "fetch", ->
    it "returns the trip", (done) ->
      trip.fetch success: (newtrip) ->
        newtrip.id.should.eql 1
        done()
