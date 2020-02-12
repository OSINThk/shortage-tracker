require "application_system_test_case"

class SupportedLocalesTest < ApplicationSystemTestCase
  setup do
    @supported_locale = supported_locales(:one)
  end

  test "visiting the index" do
    visit supported_locales_url
    assert_selector "h1", text: "Supported Locales"
  end

  test "creating a Supported locale" do
    visit supported_locales_url
    click_on "New Supported Locale"

    fill_in "Name", with: @supported_locale.name
    click_on "Create Supported locale"

    assert_text "Supported locale was successfully created"
    click_on "Back"
  end

  test "updating a Supported locale" do
    visit supported_locales_url
    click_on "Edit", match: :first

    fill_in "Name", with: @supported_locale.name
    click_on "Update Supported locale"

    assert_text "Supported locale was successfully updated"
    click_on "Back"
  end

  test "destroying a Supported locale" do
    visit supported_locales_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Supported locale was successfully destroyed"
  end
end
