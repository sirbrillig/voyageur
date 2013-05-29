class Voyageur.Views.Trip extends Backbone.View

  template: JST['trips/show']

  render: () ->
    @$el.html @template( { trip: @model } )
    this
