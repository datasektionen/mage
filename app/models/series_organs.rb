class SeriesOrgans < ActiveRecord::Base
  belongs_to :serie
  belongs_to :organ
end
