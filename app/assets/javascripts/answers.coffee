# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.rb-vote').bind 'ajax:success', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote-result').html(result.html)
    $('#answer-' + result.vote.votable_id + '-vote').html('')
    .bind 'ajax:error', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote').append(result.error)

  $('.revote-link').bind 'ajax:success', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote').html(result.html)
    $('#answer-' + result.vote.votable_id + '-vote-result').html('')
    .bind 'ajax:error', (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $('#answer-' + result.vote.votable_id + '-vote-result').append(result.error)
