class Invoice < ActiveRecord::Base
  belongs_to :voucher
  validates_presence_of :voucher, :status, :direction, :due_days, :title
end
