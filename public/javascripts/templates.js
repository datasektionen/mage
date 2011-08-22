$(function() {
  $("#expand_templates").click(function() {
    $("#templates").slideDown()
    $("#expand_templates").hide()
    $("#hide_templates").show()
    return false
  })

  $("#hide_templates").click(function() {
    $("#templates").slideUp()
    $("#expand_templates").show()
    $("#hide_templates").hide()
    return false
  })

  $("#voucher_add_row_template").change(function() {
    $.ajax( {
      url: template_fields_url,
      data: {"template" : $("#voucher_add_row_template").val() },
      success: function(data, textStatus, xhr) {
        $("#template_fields").html(data)
      }
    })
  })

  $("#template_add_button").live('click', add_template_rows)

  $(".template_input").live('keydown', function(e) {
    var keyCode = e.keyCode || e.which
    if(keyCode == 13) {
      add_template_rows()
      return false
    }
  })

  function add_template_rows() {
    fields = {}
    $(".template_input").each(function(i,o) {
      fields[$(o).attr("script_name")] = $(o).val()
    })
    params =  {"template": $("#voucher_add_row_template").val(), "arrangement" : $("#voucher_add_row_template_arrangement").val(), "fields" : fields }

    $.ajax( {
      url: template_parse_url, 
      type: "POST",
      data: params,
      success: function(data, textStatus, xhr) {
        ///DEBUG CODE: TODO: Remove
          sum_to_add = parseFloat($(data).find("sum").text())
          if(sum_to_add == 0) {
            alert("Warning, sum to add was 0 (<sum>: "+$(data).find("sum").text()+")")
          }
        //End debug code
        update_sum(sum_to_add)
        $("#voucher_rows tbody").append($(data).find("html_content").text())
        num_rows += parseInt($(data).find("num_rows").text())
      },
      error: function(data, textStatus, xhr) {
        if(textStatus == "400") {
          alert("Ett fel uppstod: "+data)
        } else {
          alert("Ett fel uppstod när raderna skulle hämtas. Försök igen. Rapportera gärna felet om det kvarstår.")
        }
      }
    })
    return false
  }

  //Trigger change for template select:
  $("#voucher_add_row_template").change()

})
