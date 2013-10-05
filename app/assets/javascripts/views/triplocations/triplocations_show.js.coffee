class Voyageur.Views.Triplocation extends Backbone.View
  tagName: 'li'

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'
    'drop': 'drop'

  initialize: =>
    @model.on 'sync', @render_distance

  render: =>
    @setElement @template({triplocation: @model})
    this

  render_distance: (collection, triplocation) =>
    $('#trip-distance').find('.distance').html( @meters_to_miles( triplocation.distance ) )

  remove_location: (e) =>
    e.preventDefault() if e
    @model.destroy()
    @remove()

  drop: (e, index) =>
    @$el.trigger 'update-sort', [ @model, index ]

  meters_to_miles: (meters) ->
    miles_per_meter = 0.000621371
    (meters * miles_per_meter).toFixed(1)

