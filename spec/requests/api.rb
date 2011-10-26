require 'spec_helper.rb'

describe Api do
  it "basic api_call should work" do
    body = JSON.parse {
       "voucher":{
          "serie":"M",
          "activity_year":"2011",
          "authorized_by":"u1hu1jg6",
          "material_from":"u1jfht4s",
          "title":"API verifikat 1",
          "accounting_date":"2011-10-01",
          "voucher_rows_attributes":[
             {
                "account_number":"4019",
                "arrangement":"0",
                "sum":"200"
             },
             {
                "account_number":"1924",
                "sum":"-200"
             }
          ]
       }
    }

    #key = ApiKey.generate_key("Test", User.make)
    #key.api_accesses << 
    #res = ApiCall
  end
end
