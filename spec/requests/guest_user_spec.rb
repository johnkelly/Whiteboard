require 'spec_helper'

describe "Unregistered User" do
  before { visit root_path }

  it "allows guest to view plans" do
    click_link "Pricing"
    page.should have_selector('.page-header h1', text: "Pricing")
    click_link "Sign up"
  end

  it "allows guest to sign up" do
    click_link "Sign Up"
    page.should have_selector('.page-header h1', text: "Join Whiteboard")

    within("form#new_user") do
      fill_in 'Email', with: 'guest@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button "Sign up"
    end
    page.should have_selector('.alert.alert-info', text: "Welcome! You have signed up successfully.")
    page.should have_selector('.page-header h1', text: "Billing Information")
    click_link "My Account"
    page.should have_selector('.page-header h1', text: "guest@example.com")
    click_link "Sign Out"
    page.should have_selector('.alert.alert-info', text: "Signed out successfully.")
  end
end