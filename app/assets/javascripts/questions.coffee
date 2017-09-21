# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on('click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()
  )

  $(document).on('ajax:success', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote-result').html(JST['templates/vote_result'](result))
    $('#question-' + result.vote.votable_id + '-vote').html('')
    $('#question-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(data.responseText)

    if (status == 403)
      $('.alert').html(result.error)
    else
      $('#question-' + result.vote.votable_id + '-vote').append(result.error)
  )

  $(document).on('ajax:success', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote').html(JST['templates/vote_buttons']({ votable: result.votable, votable_type: 'Question' }))
    $('#question-' + result.vote.votable_id + '-vote-result').html('')
    $('#question-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(data.responseText)

    if (status == 403)
      $('.alert').html(result.error)
    else
      $('#question-' + result.vote.votable_id + '-vote-result').append(result.error)
  )

  $(document).on('click', '.comment-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('commentableId')
    $('form#comment-question-' + question_id).show()
  )

  $(document).on('ajax:success', '.new-question-comment', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('form#comment-question-' + result.comment.commentable_id).hide()
    $('#comment-question-link-' + result.comment.commentable_id).show()
    $('#comment-question-' + result.comment.commentable_id + '-errors').html('')
    $('#comment_body').val('')
  ).on('ajax:error', '.new-question-comment', (e, data, status, xhr) ->
    result = $.parseJSON(data.responseText)

    if (status == 403)
      $('.alert').html(result.error)
    else
      $('#comment-question-' + result.commentable_id + '-errors').html(JST['templates/error_messages']({ errors: result.errors }))
  )

  $(document).on('ajax:success', '.unsubscribe-link', (e, data, status, xhr) ->
    question_id = $(this).data('questionId')
    $('#question-' + question_id + '-subscription').html(JST['templates/subscribe']({ question_id: question_id}))
  ).on('ajax:error', '.unsubscribe-link', (e, data, status, xhr) ->
    show_error(data, $(this).data('questionId'))
  )

  $(document).on('ajax:success', '.subscribe-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.question_id + '-subscription').html(JST['templates/unsubscribe'](result))
  ).on('ajax:error', '.subscribe-link', (e, data, status, xhr) ->
    show_error(data, $(this).data('questionId'))
  )

  show_error =(data, question_id) ->
    result = $.parseJSON(data.responseText)
    $('#question-' + question_id + '-subscription').prepend(result.error)

  unless gon.question_id
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: ->
        console.log 'Connected to questions!'
        @perform 'follow'
      ,

      received: (data) ->
        console.log data
        $('.questions').append JST['templates/question'](data)
    })
