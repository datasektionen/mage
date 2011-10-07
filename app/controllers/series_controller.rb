class SeriesController < InheritedResources::Base
  defaults :resource_class => Serie, :collection_name=>'series', :instance_name => 'serie'
  load_and_authorize_resource
end
