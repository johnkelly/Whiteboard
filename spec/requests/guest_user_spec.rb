require 'spec_helper'

describe "Unregistered User" do
  before { visit root_path }

  it "allows guest to view plans" do
    click_link "Pricing"
    page.should have_selector('.page-header h1', text: "Subscription Plans")
    click_link "Sign Up Today!"
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
    click_link "My Account"
    page.should have_selector('.page-header h1', text: "guest@example.com")
    click_link "Sign Out"
    page.should have_selector('.alert.alert-info', text: "Signed out successfully.")
  end
end