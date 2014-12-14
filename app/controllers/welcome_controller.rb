class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_user!

  def index
    @page_title = 'start'
    @not_verified = current_user && !current_user.has_access?
  end
end
