module StripeWrapper
  class Charge
    attr_reader :response, :status
    
    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount], # amount in cents, again
          :currency => "usd",
          :source => options[:token],
          :description => options[:description]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        response = new(e, :error)
      end
    end

    def success?
      status == :success
    end

    def error_message
      response.message
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end
end