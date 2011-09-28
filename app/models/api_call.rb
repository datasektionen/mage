class ApiCall
  def self.call(url_root, controller, action, key, private_key, params)
    require 'net/http'
    require 'uri'
    params["apikey"]=key
    params["action"]=action
    params["controller"]=controller
    checksum = create_hash(params,private_key)
    params["checksum"] = checksum

    res = Net::HTTP.post_form(URI.parse("#{url_root}/#{controller}/#{action}"),params)
  end

  def self.create_hash(params, private_key)
    require 'digest/sha1'
    string = params.map {|obj| "#{obj[0]}=#{obj[1]}" }.join(",")+private_key
    Rails.logger.debug("Hash string: #{string}")
    puts "Hash string: #{string}"
    Digest::SHA1.hexdigest(string)
  end
end
