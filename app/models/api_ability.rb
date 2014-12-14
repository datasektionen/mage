class ApiAbility
  include CanCan::Ability

  def initialize(key)
    can :read, ActivityYear

    can do |action, _subject_call, subject|
      unless subject.is_a? Enumerable
        if subject.respond_to? :series
          puts "Respons to :series #{subject.series}"
          series = subject.series
        elsif subject.is_a? Series
          puts "Is series, set from subject: #{subject}"
          series = subject
        else
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
        subject.all? { |s| can action, s.class, s }
      end
    end
  end
end
