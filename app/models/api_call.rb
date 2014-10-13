class ApiCall
  def self.call(url, key, private_key, user_ugid, params)
    require 'net/http'
    require 'uri'
    params["apikey"]=key
    #params["action"]=action
    #params["controller"]=controller
    params["ugid"] = user_ugid
    body = params.to_json
    checksum = create_hash(body,private_key)

    url_ = "#{url}?checksum=#{checksum}"
    uri = URI.parse url_

    request = Net::HTTP::Post.new(url_)
    request.add_field "Content-Type", "application/json"
    request.body = body

    http = Net::HTTP.new(uri.host,uri.port)
    res = http.request request
  end

  def self.create_hash(body, private_key)
    require 'digest/sha1'
    string = "#{body}#{private_key}"
    cs = Digest::SHA1.hexdigest(string)
    puts "Checksum: #{cs}"
    cs
  end

end
