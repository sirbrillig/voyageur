class Voyageur.Views.LocationsIndex extends Backbone.View

  template: JST['locations/index']

  render: ->
    @$el.html @template(this)
    this

