class LogFilter
  def self.filter(controller)
    Journal.log(
      controller.action_name,
      controller.send(:resource), # Overrides protected.. *Walks down the path to the dark side*
      controller.current_user
    )
  end
end
