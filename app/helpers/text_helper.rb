module TextHelper
  def yes_no(var)
    var ? I18n.t('simple_form.yes') : I18n.t('simple_form.no')
  end
end
