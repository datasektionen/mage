$.ui.autocomplete.prototype._renderItem = function(ul,item) {
    a=item
    return $("<li></li>")
      .data("item.autocomplete",a)
      .append("<a>"+
               "<span class='autocomplete account'>"+a.number+" - "+a.name+"</span>"+
              "</a>")
        .appendTo(ul);

};

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

  $(".account_autocomplete:not(.ui-autocomplete-input)").live('focus', function(event) {
    $(this).autocomplete({
    source: ac_account,
    focus: function(event,ui) {
      $(this).val(ui.item.number);
      return false;
    },
    select: function(event,ui) {
      $(this).val(ui.item.number);
      return false;
    }
  })
  })

});
