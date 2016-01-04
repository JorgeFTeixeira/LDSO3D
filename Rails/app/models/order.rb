class Order < ActiveRecord::Base
	belongs_to :Experience
	has_many :transactions, :class_name => "OrderTransaction"
	attr_accessor :card_number, 
	:card_verification,
	:address,
	:city,
	:country,
	:zip

	validate :validate_card, :on => :create

	def purchase(price)
		response = GATEWAY.purchase(price_in_cents(price), credit_card, purchase_options)
		transactions.create!(:action => "purchase", :amount => price_in_cents(price), :response => response)
		cart.update_attribute(:purchased_at, Time.now) if response.success?
		response.success?
	end

	def price_in_cents(price)
		100*price.to_f
	end

	private

	def validate_card
		unless credit_card.valid?
			credit_card.errors.full_messages.each do |message|
				errors[:base] << message
			end
		end
	end

	def credit_card
		@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
			:number             => card_number,
			:verification_value => card_verification,
			:month              => card_expires_on.month,
			:year               => card_expires_on.year,
			:first_name         => first_name,
			:last_name			=> last_name,
			)
	end

  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => "Ryan Bates",
        :address1 => "123 Main St.",
        :city     => "New York",
        :state    => "NY",
        :country  => "US",
        :zip      => "10001"
      }
    }
  end
end
