class LogFilter
  def self.filter(controller)
    item = controller.send(:resource) # Overrides protected.. *Walks down the path to the dark side*
    if !item.new_record? && item.errors.empty? #Don't log unsaved items
      Journal.log(
        controller.action_name,
        item,
        controller.current_user,
        controller.current_api_key
      )
    end
  end
end
