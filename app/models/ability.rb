class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.has_access? # Only logged in and verifed users can do anything at all
      if user.admin?
        can :manage, :all
      else
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
                user.series.include? serie
              elsif action == :write
                a = user.accesses.find_by_serie_id(serie.id)
                a ? a.write_access? : false
              else
                # Only :write and :read should be used for normal user actions
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
  end
end
