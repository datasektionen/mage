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
    if(total_sum != 0) {
      alert("Totalsumman måste vara 0 kr")
      return false
    }
    if(num_rows == 0) {
      alert("Kan inte spara tomt verifikat")
      return false
    }
    return true
  })

  //Bind enter
  $("form input, form select").keypress(function(e) {
    if(e.which == 13) {
      if(this.id == "voucher_add_row_sum") {
        //Add this row (after checks)
        add_row()
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
    } else if(e.which == 43) { //+
      sum = parseFloat($("#voucher_add_row_sum").val())
      if(!isNaN(sum)) {
        sum = Math.abs(sum)
        $("#voucher_add_row_sum").val(sum)
        return false
      }
      } else if(e.which == 45) { //-
      sum = parseFloat($("#voucher_add_row_sum").val())
      if(!isNaN(sum)) {
        sum = Math.abs(sum)*-1.0
        $("#voucher_add_row_sum").val(sum)
        return false
      }
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
      account.type = "account"
      results.push(account)
    }
  })
  return results
}

function update_account(account) {
  current_account = account
  arr_sel = $("#voucher_add_row_arrangement")
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

//Tries to add the row to the voucher
function add_row() {
  if($("#voucher_add_row_sum").val().trim() == "") {
    $("#voucher_add_row_sum").val("0")
  }
  sum = parseFloat($("#voucher_add_row_sum").val().replace(",","."))
  console.log(sum)
  if(isNaN(sum)) {
    alert("Summa måste vara ett nummer")
    return
  }
  if(current_account == undefined) {
    alert("Inget eller ogiltligt konto valt")
    return
  }

  if(sum == 0 && total_sum == 0 &&
      !confirm("Summan är 0 kr, fortsätta?")) {
    return
  } else if(sum == 0) {
    sum = total_sum*-1.0;
  }

  if(current_account.account_type == 3 && sum > 0 &&
      !confirm(current_account.number+" ska vanligtvis inte konteras i debet, fortsätta?")) {
      return
  }

  if(current_account.account_type == 4 && sum < 0 &&
      !confirm(current_account.number+" ska vanligtvis inte konteras i kredit, fortsätta?")) {
      return
  }
  $("#spinner").show()

  params = {"type" : current_account.type, "account" : current_account.number, "sum" : sum}
  if(has_arrangements(current_account)) {
    params.arrangement = $("#voucher_add_row_arrangement").val()
  }
  $.ajax( {
    url: voucher_row_url,
    data: params,
    success: function(data, textStatus, xhr) {
      update_sum(parseFloat($(data).find("sum").text()))
      $("#voucher_rows tbody").append($(data).find("html_content").text())
      num_rows++
      $("#spinner").hide()
    },
    error: function(data, textStatus, xhr) {
      $("#spinner").hide()
      if(textStatus == "400") {
        alert("Ogiltligt konto angivet")
      } else {
        alert("Ett internt fel uppstod. Rapportera gärna felet")
      }
    }
  })

  //Reset fields and move focus
  $("#voucher_add_row_account").val("")
  $("#voucher_add_row_arrangement").val($("#voucher_add_row_arrangement option")[0].value)
  $("#voucher_add_row_arrangement").enable(false)
  $("#voucher_add_row_sum").val("")
  $("#voucher_add_row_account").focus()


}

function update_sum(diff) {
  total_sum += diff
  $("#diff").html(diff+" kr")
}

function organ_changed() {
  var new_html = ""
  $.each(arrs[parseInt($("#voucher_organ_id").val())],function(index, arr) {
    new_html += "<option value='"+arr.id+"'>"+arr.name+" ("+arr.number+")</option>"
  })
  $("#voucher_add_row_arrangement").html(new_html)
}

function delete_row(link) {
  row = $(link.parentElement.parentElement)
  if(voucher_id != -1 && confirm("Stryka raden?")) {
    $(link.parentElement).html("<input type='hidden' voucher[voucher_rows_attributes][][cancel] value='1'/>")
    row.css("text-decoration","line-through")
  } else if(voucher_id == -1 && confirm("Radera raden?")){
    row.remove()
  }
  return false
}
