require "application_system_test_case"

class ProductDetailsTest < ApplicationSystemTestCase
  setup do
    @product_detail = product_details(:one)
  end

  test "visiting the index" do
    visit product_details_url
    assert_selector "h1", text: "Product Details"
  end

  test "creating a Product detail" do
    visit product_details_url
    click_on "New Product Detail"

    fill_in "Notes", with: @product_detail.notes
    fill_in "Price", with: @product_detail.price
    fill_in "Product", with: @product_detail.product_id
    fill_in "Report", with: @product_detail.report_id
    fill_in "Scarcity", with: @product_detail.scarcity
    click_on "Create Product detail"

    assert_text "Product detail was successfully created"
    click_on "Back"
  end

  test "updating a Product detail" do
    visit product_details_url
    click_on "Edit", match: :first

    fill_in "Notes", with: @product_detail.notes
    fill_in "Price", with: @product_detail.price
    fill_in "Product", with: @product_detail.product_id
    fill_in "Report", with: @product_detail.report_id
    fill_in "Scarcity", with: @product_detail.scarcity
    click_on "Update Product detail"

    assert_text "Product detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Product detail" do
    visit product_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product detail was successfully destroyed"
  end
end
