class PricingPlan < ActiveRecord::Base
  before_create :create_unique_key
  after_create :create_stripe_plan
  before_update :update_stripe_plan

  has_many :products

  validates :title, :interval, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :interval_count, numericality: { greater_than: 0 }
  validates :trial_period_days, numericality: true

  private

  def create_unique_key
    self.unique_key = title.downcase.gsub(/[^\w]/, '-')
    while PricingPlan.find_by(unique_key: self.unique_key)
      self.unique_key = self.unique_key.next
    end
  end

  def create_stripe_plan
    plan = Stripe::Plan.create(
      amount: self.price,
      interval: self.interval,
      interval_count: self.interval_count,
      trial_period_days: self.trial_period_days,
      name: self.title,
      currency: 'usd',
      id: self.unique_key
    )
    update_columns(stripe_id: plan.id)
  end

  def update_stripe_plan
    plan = Stripe::Plan.retrieve(self.stripe_id)
    plan.name = self.title
    plan.save
  end
end
