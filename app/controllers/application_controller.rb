class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent
    before_action :authenticate_admin!
end
