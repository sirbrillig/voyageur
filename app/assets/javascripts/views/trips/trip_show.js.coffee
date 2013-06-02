class Voyageur.Views.Trip extends Backbone.View

  template: JST['trips/show']

  render: () ->
    @$el.html @template( { trip: @model, distance: @meters_to_miles(@model.get('distance')) } )
    this

  meters_to_miles: (meters) ->
    miles_per_meter = 0.000621371
    (meters * miles_per_meter).toFixed(1)
