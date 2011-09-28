class LogFilter
  def self.filter(controller)
    item = controller.send(:resource) # Overrides protected.. *Walks down the path to the dark side*
    unless item.new_record? #Don't log unsaved items
      Journal.log(
        controller.action_name,
        item,
        controller.current_user,
        controller.current_api_key
      )
    end
  end
end
