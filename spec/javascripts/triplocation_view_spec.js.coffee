#= require spec_helper

describe "Voyageur.Views.Triplocation", ->
  before ->
    @trip_stub = sinon.stub(Voyageur, 'get_trip_id').returns(1)
    Voyageur.trip_view = new Voyageur.Views.Trip

  after ->
    @trip_stub.restore()

  describe "#remove_location", ->
    beforeEach ->
      @triplocation = new Voyageur.Models.Triplocation position: 1, id: 101
      @triplocation_view = new Voyageur.Views.Triplocation model: @triplocation
      Voyageur.trip_view.model.get('triplocations').add(@triplocation)
      @triplocation_ajax_spy = sinon.spy(jQuery, 'ajax')
      @triplocation_view.remove_location()

    afterEach ->
      @triplocation_ajax_spy.restore()
      @triplocation.destroy()

    it "removes the Triplocation model from the collection", ->
      expect(Voyageur.trip_view.model.get('triplocations').contains(@triplocation)).to.be.false

    it "sends the removal to the server", ->
      expect(@triplocation_ajax_spy.called).to.be.true

  describe '#drop', ->
    beforeEach ->
      @triplocation = new Voyageur.Models.Triplocation position: 0, id: 101
      @triplocation_2 = new Voyageur.Models.Triplocation position: 1, id: 102
      @triplocation_view = new Voyageur.Views.Triplocation model: @triplocation
      Voyageur.trip_view.model.get('triplocations').add(@triplocation)
      Voyageur.trip_view.model.get('triplocations').add(@triplocation_2)
      @listener = sinon.spy()
      @triplocation_view.$el.on('update-sort', @listener)
      @triplocation_view.drop(null, 1)

    afterEach ->
      @triplocation.destroy()
      @triplocation_2.destroy()

    it "triggers an 'update-sort' event on the DOM element", ->
      expect(@listener.called).to.be.true

    it "passes the model and index to the 'update-sort' event", ->
      expect(@listener.calledWith(@listener.args[0][0], @triplocation, 1)).to.be.true
