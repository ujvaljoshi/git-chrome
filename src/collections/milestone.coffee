class @MilestoneCollection extends Backbone.Collection
  model: MilestoneModel
  url: -> @_url
  
  initialize: (options) ->
    if r = options.repository
      @url = "https://api.github.com/repos/#{r}/milestones"
