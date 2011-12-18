
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val(true)
  $(link).parent("td").parent(".input").hide()
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).prev("table").append(content.replace(regexp, new_id));
}
