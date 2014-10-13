$(function() {

$(".update_all_kredit").click(function(e) {
  var first_val = $(".kredit_is_normal_"+$(this).attr("group_id")).first().prop("checked")
  if(first_val !== undefined) {
    $(".kredit_is_normal_"+$(this).attr("group_id")).prop("checked", !first_val);
  }
  return false
})

$(".update_all_debet").click(function(e) {
  var first_val = $(".debet_is_normal_"+$(this).attr("group_id")).first().prop("checked")
  if(first_val !== undefined) {
    $(".debet_is_normal_"+$(this).attr("group_id")).prop("checked", !first_val);
  }
  return false
})

})
