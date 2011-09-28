class ApiCall
  def self.call(host, controller, action, key, private_key, user_ugid, params, port=nil)
    require 'net/http'
    require 'uri'
    params["apikey"]=key
    params["action"]=action
    params["controller"]=controller
    params["ugid"] = user_ugid
    checksum = create_hash(params,private_key)
    params["checksum"] = checksum
  
    # A ugly hack because HTTP.post_form only support unnested hashes

    #flatt_params = Hash.new
    #params.to_query.split("&").each { |p|
    #  split = p.split("=")
    #  flatt_params[split[0]]=CGI.unescape(split[1]) #Unescape to prevent double encoding
    #}

    res = Net::HTTP.new(host,port).post("/#{controller}/#{action}",params.to_query)
  end

  def self.create_hash(params, private_key)
    require 'digest/sha1'
    string = params.to_query.+private_key
    puts string
    Digest::SHA1.hexdigest(string)
  end

end
