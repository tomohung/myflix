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
          amount: options[:amount], # amount in cents, again
          currency: "usd",
          source: options[:source],
          description: options[:description]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def self.customer(options = {})    
      begin
        response = Stripe::Customer.create(
          source: options[:source],
          plan: "BASE",
          email: options[:email]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def success?
      status == :success
    end

    def error_message
      response.message
    end

    def customer_token
      response.id
    end

  end


  def self.set_api_key
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end
end
