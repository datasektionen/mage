class ApiCall
  def self.call(url_root, controller, action, key, private_key, params)
    require 'net/http'
    require 'uri'
    params["apikey"]=key
    params["action"]=action
    params["controller"]=controller
    checksum = create_hash(params,private_key)
    params["checksum"] = checksum
  
    # A ugly hack because HTTP.post_form only support unnested hashes

    flatt_params = Hash.new
    params.to_query.split("&").each { |p|
      split = p.split("=")
      flatt_params[split[0]]=CGI.unescape(split[1]) #Unescape to prevent double encoding
    }

    res = Net::HTTP.post_form(URI.parse("#{url_root}/#{controller}/#{action}"),flatt_params)
  end

  def self.create_hash(params, private_key)
    require 'digest/sha1'
    string = params.to_query.+private_key
    puts string
    Digest::SHA1.hexdigest(string)
  end

end
