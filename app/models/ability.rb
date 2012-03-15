class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.has_access? # Only logged in and verifed users can do anything at all
      if user.admin?
        can :manage, :all
      else
        can :manage, VoucherTemplate
        can :read, Series
        can :read, Voucher
        can :read, VoucherRow

        can do |action, subject_call, subject|
          unless subject.kind_of? Enumerable
            if subject.respond_to? :series
              series = subject.series
            elsif subject.kind_of? Series
              series = subject
            else
              series = nil
            end

            unless series.nil?
              if action == :read
                true # Read access for everyone
              elsif action == :write || action == :update || action == :create || action == :destroy
                a = user.accesses.find_by_series_id(series.id)
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
