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

      @triplocation_ajax_spy = sinon.spy(jQuery, 'ajax')

      @location_data = { 'location': { 'address': '10 Main Street, Burlington VT', 'title': 'Location One' }, 'location_id': 5 }
      @added_location = @view.add_location(@location_data)

    afterEach ->
      @server.restore()
      @triplocation_ajax_spy.restore()
      @trip.get('triplocations').remove(@added_location)

    it 'increases the size of the triplocation collection by one', ->
      expect(@trip.get('triplocations').length).to.equal 2

    it 'adds the new triplocation to the trip collection', ->
      last_triplocation = @trip.get('triplocations').models[@trip.get('triplocations').length - 1]
      expect(last_triplocation.attributes).to.have.property('location_id', 5)

    it 'sets the new triplocation position to the end of the list', ->
      last_triplocation = @trip.get('triplocations').models[@trip.get('triplocations').length - 1]
      expect(last_triplocation.attributes).to.have.property('position', @trip.get('triplocations').length - 1)

    it 'sends the new triplocation to the server', ->
      expect(@triplocation_ajax_spy.getCall(0).args[0].type).to.equal('POST')

  describe '#stop_drag', ->
    it "triggers a 'drop' event on the view's item", ->
      listener = sinon.spy()
      @page.on('drop', listener)
      object = { item: @page }
      @view.stop_drag(null, object)
      expect(listener.called).to.be.true

  describe 'on change', ->

    beforeEach ->
      @foo_spy = sinon.spy(jQuery, 'ajax')

      @change_spy = sinon.spy(@view, 'render') # FIXME: render() is not being triggered on most of the add_location()s
      @location_data = { 'location': { 'address': '50 Main Street, Burlington VT', 'title': 'Location Two', 'id': 55 }, 'location_id': 55, 'trip_id': 1 }
      @another_added_location = @view.add_location(@location_data)

    afterEach ->
      @change_spy.restore()
      @trip.get('triplocations').remove(@another_added_location)

    it 'renders the view'#, ->
#      expect(@change_spy.called).to.be.true
