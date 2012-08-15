require 'spec_helper'
include Warden::Test::Helpers

describe "Registered User not signed in" do
  let(:user) { create(:trial_user) }
  before { visit root_path }

  it "allows registered user to sign in" do
    click_link "Sign In"
    page.should have_selector('.page-header h1', text: "Sign In")

    within("form#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button "Sign in"
    end
    page.should have_selector('.alert.alert-info', text: "Signed in successfully.")
    click_link "My Account"
    page.should have_selector('.page-header h1', text: user.email)
    click_link "Sign Out"
    page.should have_selector('.alert.alert-info', text: "Signed out successfully.")
  end
end

describe "Signed in user" do
  let(:user) { create(:trial_user) }
  before(:each) do
    login_as user, scope: :user
    visit root_path
  end

  describe "My Account" do
    before { click_link "My Account" }

    it "can view my account page" do
      page.should have_selector('.page-header h1', text: user.email)
    end

    it "can change email and password" do
      within("form#edit_user") do
        fill_in 'Email', with: "newemail@example.com"
        fill_in 'New Password', with: "drowssap"
        fill_in 'Confirm New Password', with: "drowssap"
        fill_in 'Current password', with: user.password
        click_button "Update"
      end
      page.should have_selector('.alert.alert-info', text: "You updated your account successfully.")
      click_link "Sign Out"
      click_link "Sign In"

      within("form#new_user") do
        fill_in 'Email', with: "newemail@example.com"
        fill_in 'Password', with: "drowssap"
        click_button "Sign in"
      end
      page.should have_selector('.alert.alert-info', text: "Signed in successfully.")
    end

    it "can cancel account" do
      click_link "Close Account"
      page.should have_selector('.alert.alert-info', text: "Bye! Your account was successfully cancelled. We hope to see you again soon.")
    end

    it "can add subscription" do
      click_link "Add a Subscription"
      page.should have_selector('.page-header h1', text: "Pricing")
    end

    it "can update billing information" do
      click_link "Update Billing Info"
      page.should have_selector('.page-header h1', text: "Billing Information")
      within("form") do
        fill_in 'Credit Card Number', with: "4242424242424242"
        fill_in 'Security Code on Card (CVC)', with: "123"
        select('8 - August', from: 'card_month')
        select(2.years.from_now.year.to_s, from: 'card_year')

        fill_in 'Full Name as it appears on card', with: "A Tester"
        fill_in 'Zip/Postal Code of Billing Address', with: "63130"
        click_button "Add Credit card"
      end
      page.should have_selector('.alert.alert-info', text: "Your billing information was updated.")
      page.should have_selector('.page-header h1', text: "Pricing")
    end
  end

  describe "Plans" do
    it "can view plans page" do
      click_link "Pricing"
      page.should have_selector('.page-header h1', text: "Pricing")
      click_link "Add Billing Info to Subscribe"
      page.should have_selector('.page-header h1', text: "Billing Information")
    end
  end
end