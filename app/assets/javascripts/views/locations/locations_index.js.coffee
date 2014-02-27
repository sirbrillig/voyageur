class Voyageur.Views.LocationsIndex extends Backbone.View
  el: '.library_locations'

  template: JST['locations/index']

  initialize: (trip) =>
    @collection = new Voyageur.Collections.Locations
    @collection.on 'sync', @render
    @collection.fetch()
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
        loc.set('position': index + 1)
        loc.save() # FIXME: this triggers a render, even if silent

      location_view = new Voyageur.Views.Location model: loc
      location_area.append location_view.render().el
    this
