class ApiAbility
  include CanCan::Ability

  def initialize(key)
    can do |action, subject_call, subject|
      unless subject.kind_of? Enumerable
        if subject.respond_to? :serie
          serie = subject.serie
        elsif subject_call == Serie
          serie = subject
        else
          serie = nil
        end

        unless serie.nil?
          if action == :read
            key.has_access? serie, :read
          elsif action == :write || action == :update || action == :create || action == :destroy
            key.has_access? serie, :write
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
