class Journal < ActiveRecord::Base
  belongs_to :user
  belongs_to :api_key
  belongs_to :object, :polymorphic=>true

  def self.log(action, obj, user, api_key=nil)
    # suppress warning about changing object_id:
    silence_warnings do 
      create(:message=>"#{I18n.t("action."<< obj.class.to_s.downcase << "" << action.to_s,:default=>[("action." << action.to_s).to_sym,action])} #{I18n.t('activerecord.models.' << obj.class.to_s.downcase)}:\n #{obj.inspect}", :user=>user, :api_key=>api_key, :object=>obj) or return false
    end
    # Delete old posts
    delete_all(["created_at < ?", Mage::Application.settings[:keep_journal_days].days.ago])
    return true
  end
end
