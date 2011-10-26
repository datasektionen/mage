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
              series = subject.serie
            elsif subject.respond_to? :series
              puts "Respons to :series #{subject.series}"
              series = subject.series
            elsif subject.kind_of? Serie
              series = subject
            else
              series = nil
            end

            unless series.nil?
              if action == :read
                user.series.include? series
              elsif action == :write || action == :update || action == :create || action == :destroy
                a = user.accesses.find_by_serie_id(series.id)
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
