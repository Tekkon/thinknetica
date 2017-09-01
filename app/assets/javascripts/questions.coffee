# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  $(document).on('ajax:success', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote-result').html(result.html)
    $('#question-' + result.vote.votable_id + '-vote').html('')
    $('#question-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote').append(result.error)
  )

  $(document).on('ajax:success', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote').html(result.html)
    $('#question-' + result.vote.votable_id + '-vote-result').html('')
    $('#question-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#question-' + result.vote.votable_id + '-vote-result').append(result.error)
  )
