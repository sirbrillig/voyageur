#= require spec_helper

describe "Voyageur.Views.Trip", ->

  before ->
    @view = new Voyageur.Views.Trip
    triplocation = new Voyageur.Models.Triplocation id: 101
    model = new Voyageur.Models.Trip id: 1
    model.get('triplocations').add triplocation
    @view.model = model

  it "can contain a trip", ->
    expect(@view.model.constructor.name).to.equal('Trip')

  it "can contain a trip with triplocations", ->
    expect(@view.model.get('triplocations').models).to.not.be.empty

  describe "#clear_trip", ->

    beforeEach ->
      @view.trigger('click a.clear-trip') # FIXME: that's not right. may need to refactor the code itself to allow for a spy

    it "empties the model's collection of triplocations", ->
      expect(@view.model.get('triplocations').models).to.be.empty
