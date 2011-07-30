class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :authorize_user!

  def index
    @page_title = "start"
  end
end
