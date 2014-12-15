module WriteOnce
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_writeonce(*write_once_attr)
      before_save do |record|
        return false if write_once_attr.any? { |attr| (!send("#{attr}_was").nil?) && record.changed.include?(attr.to_s) }
      end
    end
  end
end

ActiveRecord::Base.send(:include, WriteOnce)
