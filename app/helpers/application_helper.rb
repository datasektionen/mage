module ApplicationHelper
  def javascript(*scripts)
    content_for(:head) do
      javascript_include_tag(*scripts)
    end
  end
  
  def stylesheet(*css)
    content_for(:head) do
      stylesheet_link_tag(*css)
    end
  end
  
  def current_url
    "http://" + request.raw_host_with_port + request.fullpath
  end
  
  def sub_navigation_link(text, path, regex)
    css_class = (request.fullpath =~ regex) ? 'active' : ''
    
    content_tag(:li, :class => css_class) do
      link_to text, path
    end
  end

  def top_navigation_link(name, text, cur_menu)
    css_class = (name == cur_menu) ? 'active' : ''
    
    content_tag(:li, :class => css_class) do
      link_to text, "/#{name}"
    end
  end

  def logged_in?
    session[:cas_user]
  end
  
  def session_change_link
    if user_signed_in?
      link_to "Logga ut", destroy_user_session_path,:class => "session-change"
    else
      link_to "Logga in", new_user_session_path, :class => "session-change"
    end
  end
  
  def currency(amount)
    number_to_currency(amount)
    # ("%0.2f" % amount.to_f).gsub('.',',')
  end
  
  def short_time(date_or_time)
    I18n.l date_or_time, :format => :short
  end
end
