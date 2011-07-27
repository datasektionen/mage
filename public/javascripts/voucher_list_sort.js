var sort_direction=1
var cur_sort=null

$(function() {
  $("#voucher_header span").click(function() {
    if(cur_sort!=null) {
      $("#voucher_header ."+cur_sort).removeClass("cur_sort")
      if(sort_direction==1) {
        $("#voucher_header ."+cur_sort).removeClass("sort_asc")
      } else {
        $("#voucher_header ."+cur_sort).removeClass("sort_desc")
      }
    }

    cur_class = $(this).attr('class')
    if(cur_sort == cur_class) {
      sort_direction = sort_direction*-1
    } else {
      sort_direction = 1
      cur_sort = cur_class
    }
    listitems = $(".voucher").sort(function(a,b) {
      av = sort_data(a, cur_class)
      bv = sort_data(b, cur_class)
      return (av < bv ? -1 : (av > bv ? 1 : 0))*sort_direction
    })
    $.each(listitems, function(idx, itm) {
      $("#list_body").append(itm)
    })

    //Decoration
    $("#voucher_header ."+cur_sort).addClass("cur_sort")
    if(sort_direction == 1) {
      $("#voucher_header ."+cur_sort).addClass("sort_asc")
    } else {
      $("#voucher_header ."+cur_sort).addClass("sort_desc")
    }
  })
})

function sort_data(itm, cls) {
  sort_item = $(itm).children(".short").children("."+cls)
  if(sort_item.attr("numerical_value") == undefined) {
    return sort_item.text()
  } else {
    return parseInt(sort_item.attr("numerical_value"))
  }
}
