class SeriesController < InheritedResources::Base
  #Yes, i hate myself, a rewrite serie->series is reeeeally needed
  defaults :resource_class => Serie, :collection_name=>'series', :instance_name => 'serie'
  load_and_authorize_resource :serie

end
