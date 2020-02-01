require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get reports_url
    assert_response :success
  end

  test "should get new" do
    get new_report_url
    assert_response :success
  end

  test "should create report" do
    assert_difference('Report.count') do
      product_details = product_details(:one)
      post reports_url, params: {
        report: {
          coordinates: @report.coordinates,
          ip: @report.ip,
          notes: @report.notes,
          user_id: @report.user_id,
          product_detail_attributes: [
            {
              scarcity: product_details.scarcity,
              price: product_details.price,
              notes: product_details.notes,
              product_id: product_details.product_id,
              report_id: product_details.report_id
            }
          ]
        }
      }
    end

    assert_redirected_to report_url(Report.last)
  end

  test "should show report" do
    get report_url(@report)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_url(@report)
    assert_response :success
  end

  test "should update report" do
    product_details = product_details(:one)
    patch report_url(@report), params: {
      report: {
        coordinates: @report.coordinates,
        ip: @report.ip,
        notes: @report.notes,
        user_id: @report.user_id,
        product_detail_attributes: [
          {
            scarcity: product_details.scarcity,
            price: product_details.price,
            notes: product_details.notes,
            product_id: product_details.product_id,
            report_id: product_details.report_id
          }
        ]
      }
    }
    assert_redirected_to report_url(@report)
  end

  test "should destroy report" do
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end
end
