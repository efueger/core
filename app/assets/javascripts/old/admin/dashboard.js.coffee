# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  load_settings = ->
    id = $('#distributor_country_id').val()
    if id?
      $.get("/admin/distributors/country_setting/#{id}", (data) ->
        $("#distributor_time_zone").val(data.time_zone)
        $("#distributor_currency").val(data.currency)
        $("#distributor_consumer_delivery_fee").val(data.fee)
        $("#currency_code").html(data.currency)
      , 'json'
      )

  update_require_phone = ->
    require = $('#distributor_require_phone')
    collected = $('#distributor_collect_phone').is(':checked')

    require.attr('disabled', !collected)
    require.attr('checked', false) unless collected

  $('#distributor_country_id').change ->
    load_settings()
  $('#distributor_currency').change ->
    $("#currency_code").html($('#distributor_currency').val())
  $('#distributor_collect_phone').change ->
    update_require_phone()

  if !$('#distributor_country_id').attr('disabled') && $(".error_notification").size() == 0
    load_settings()

  update_require_phone()
