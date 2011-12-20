class Journal < ActiveRecord::Base
  belongs_to :user
  belongs_to :api_key
  belongs_to :object, :polymorphic=>true

  def self.log(action, obj, user, api_key=nil)
    action_name = I18n.t("action."<< obj.class.to_s.underscore<< "." << action.to_s,:default=>[("action." << action.to_s).to_sym,action])
    model_name = I18n.t('activerecord.models.' << obj.class.to_s.underscore)
    object_data = obj.inspect
    object_data = obj.to_log if obj.respond_to? :to_log
    # suppress warning about changing object_id:
    silence_warnings do 
      create(
        :message=>"#{action_name} #{model_name}: #{object_data}",
        :user=>user,
        :api_key=>api_key,
        :object=>obj
      ) or return false
    end
    # Delete old posts
    delete_all(["created_at < ?", Mage::Application.settings[:keep_journal_days].days.ago])
    return true
  end
end
