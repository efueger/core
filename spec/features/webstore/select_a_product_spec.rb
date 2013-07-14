require_relative 'webstore_helper'

describe 'select a product from the webstore' do
  let(:distributor)     { Fabricate(:distributor) }
  let(:box_name)        { 'Couples Box' }
  let(:box_description) { 'This box is perfect for couples for a week!' }
  let(:box_price)       { 21.50 }
  let(:product) do
    Fabricate(:box,
      distributor:  distributor,
      name:         box_name,
      description:  box_description,
      price:        box_price
    )
  end

  before do
    @distributor = distributor
    setup_a_webstore(product)
    visit webstore_store_path(distributor.parameter_name)
    click_button 'Order'
  end

  it 'loads the customise step' do
    expect(page).to have_content box_name
    expect(page).to have_content box_description
    expect(page).to have_content box_price
  end

  shared_examples_for 'it has exclusions' do
    it 'can be customised' do
      expect(page).to have_content 'Customise my box'
    end
  end

  shared_examples_for 'it has extras' do
    it 'extras can be added' do
      expect(page).to have_content 'Add any amount of extra items'
      expect(page).to have_css '#s2id_webstore_order_extras_add_extra'
    end
  end

  context 'ordering a product that allows exclusions' do
    it_behaves_like 'it has exclusions'
  end

  context 'ordering a product that allows extras' do
    it_behaves_like 'it has extras'
  end

  context 'ordering a product that allows both exclusions and extras' do
    it_behaves_like 'it has exclusions'
    it_behaves_like 'it has extras'
  end
end
