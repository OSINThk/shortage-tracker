require 'test_helper'

class SupportedLocalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supported_locale = supported_locales(:one)
  end

  test "should get index" do
    get supported_locales_url
    assert_response :success
  end

  test "should get new" do
    get new_supported_locale_url
    assert_response :success
  end

  test "should create supported_locale" do
    assert_difference('SupportedLocale.count') do
      post supported_locales_url, params: { supported_locale: { name: @supported_locale.name } }
    end

    assert_redirected_to supported_locale_url(SupportedLocale.last)
  end

  test "should show supported_locale" do
    get supported_locale_url(@supported_locale)
    assert_response :success
  end

  test "should get edit" do
    get edit_supported_locale_url(@supported_locale)
    assert_response :success
  end

  test "should update supported_locale" do
    patch supported_locale_url(@supported_locale), params: { supported_locale: { name: @supported_locale.name } }
    assert_redirected_to supported_locale_url(@supported_locale)
  end

  test "should destroy supported_locale" do
    assert_difference('SupportedLocale.count', -1) do
      delete supported_locale_url(@supported_locale)
    end

    assert_redirected_to supported_locales_url
  end
end
