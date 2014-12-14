class JournalsController < InheritedResources::Base
  def index
    authorize! :read, Journal
    @journal_entries = Journal.order('created_at DESC').page(params[:page]).per(100)
  end
end
