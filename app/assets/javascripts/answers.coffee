# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on('click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
  )

  $(document).on('ajax:success', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote-result').html(JST['templates/vote_result'](result))
    $('#answer-' + result.vote.votable_id + '-vote').html('')
    $('#answer-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(data.responseText)

    if (status == 403)
      $('.alert').html(result.error)
    else
      $('#answer-' + result.vote.votable_id + '-vote').append(result.error)
  )

  $(document).on('ajax:success', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote').html(JST['templates/vote_buttons']({ votable: result.votable, votable_type: 'Answer' }))
    $('#answer-' + result.vote.votable_id + '-vote-result').html('')
    $('#answer-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(data.responseText)

    if (status == 403)
      $('.alert').html(result.error)
    else
      $('#answer-' + result.vote.votable_id + '-vote-result').append(result.error)
  )

  $(document).on('click', '.comment-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('commentableId')
    $('form#comment-answer-' + answer_id).show()
  )

  $(document).on('ajax:success', '.new-answer-comment', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('form#comment-answer-' + result.comment.commentable_id).hide()
    $('#comment-answer-link-' + result.comment.commentable_id).show()
    $('#comment-answer-' + result.comment.commentable_id + '-errors').html('')
    $('#comment_body').val('')
  ).on('ajax:error', '.new-answer-comment', (e, data, status, xhr) ->
    result = $.parseJSON(data.responseText)

    if (status == 403)
      $('.alert').html(result.error)
    else
      $('#comment-answer-' + result.commentable_id + '-errors').html(JST['templates/error_messages']({ errors: result.errors }))
  )

  if gon.question_id
    App.cable.subscriptions.create({
      channel: 'AnswersChannel',
      question_id: gon.question_id
    }, {
      connected: ->
        console.log 'Connected to question_' + gon.question_id
        @perform 'follow'
      ,

      received: (data) ->
        console.log data
        $('.answers').append JST['templates/answer'](data)
    })
