###
Usage:
* add model.name property that will be used as a namespace in the json request
* put this code before your Backbone app code
* use toJSON() as usual (so there is no namespacing in your templates)
* your model's data will be sent under model.name key when calling save()
###

# save reference to Backbone.sync
Backbone.oldSync = Backbone.sync

# override original method
Backbone.sync = (method, model, options) ->
  if window.Voyageur.disable_connection_checking
    Backbone.rails_sync(method, model, options)
  else
    window.Voyageur.check_connection( () ->
      Backbone.rails_sync(method, model, options)
    )

Backbone.rails_sync = (method, model, options) ->
  # save reference to original toJSON()
  model.oldToJSON = model.toJSON

  # override this model instance toJSON() method
  model.toJSON = ->
    json = {}
    # namespace original json values under model.name key
    json[model.name] = @oldToJSON()
    json
  
  # call original sync method
  syncReturnValue = Backbone.oldSync method, model, options

  # restore original toJSON() on this model instance
  model.toJSON = model.oldToJSON
  delete model.oldToJSON

  # return value returned by original sync
  syncReturnValue
