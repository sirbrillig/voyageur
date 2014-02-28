class Voyageur.Views.LocationsIndex extends Backbone.View
  el: '.library_locations'

  template: JST['locations/index']

  initialize: (trip) =>
    @collection = new Voyageur.Collections.Locations
    @collection.fetch success: =>
      @render()
    $('.library_locations').sortable
      items: ".location"
      opacity: 0.5
      revert: "invalid"
      stop: @stop_drag

  stop_drag: (event, ui) =>
    ui.item.trigger('drop', ui.item.index())

  render: () =>
    @$el.html @template()
    location_area = $('.locations')
    @collection.sort()
    @collection.each (loc, index) =>

      # Set initial positions, in case they are unset
      if null == loc.get('position')
        if window.location.search.match(/debugMode=true/)
          console.log 'no position set on Location', loc, 'setting it to', index + 1
        loc.set('position': index + 1)
        loc.save()

      if window.location.search.match(/debugMode=true/)
        console.log 'rendering Location', loc
      location_view = new Voyageur.Views.Location model: loc
      location_area.append location_view.render().el
    this
