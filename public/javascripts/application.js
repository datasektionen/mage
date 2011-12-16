
function remove_fields(link, parents) {
  $(link).prev("input[type=hidden]").val(true)
  obj = $(link)
  $.each(parents, function(index, item) {
    obj = obj.parent(item)
  })
  obj.parent(".input").hide()
}

function add_fields(link, association, content, container_match) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).prev(container_match).append(content.replace(regexp, new_id));
}
