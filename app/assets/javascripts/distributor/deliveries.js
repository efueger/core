// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  var element = $('#calendar-navigation').jScrollPane();

  if(element.length > 0) {
    var api = element.data('jsp');
    api.scrollToElement($('#scroll-to'), true);
  }

  $('.sortable').sortable({
    delay: 250,
    placeholder: 'sortable-highlight',
    curser: 'move',
    opacity: 0.90,
    start: function(e, ui){
       ui.placeholder.height(ui.item.height());
    },
    update: function() {
      $.ajax({
        type: 'post',
        data: $.map($('#delivery_list li.data-listings'), function(val){return "delivery[]=" + $(val).data('deliveryId')}).join("&"),
        dataType: 'json',
        url: '/distributor/deliveries/date/' +
          $('#delivery-listings').data('date') +
          '/reposition',
        statusCode: {
            400: function() {
              bootbox.alert("Oops, that didn't work! Please refresh the page and try again.");
            },
            404: function() {
              bootbox.alert("Oops, that didn't work! Please refresh the page and try again.");
            }
        }
      })
    }
  });
  $('.sortable').disableSelection();

  // Pre-select all checkboxes
  $("#delivery-listings #select_all-all").trigger("click");

  $('#delivery-listings .tag-links').each(function() {
    if (typeof window.chrome === "object") {
      // Display tooltip for Chrome since it doesn't expand the tags
      $(this).tooltip();
    }
  });

  $('#delivery-listings #master-print').click(function () {
    var checked_packages = $('#delivery-listings .data-listings input[type=checkbox]:checked');
    var ckbx_ids = $.map(checked_packages, function(ckbx) { return $(ckbx).data('packages'); });

    $.each(checked_packages, function(i, ckbx) {
      var holder = $(ckbx).closest('.data-listings');

      holder.addClass('packed');
      holder.removeClass('unpacked');

      holder.find('.status-packed').show();
      holder.find('.status-unpacked').hide();
    });

    var form = $('#master-print-form');

    $.each(ckbx_ids, function(index, package_id) {
      $("<input type='hidden'>").attr('name', 'packages[]').attr('value', package_id).appendTo(form);
    });

    form.submit();
    form.find("input[name!='authenticity_token']").remove(); // clean the form for future usages
  });

  $('#delivery-listings #export-exclusions-substitutions').click(function () {
    var date = $('#list_type').data('date');
    var data_property = $('#list_type').data('type');
    var checked_packages = $('#delivery-listings .data-listings input[type=checkbox]:checked');
    var ckbx_ids = $.map(checked_packages, function(ckbx) { return $(ckbx).data(data_property); });

    var form = $('#export-exclusions-substitutions-form');

    $("<input type='hidden'>").attr('name', 'date').attr('value', date).appendTo(form);

    $.each(ckbx_ids, function(index, order_id) {
      $("<input type='hidden'>").attr('name', data_property + '[]').attr('value', order_id).appendTo(form);
    });

    form.submit();
    form.find("input[name!='authenticity_token']").remove(); // clean the form for future usages
  });

  $('#delivery-listings .export-details').click(function() {
    prepare_csv_export(this);
  });

  $('#delivery-listings #delivered, #missed-options a').click(function() {
    var status = $(this).attr('id');
    var checked_deliveries = $('#delivery-listings .data-listings input[type=checkbox]:checked');

    if(status === 'payment-on-delivery' || status === 'undo-payment') {
      reverse_payment = (status === 'undo-payment');
      makePayments(checked_deliveries, reverse_payment);
    }
    else {
      updateDeliveryStatus(status, checked_deliveries);
    }
  });

  $('#delivery-listings #more-delivery-options').click(function() {
     $('#delivery-listings .flyout').toggle();
     return false;
  });

  $('.dso-tooltip').tooltip();

  $('#link_to_download_extras_csv').click(function(){
    $('#export_extras_form').submit();
    return false;
  });
});

function updateDeliveryStatus(status, checked_deliveries, date) {
  var ckbx_ids = $.map(checked_deliveries, function(ckbx) { return $(ckbx).data('deliveries'); });
  var data_hash = { 'deliveries': ckbx_ids, 'status': status };
  if(date) { data_hash['date'] = date; }

  $.ajax({
    type: 'POST',
    url: '/distributor/deliveries/update_status.json',
    dataType: 'json',
    data: $.param(data_hash)
  });

  $.each(checked_deliveries, function(i, ckbx) {
    var holder = $(ckbx).closest('.data-listings');

    var statuses = ['pending', 'delivered', 'cancelled', 'rescheduled', 'repacked'];
    statuses.splice(statuses.indexOf(status), 1);

    holder.addClass(status);
    holder.removeClass(statuses.join(' '));

    holder.find('.status-' + status).show();
    $.each(statuses, function(j, hide_status) {
      holder.find('.status-' + hide_status).hide();
    });
  });
}

function makePayments(checked_deliveries, reverse_payment) {
  var ckbx_ids = $.map(checked_deliveries, function(ckbx) { return $(ckbx).data('deliveries'); });
  var data_hash = { 'deliveries': ckbx_ids };
  if(reverse_payment) { data_hash['reverse_payment'] = true; }

  $.ajax({
    type: 'POST',
    url: '/distributor/deliveries/make_payment.json',
    dataType: 'json',
    data: $.param(data_hash)
  });

  $.each(checked_deliveries, function(i, ckbx) {
    var paid_label = $(ckbx).closest('.data-listings').find('.paid-label');

    if(reverse_payment) {
      paid_label.removeClass('paid');
    }
    else {
      paid_label.addClass('paid');
    }
  });
}

function prepare_csv_export(el) {
  var data_property = $('#list_type').data('type');
  var checked_items = $('#delivery-listings .data-listings input[type=checkbox]:checked');
  var ckbx_ids      = $.map(checked_items, function(ckbx) { return $(ckbx).data(data_property); });

  var form   = $('#export-details-form');
  var date   = $('#list_type').data('date');
  var screen = $('#list_type').data('screen');

  $.each(ckbx_ids, function(index, delivery_id) {
    $("<input type='hidden'>").attr('name', data_property + '[]').attr('value', delivery_id).appendTo(form);
  });

  $("<input type='hidden'>").attr('name', 'date').attr('value', date).appendTo(form);
  $("<input type='hidden'>").attr('name', 'screen').attr('value', screen).appendTo(form);

  form.submit();
  form.find("input[name!='authenticity_token']").remove(); // clean the form for future usages
}

