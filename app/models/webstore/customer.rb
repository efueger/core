#NOTE: Can be cleaned up with SimpleDelegator or Forwardable in std Ruby lib.

require 'draper'
require_relative '../webstore'

class Webstore::Customer
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :existing_customer_id

  GUEST_HALTED     = false
  GUEST_DISCOUNTED = false
  GUEST_ACTIVE     = false

  def initialize(args = {})
    @cart                 = args.fetch(:cart, nil)
    @existing_customer_id = args.fetch(:existing_customer_id, nil)
  end

  def fetch(key, default_value = nil)
    send(key) || default_value
  end

  def guest?
    !existing_customer
  end

  def existing_customer
    Customer.find(existing_customer_id) if existing_customer_id
  end

  def distributor
    existing_customer.distributor if existing_customer
  end

  def associate_real_customer(customer_id)
    @existing_customer_id = customer_id
  end

  def halted?
    guest? ? GUEST_HALTED : existing_customer.halted?
  end

  def discount?
    guest? ? GUEST_DISCOUNTED : existing_customer.discount?
  end

  def active?
    guest? ? GUEST_ACTIVE : existing_customer.active?
  end

  def name
    existing_customer.name unless guest?
  end

  def route_id
    existing_customer.route.id if active?
  end

  def address
    existing_customer ? existing_customer.address : NullObject.new
  end

  def account_balance
    existing_customer ? existing_customer.account_balance : Money.new(0)
  end

  def balance_threshold
    existing_customer.balance_threshold
  end
end