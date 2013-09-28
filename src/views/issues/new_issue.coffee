class @NewIssueView extends Backbone.View

  className: 'new-issue'

  events:
    "submit form" : "onSubmit"
    "change [name=repository]": "onRepoSelectChanged" 

  initialize: (@options) ->
    @repositories = @options.repositories

  render: ->
    @$el.html(HAML['new_issue'](repositories: @repositories))
    @$('select').select2()
    

  onSubmit: (e) ->
    e.preventDefault()
    name = @$("[name=repository]").val()
    localStorage['new_issue_last_repo'] = name
    repository = @repositories.find (r) -> r.get('full_name') == name
    model = new IssueModel({
      body: @$("[name=body]").val()
      title: @$("[name=title]").val()
      assignee: @$("[name=assignee]").val()
      milestone: parseInt(@$("[name=milestone]").val(), 10)
    }, {repository: repository})
    model.save {},
      success: (model) =>
        @badge = new Badge()
        @badge.addIssues(1)
        @$('.message').html("<span>Issue <a href=\"#{model.get("html_url")}\" target=\"_blank\">##{model.get('number')}</a> was created!</span>")
      error: =>
        @$('.message').html("<span>Failed to create issue :(</span>")

  # Event called when Repo select is changed
  onRepoSelectChanged: (e) ->
    e.preventDefault()
    full_name = @$("[name=repository]").val()
    localStorage['new_issue_last_repo'] = full_name

    @assignees = new AssigneeCollection({repository: full_name})
    @assignees.fetch
      success: => @updateSelect('assignee')
    
    @milestones = new MilestoneCollection({repository: full_name})
    @milestones.fetch
      success: => @updateSelect('milestone')
    
  # Called to update the selects based on new repo selection
  updateSelect: (select) ->
    switch select
      when 'assignee'
        console.log("Total assignees = " + @assignees.size())
        for assignee in @assignees.models
          console.log(assignee.get('login'))
        
      when 'milestone'
        console.log("Total milestones = " + @milestones.size())
        for milestone in @milestones.models
          console.log(milestone.get('title'))

    
    
