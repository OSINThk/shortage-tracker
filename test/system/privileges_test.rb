require "application_system_test_case"

class PrivilegesTest < ApplicationSystemTestCase
  setup do
    @privilege = privileges(:one)
  end

  test "visiting the index" do
    visit privileges_url
    assert_selector "h1", text: "Privileges"
  end

  test "creating a Privilege" do
    visit privileges_url
    click_on "New Privilege"

    fill_in "Name", with: @privilege.name
    click_on "Create Privilege"

    assert_text "Privilege was successfully created"
    click_on "Back"
  end

  test "updating a Privilege" do
    visit privileges_url
    click_on "Edit", match: :first

    fill_in "Name", with: @privilege.name
    click_on "Update Privilege"

    assert_text "Privilege was successfully updated"
    click_on "Back"
  end

  test "destroying a Privilege" do
    visit privileges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Privilege was successfully destroyed"
  end
end
