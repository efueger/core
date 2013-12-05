require "spec_helper"

describe "Create an order for a customer", js: true do
  context "without extras" do
    it "allows to create a new order" do
      @distributor = Fabricate(:distributor)
      simulate_distributor_sign_in

      customer = Fabricate(:customer, distributor: @distributor)
      Fabricate(:box, distributor: @distributor)

      visit distributor_customer_path(id: customer.id)
      click_link "Create a new order"
      page.should_not have_content "Extras"
      click_button "Create Order"
      page.should have_content "Order was successfully created"
    end
  end

  context "with extras" do
    it "allows to create a new order" do
      @distributor = Fabricate(:distributor_with_everything)
      simulate_distributor_sign_in

      customer = @distributor.customers.first

      visit distributor_customer_path(id: customer.id)
      click_link "Create a new order"
      page.should have_content "Extras"
      click_button "Create Order"
      page.should have_content "Order was successfully created"
    end
  end
end