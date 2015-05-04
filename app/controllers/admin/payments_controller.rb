class Admin::PaymentsController < ApplicationController
  before_filter :require_logged_in
  before_filter :require_admin

  def index
    @payments = Payment.all
  end
end