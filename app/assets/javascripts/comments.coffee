$ ->
  if gon.question_id
    App.cable.subscriptions.create({
      channel: 'CommentsChannel',
      id: gon.question_id
    }, {
      connected: ->
        console.log 'Connected to comments/question-' + gon.question_id
        @perform 'follow'
      ,

      received: (data) ->
        console.log data
        $('#' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments').append JST['templates/comment'](data)
    })
  else
    App.cable.subscriptions.create({
      channel: 'CommentsChannel',
      id: gon.question_id
    }, {
      connected: ->
        console.log 'Connected to comments!'
        @perform 'follow_all'
      ,

      received: (data) ->
        console.log data
        $('#' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments').append JST['templates/comment'](data)
    })
