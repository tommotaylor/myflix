class Admin::PaymentsController < ApplicationController

before_action :require_user
before_action :require_admin

  def index
    @payments = Payment.all
  end

end
