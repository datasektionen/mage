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
      av = $(a).children(".short").children("."+cur_class).text();
      bv = $(b).children(".short").children("."+cur_class).text();
      return (av < bv ? -1 : (av > bv ? 1 : 0))*sort_direction
    })
    $.each(listitems, function(idx, itm) { $("#list_body").append(itm); });

    //Decoration
    $("#voucher_header ."+cur_sort).addClass("cur_sort")
    if(sort_direction == 1) {
      $("#voucher_header ."+cur_sort).addClass("sort_asc")
    } else {
      $("#voucher_header ."+cur_sort).addClass("sort_desc")
    }
  })
})

