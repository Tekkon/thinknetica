# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  $('.rb-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)

    $('#question-' + vote.votable_id + '-vote').remove()

    vote_type = null
    if vote.vote_type == 1
      vote_type = 'for'
    else
      vote_type = 'against'

    $('#question-' + vote.votable_id + '-vote-result').html('You have voted ' + vote_type + ' this question.')
