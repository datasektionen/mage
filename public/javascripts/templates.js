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
    if($("#voucher_add_row_template").val() == "") {
      $("#template_fields").html("")
    } else {
      $.ajax( {
        url: template_fields_url,
        data: {"template" : $("#voucher_add_row_template").val(), "organ":organ_val(), "activity_year":activity_year_id },
        success: function(data, textStatus, xhr) {
          $("#template_fields").html(data)
        }
      })
    }
  })

  $("#template_add_button").live('click', add_template_rows)

  function add_template_rows() {
    fields = {}
    $(".template_input").each(function(i,o) {
      fields[$(o).attr("script_name")] = $(o).val()
    })
    params =  {
      "template": $("#voucher_add_row_template").val(), 
      "arrangement" : $("#voucher_add_row_template_arrangement").val(),
      "activity_year" : activity_year_id,
      "fields" : fields
    }

    $.ajax( {
      url: template_parse_url, 
      type: "POST",
      data: params,
      success: function(data, textStatus, xhr) {
        sum_to_add = parseFloat($(data).find("sum").text())
        update_sum(sum_to_add)
        $("#voucher_rows tbody").append($(data).find("html_content").text())
        num_rows += parseInt($(data).find("num_rows").text())
        $("#template_fields").html("")
        $("#voucher_add_row_template").val("")
      },
      error: function(xhr, textStatus, errorThrown) {
        if(xhr.status == 400) {
          alert("Ett fel uppstod: "+xhr.responseText)
        } else {
          alert(textStatus+"Ett fel uppstod när raderna skulle hämtas. Försök igen. Rapportera gärna felet om det kvarstår.")
        }
      }
    })
    return false
  }

})
