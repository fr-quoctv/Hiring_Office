function calculate_price(booking_id, quantity, price){
  var duration = $('#duration-' + booking_id).text().trim();
  var duration_number = parseInt(duration.split(' ')[0]);
  return parseFloat(quantity.text() * price * duration_number);
}
