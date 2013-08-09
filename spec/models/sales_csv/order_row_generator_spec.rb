require 'fast_spec_helper'
require_model 'row_generator', sub_dir: 'sales_csv'
require_model 'order_row_generator', sub_dir: 'sales_csv'
required_constants %w(Order)

describe SalesCsv::OrderRowGenerator do
  let(:order) do
    double('order',
      route_name: 'rname',
      id: 1,
      customer: customer,
      address: address,
      box_name: 'bname',
      has_exclusions?: true,
      has_substitutions?: true,
      substitutions_string: 'sub',
      exclusions_string: 'ex',
      order_extras: 'oe',
      price: 10.00,
      consumer_delivery_fee: 1.00,
      total_price: 11.00,
    )
  end
  let(:customer) do
    double('customer',
      number: 1,
      first_name: 'fname',
      last_name: 'lname',
      new?: true,
      email: 'em@ex.com',
      special_order_preference: 'pref',
    )
  end
  let(:address) do
    double('address',
      phones: double(default_number: 8888),
      address_1: 'street 1',
      address_2: 'apt 1',
      suburb: 'sub',
      city: 'city',
      postcode: 123,
      delivery_note: 'note',
    )
  end
  let(:row_generator) { SalesCsv::OrderRowGenerator.new(order) }

  describe '#generate' do
    it 'generates a array for conversion to csv row' do
      Order.stub(:short_code) { 'sc' }
      Order.stub(:extras_description) { 'exd' }
      row_generator.generate.should == ["rname", nil, nil, 1, nil, nil, 1, "fname", "lname", 8888, "NEW", "street 1", "apt 1", "sub", "city", 123, "note", "sc", "bname", "sub", "ex", "exd", 10.0, 1.0, 11.0, "em@ex.com", "pref", "waiting", "waiting"]
    end
  end
end

