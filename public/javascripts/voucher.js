var total_sum = 0

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
    voucher_add_row_account_blur_callback(this)
  })

  function voucher_add_row_account_blur_callback(item) {
    account = find_account($(item).val())[0]
    if(account != undefined) {
      $(item).val(account.number)
    }
    update_account(account)
  }

  //Catch submit
  $("form").submit(function(obj,submit) {
    if(total_sum != 0 && !confirm("Totalsumman är inte 0, fortsätta ändå?")) {
      return false
    }
    if(num_rows == 0) {
      alert("Kan inte spara tomt verifikat")
      return false
    }
    return true
  })

  //Bind keys
  $("form input, form select").live('keydown', function(e) { 
    var keyCode = e.keyCode || e.which
    if(keyCode == 13)
      e.preventDefault()

    if((keyCode == 9 && !e.shiftKey) || keyCode == 13) {

      if(this.id == "voucher_add_row_sum" && keyCode == 13) {
        //Add this row (after checks)
        add_row()
      } else {
        $(this).triggerHandler('blur')
        if(keyCode == 13) {
          next = this
          items = $("form input, form select").filter(":visible")
          do {
            next = items[items.index(next)+1]
          } while(next != undefined && (next.type == "hidden" || $(next).attr("disabled")))

          if(next != undefined) {
            next.focus()
          }
        }
      }
    }
  })
  $("form input, form select").keypress(function(e) {
    var keyCode = e.keyCode || e.which
    if(keyCode == 13)
      e.preventDefault()
    if(keyCode == 43) { //+
      sum = parseFloat($("#voucher_add_row_sum").val())
      if(!isNaN(sum)) {
        sum = Math.abs(sum)
        $("#voucher_add_row_sum").val("+"+sum)
        return false
      }
      } else if(keyCode == 45) { //-
      sum = parseFloat($("#voucher_add_row_sum").val())
      if(!isNaN(sum)) {
        sum = Math.abs(sum)*-1.0
        $("#voucher_add_row_sum").val(sum)
        return false
      }
    } 
  })
})


//Tries to add the row to the voucher
function add_row() {
  if($("#voucher_add_row_sum").val().trim() == "") {
    $("#voucher_add_row_sum").val("0")
  }
  sum_str = $("#voucher_add_row_sum").val().replace(",",".").trim()
  sum = parseFloat(sum_str)
  console.log(sum)
  sum = Math.round(sum*100.0)/100.0 //Trim to 2 decimals
  console.log(sum_str.charAt(0))
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
    sum = get_diff()*-1.0;
  } else {
    if(!(sum_str.charAt(0) == "+" || sum_str.charAt(0) == "-")) {
      //Try to guess sign 
      if(current_account.account_type == 3) {
        sum = -1*sum;
      } 
      // positive for account_type 4
    }
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

  params = {"type" : current_account.type, "account" : current_account.number, "sum" : sum, "voucher_id": voucher_id,"id":current_account.id}
  if(has_arrangements(current_account)) {
    params.arrangement = $("#voucher_add_row_arrangement").val()
  }
  $.ajax( {
    url: voucher_row_url,
    data: params,
    success: function(data, textStatus, xhr) {
      ///DEBUG CODE: TODO: Remove
        sum_to_add = parseInt($(data).find("sum").text())
        if(sum_to_add == 0) {
          alert("Warning, sum to add was 0 (<sum>: "+$(data).find("sum").text()+")")
        }
      //End debug code
      update_sum(sum_to_add)
      $("#voucher_rows tbody").append($(data).find("html_content").text())
      num_rows += parseInt($(data).find("num_rows").text())
      $("#spinner").hide()
    },
    error: function(xhr, textStatus, errorThrown) {
      $("#spinner").hide()
      if(xhr.status == 400) {
        alert("Ogiltligt konto angivet")
      } else {
        alert("Ett fel uppstod när raderna skulle hämtas. Försök igen. Rapportera gärna felet om det kvarstår.")
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

function set_diff(diff) {
  total_sum = Math.floor(diff*100)
  update_sum(0)
}

function get_diff() {
  return total_sum/100.0
}

//diff must be an integer round(real sum*100.0)
function update_sum(diff) {
  total_sum += diff
  $("#diff").html((total_sum/100.0)+" kr")
}

function organ_val() {
  return parseInt($("#voucher_organ_id").val())
}

function organ_changed() {
  var new_html = ""
  $.each(arrs[organ_val()],function(index, arr) {
    new_html += "<option value='"+arr.id+"'>"+arr.name+" ("+arr.number+")</option>"
  })
  $(".arr_select").html(new_html)
}

function delete_row(link,sum) {
  row = $(link).parent().parent()
  if(voucher_id != -1 && confirm("Stryka raden?")) {
    $(link).parent().html(
      "<input type='hidden' name='voucher[voucher_rows_attributes][][canceled]' value='1'/>" +
      "<input type='hidden' name='voucher[voucher_rows_attributes][][signature_id]' value='1'/> <!-- Changed server side -->"
    )
    row.css("text-decoration","line-through")
    update_sum(-sum)
    num_rows--;
  } else if(voucher_id == -1) { // && confirm("Radera raden?")){
    row.remove()
    update_sum(-sum)
    num_rows--;
  }
  return false
}
