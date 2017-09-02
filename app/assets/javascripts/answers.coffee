# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $(document).on('ajax:success', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote-result').html(JST['vote_result']({ vote: result.vote }))
    $('#answer-' + result.vote.votable_id + '-vote').html('')
    $('#answer-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.rb-vote', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote').append(result.error)
  )

  $(document).on('ajax:success', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote').html(JST['vote_buttons']({ vote: result.vote }))
    $('#answer-' + result.vote.votable_id + '-vote-result').html('')
    $('#answer-' + result.vote.votable_id + '-rating').html('Rating: ' + result.rating)
  ).on('ajax:error', '.revote-link', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote-result').append(result.error)
  )
