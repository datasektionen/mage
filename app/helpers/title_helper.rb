# -*- encoding: utf-8 -*-

module TitleHelper
  def title(title)
    @title = title
  end
  
  def render_title
    if @title.present?
      title = @title
    else
      title = if @page.present?
        @page.title.present? ? @page.title  : ""
      end
    end
    
    if title.blank?
      title = "MAGE"
    else
      title += " – MAGE" 
    end
    title
  end
  
end
