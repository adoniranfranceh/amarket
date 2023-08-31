class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :all_month_accurately, ->(date) {
    first_date = date.beginning_of_month
    last_date = date.end_of_day
    return first_date..last_date
  }

  scope :within_current_month, -> {
    where(created_at: all_month_accurately(Date.today))
  }

  scope :within_selected_day, ->(select_date) {
    where(created_at: select_date.all_day)
  }

  scope :within_selected_month, ->(select_date) {
    where(created_at: all_month_accurately(select_date))
  }
end
