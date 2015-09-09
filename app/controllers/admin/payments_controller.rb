class Admin::PaymentsController < ApplicationController

  def index
    @payments = Payment.all
  end

end
