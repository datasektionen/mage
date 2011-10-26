class ApiCall
  def self.call(url, key, private_key, user_ugid, params)
    require 'net/http'
    require 'uri'

    uri = URI.parse url
    params["apikey"]=key
    params["action"]=action
    params["controller"]=controller
    params["ugid"] = user_ugid
    checksum = create_hash(params,private_key)
    params["checksum"] = checksum
  
    request = Net::HTTP::Post.new(url)
    request.add_field "Content-Type", "application/xml"
    request.body = params.to_xml
  
    http = Net::HTTP.new(uri.host,uri.port)
    res = http.request request
  end

  def self.create_hash(params, private_key)
    require 'digest/sha1'
    string = params.to_query.+private_key
    puts string
    Digest::SHA1.hexdigest(string)
  end

end
