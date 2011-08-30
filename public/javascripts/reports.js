$(function() {
  $(".tree-node").click(function(){
    next = $(this).next(".tree-content")
    if(next.is(":visible")){
      next.slideUp()
    }
    else{
      next.slideDown()
    }
  })
  $(".tree-content").hide()
})
