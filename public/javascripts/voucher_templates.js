$(function() {

  $('#voucher_template_valid_from').change(function() {
	  num = parseInt($(this).val())
	  if(num == undefined || isNaN(num)) {
		  num = null;
	  }
	  account_selection_valid_from = num;
  })
  
  $('#voucher_template_valid_to').change(function() {
	  num = parseInt($(this).val())
	  if(num == undefined || isNaN(num)) {
		  num = null;
	  }
	  account_selection_valid_to = num;
  })
	
  //Update valid_from and to:
  $("#voucher_template_valid_from, #voucher_template_valid_to").trigger('change');

});
