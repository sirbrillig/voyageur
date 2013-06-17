class Voyageur.Views.Triplocation extends Backbone.View
  #FIXME: this needs to render its models inside the trip list and do its
  #binding to that list as well

  el: '.trip_locations'

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'

  initialize: =>
    console.log "triplocations: ", @collection
    @render()

  render: =>
    @$el.html @template({triplocations: @collection})
    this

  remove_location: (e) =>
    e.preventDefault()
    # FIXME: do this
