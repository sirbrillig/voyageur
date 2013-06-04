#= require spec_helper

describe "Trip", ->
  describe "initialize", ->
    it "sets the id", ->
      trip = new Voyageur.Models.Trip id: 1
      trip.id.should.eql 1
