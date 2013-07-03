class Voyageur.Views.Triplocation extends Backbone.View
  tagName: 'li' # FIXME: this renders the view in an li, but the view *is* an li, so you get two.

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'

  initialize: =>
    console.log "triplocation: ", @model
    @model.bind 'remove', => @model.destroy()

  render: =>
    @$el.html @template({triplocation: @model})
    this

  remove_location: (e) =>
    e.preventDefault()
    url = 'triplocations/' + @model.id + '.json'
    console.log url
    $.ajax url,
      type: 'DELETE',
      success: (data) =>
        console.log data
        # FIXME: trigger an update of the whole list
        # FIXME: update the distance
    @remove() # no need to wait
