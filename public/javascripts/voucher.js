var current_account=null

$(function() {
  //Autocomplete accounts
  $("#voucher_add_row_account").autocomplete({
    source: ac_account,
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

  }

  //Always set account:
  $("#voucher_add_row_account").blur(function() {
    account = find_account($(this).val())[0]
    if(account != undefined) {
      $(this).val(account.number)
    }
    update_account(account)
  })

  //Catch submit
  $("form").submit(function(obj,submit) {
    //TODO: Validate
    return false
  })

  //Bind enter
  $("form input, form select").keypress(function(e) {
    if(e.which == 13) {
      if(this.id == "voucher_add_row_sum") {

      } else {
        $(this).blur()
        next = this
        do {
          next = $("form input, form select")[$("form input, form select").index(next)+1]
        } while(next != undefined && (next.type == "hidden" || $(next).attr("disabled")))

        if(next != undefined) {
          next.focus()
        }
      }
      return false
    }
  })

})


function ac_account(req,callback) {
  callback(find_account(req.term))
}

function find_account(term) {
  var results = []
  if(term == "") {
      return results
  }
  $.each(accounts,function(index,account) {
    if ((account.number.toString().indexOf(term) == 0) || (account.name.toLowerCase().indexOf(term.toLowerCase()) >= 0)) {
      results.push(account)
    }
  })
  return results
}

function update_account(account) {
  current_account = account
  arr_sel = $("#voucher_add_row_arrangment")
  if(account != undefined) {
    if(has_arrangements(account)) {
      arr_sel.enable(true)
    } else {
      arr_sel.enable(false)
    }
    $("#voucher_info").html(account.number + " - " + account.name)
  } else {
    arr_sel.enable(false)
    $("#voucher_info").html("")
  }
}

function has_arrangements(account) {
  return (account.account_type > 2)
}
