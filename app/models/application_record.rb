class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :within_current_month, -> {
    where(created_at: Date.current.all_month)
  }
  scope :within_selected_day, ->(select_date) {
    where(created_at: select_date.all_day)
  }
  scope :within_selected_month, ->(select_date) {
    where(created_at: select_date.all_month)
  }
end
