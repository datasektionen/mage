module ApplicationHelper

  def javascript(*scripts)
    @javascripts = Hash.new unless @javascripts
    scripts.each do |s|
      unless @javascripts.has_key? s
        @javascripts[s]=true
        content_for(:head) do
          javascript_include_tag(s)
        end
      end
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

  def top_navigation_link(menu_name, path, text, cur_menu)
    css_class = (menu_name == cur_menu) ? 'active' : ''
    
    content_tag(:li, :class => css_class) do
      link_to text, path
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

  def format_date(date_or_time) 
    I18n.l date_or_time.to_date
  end

  def link_to_remove_field(name, f, parents=[])
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this, #{parents.to_s})")
  end

  def link_to_add_fields(name, f, association, container_match)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.simple_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}', '#{container_match}')",)
  end
end
