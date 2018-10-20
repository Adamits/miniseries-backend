class V1::AccountController < ApplicationController
  before_action :authenticate_v1_user!
end
