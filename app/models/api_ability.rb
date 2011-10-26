class ApiAbility
  include CanCan::Ability

  def initialize(key)
    can do |action, subject_call, subject|
      unless subject.kind_of? Enumerable
        if subject.respond_to? :series
          puts "Respons to :series #{subject.series}"
          series = subject.series
        elsif subject.kind_of? Series
          puts "Is series, set from subject: #{subject}"
          series = subject
        else
          puts "Nope. #{subject_call.inspect}"
          series = nil
        end
        
        unless series.nil?
          if action == :read
            key.has_access? series, :read
          elsif action == :write || action == :update || action == :create || action == :destroy
            key.has_access? series, :write
          else
            false
          end
        else
          false
        end
      else
        subject.all? {|s| can action, s.class, s }
      end
    end
  end
end
