$(document).ready(function(){
  var this_check_box = $('#status');
  var this_hidden_form = $('#hidden-form');
  check_display_hide_form(this_check_box, this_hidden_form);
  $(this_check_box).click(function(){
    var venue_id = $('#venue-id').val();
    if(this_check_box.val() == 'true')
      update_status('false', venue_id);
    else
      update_status('true', venue_id);
  });
});

function check_display_hide_form(this_check_box, this_hidden_form){
  if(this_check_box.val() == 'true'){
    this_hidden_form.slideToggle('show');
  }else{
    this_hidden_form.hide();
  }
}

function update_status(status, venue_id){
  var this_hidden_form = $('#hidden-form');
  $.ajax({
    type: 'PUT',
    dataType: 'json',
    url: '/venues/' + venue_id + '/venue_market',
    data: {venue_market: {status: status}},
    success: function(data){
      if(data.message == 'success'){
        update_check_box_and_form(status);
      }
    },
    error: function(XMLHttpRequest, textStatus, errorThrown){
      alert('some error' + textStatus + ' | ' + errorThrown);
    }
  });
}

function update_check_box_and_form(status){
  var this_check_box = $('#status');
  var this_hidden_form = $('#hidden-form');
  this_check_box.val(status);
  check_display_hide_form(this_check_box, this_hidden_form);
}
