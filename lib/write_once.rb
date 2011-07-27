module WriteOnce
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_writeonce(*write_once_attr)
      before_save do |record|
        return false if write_once_attr.any? { |attr| (not send("#{attr.to_s}_was").nil?) && record.changed.include?(attr.to_s) }
      end
    end
  end
end

ActiveRecord::Base.send(:include,WriteOnce)
