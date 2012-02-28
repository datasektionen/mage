var current_account=null
var account_selection_valid_to = null
var account_selection_valid_from = null

function ac_account(req,callback) {
  callback(find_account(req.term))
}

function find_account(term) {
  var results = []
  if(term == "") {
      return results
  }
  $.each(accounts,function(index,account) {
	  if(
		  (account_selection_valid_from === null || account.activity_year >=account_selection_valid_from) &&
		  (account_selection_valid_to === null || account.activity_year <= account_selection_valid_to) &&
		  (
			(account.number.toString().toLowerCase().indexOf(term.toLowerCase()) == 0) ||
			(account.name.toLowerCase().indexOf(term.toLowerCase()) >= 0)
		  )
		 ){
			results.push(account)
		}
  })
  return results
}

function update_account(account) {
  current_account = account
  arr_sel = $("#voucher_add_row_arrangement")
  if(account != undefined) {
    if(has_arrangements(account)) {
      arr_sel.enable(true)
    } else {
      arr_sel.enable(false)
    }
    $("#voucher_info").html(account.number + " - " + account.name)
  } else {
    arr_sel.enable(false)
    $("#voucher_info").html("")
  }
}

function has_arrangements(account) {
  return (account.has_arrangements)
}
