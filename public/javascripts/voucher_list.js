$(function() {
  active_voucher_list()
})

function active_voucher_list() {
  $(".voucher").click(function() {
    $(this).children(".full").toggle('slow')
  })
}
