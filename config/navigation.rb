# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.
    #
    primary.item :accounting, 'Bokför', accounting_index_path do |accounting|
      accounting.item :new_voucher, 'Nytt verifikat', new_voucher_path, if: proc { can? :write, current_series }
      # accounting.item :bank_accounting, "Bankhändelser", bank_accounting_index_path
      accounting.item :search_vouchers, 'Sök verifikat', vouchers_path, highlights_on: /\/(vouchers|verifikat)\/[0-9]+/
      accounting.item :manage_templates, 'Hantera mallar', voucher_templates_path, highlights_on: /\/(voucher_templates|mallar)(\/[0-9]+)?/
      accounting.item :account_list, 'Kontoplan', activity_year_accounts_path(current_activity_year)
    end

    primary.item :reports, 'Rapporter', reports_path do |_reports|
    end

    primary.item :administration, 'Administrera', administration_index_path, if: proc { current_user.admin? } do |admin|
      admin.item :users, 'Användare', users_path, highlights_on: /\/(users|anvandare)/
      admin.item :organs, 'Nämnder och arrangemang', organs_path, highlights_on: /\/(organs|namnder)/
      admin.item :series, 'Serier', series_index_path, highlights_on: /\/(series|serier)/
      admin.item :activity_years, 'Verksamhetsår och kontoplaner', activity_years_path, highlights_on: /\/(activity_year|verksamhetsar)(\/.*)?/
      admin.item :account_groups, 'Kontogrupper', account_groups_path, highlights_on: /\/(account_group|kontogrupp)(\/.*)?/
      admin.item :journal, 'Journal', journals_path, highlights_on: /\/(journals?)(\/.*)?/
      admin.item :api_keys, 'Apinycklar', api_keys_path, highlights_on: /\/(api_keys|apinycklar)/
    end

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false
  end
end
