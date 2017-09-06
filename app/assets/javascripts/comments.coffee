$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log 'Connected to comments!'
      @perform 'follow'
    ,

    received: (data) ->
      console.log data
      $('#' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments').append JST['templates/comment'](data)
  })
