class Voyageur.Views.Triplocation extends Backbone.View
  tagName: 'li'

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'

  initialize: =>
#    console.log "triplocation: ", @model
#    @model.bind 'remove', => @model.destroy() # FIXME: this would also trigger on a move

  render: =>
    @setElement @template({triplocation: @model})
    this

  remove_location: (e) =>
    e.preventDefault() if e
    url = 'triplocations/' + @model.id
    $.ajax url,
      type: 'DELETE',
      success: () =>
        @model.get('trip').fetch() # trigger an update of the whole list
    @remove() # no need to wait
    @model.destroy()
