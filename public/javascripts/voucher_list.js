var select_toggle=true 

$(function() {
  active_voucher_list()
})

function active_voucher_list() {
  $(".voucher").click(function() {
    $(this).children(".full").toggle('slow')
  })
  $(".voucher input, .voucher a").click(function(event){
    event.stopPropagation()
  })
  $(".select_all").click(function() {
    $(".voucher_select").attr('checked',select_toggle)
    select_toggle = !select_toggle
    if(select_toggle) {
      $(".select_all").val("Markera alla")
    } else {
      $(".select_all").val("Avmarkera alla")
    }
    return false
  })
}
