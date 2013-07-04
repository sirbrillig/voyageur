class Voyageur.Views.Triplocation extends Backbone.View
  tagName: 'li'

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'

  initialize: =>
    console.log "triplocation: ", @model
    @model.bind 'remove', => @model.destroy()

  render: =>
    @setElement @template({triplocation: @model})
    this

  remove_location: (e) =>
    e.preventDefault()
    url = 'triplocations/' + @model.id
    console.log url
    $.ajax url,
      type: 'DELETE',
      success: () =>
        # FIXME: refresh the whole list only if the data differs from our version?
        @model.get('trip').fetch() # trigger an update of the whole list
    @remove() # no need to wait
