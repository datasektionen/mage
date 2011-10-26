class ApiAccess < ActiveRecord::Base
  belongs_to :api_key
  belongs_to :series

  validates_format_of :read_write, :with => /r?w?/

  # Returns api access objects for all 
  # items in series, with api_key.
  def self.for_series(series, api_key)
    series.map do |s|
      api_key.find_access(s) or ApiAccess.new(:api_key=>api_key, :series=>s)
    end
  end 

  # :none, :read, :write, :read_write
  def access=(type)
    case type
      when :none
        read_write = ''
      when :read
        read_write = 'r'
      when :write
        read_write = 'w'
      when :read_write, :write_read
        read_write = 'rw'
      else
        raise "Unknown access value: #{type}"
    end
  end

  def access
    case read_write
      when 'r'
        :read
      when 'w'
        :write
      when 'rw'
        :read_write
    end
  end

  # Type is :read, :write or :read_write
  def has_access?(type)
    case type
      when :read
        read_write.include? "r"
      when :write
        read_write.include? "w"
      when :read_write, :write_read
        read_write == 'rw'
      end
  end
end
