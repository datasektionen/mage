var current_account=null

$(function() {
  $("#voucher_add_row_account").autocomplete({
    source: find_account,
    focus: function(event,ui) {
      $(this).val(ui.item.number);
      update_account(ui.item);
      return false;
    },
    select: function(event,ui) {
      $(this).val(ui.item.number);
      update_account(ui.item);
      return false;
    }
  })
  .data("autocomplete")._renderItem = function(ul,item) {
    a=item
    return $("<li></li>")
      .data("item.autocomplete",a)
      .append("<a>"+
               "<span class='autocomplete account'>"+a.number+" - "+a.name+"</span>"+
              "</a>")
        .appendTo(ul);

  };

});

function find_account(req, callback) {
  var results = []
  $.each(accounts,function(index,account) {
    if ((account.number.toString().indexOf(req.term) == 0) || (account.name.toLowerCase().indexOf(req.term.toLowerCase()) >= 0)) {
      results.push(account)
    }
  })
  callback(results)
}

function update_account(account) {
  current_account = account
  arr_sel = $("#voucher_add_row_arrangment")
  if(has_arrangements(account)) {
    arr_sel.enable(true)
  } else {
    arr_sel.enable(false)
  }
  $("#voucher_info").html(account.number + " - " + account.name)
}

function has_arrangements(account) {
  return (account.account_type > 2)
}
