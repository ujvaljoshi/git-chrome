class @AssigneeCollection extends Backbone.Collection
  model: AssigneeModel
  url: -> @_url
  
  initialize: (options) ->
    if r = options.repository
      @url = "https://api.github.com/repos/#{r}/assignees"
