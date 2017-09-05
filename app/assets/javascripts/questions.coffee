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
    $('#question-' + result.vote.votable_id + '-vote-result').html(JST['vote_result'](result))
    $('#question-' + result.vote.votable_id + '-vote').html('')
    $('#question-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote').append(result.error)
  )

  $(document).on('ajax:success', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote').html(JST['vote_buttons']({ votable: result.votable, votable_type: 'Question' }))
    $('#question-' + result.vote.votable_id + '-vote-result').html('')
    $('#question-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote-result').append(result.error)
  )

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected to questions!'
      @perform 'follow'
    ,

    received: (data) ->
      console.log data
      $('.questions').append JST['question'](data)
  })
