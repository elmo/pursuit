require 'test_helper'

class PumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pum = pums(:one)
  end

  test "should get index" do
    get pums_url
    assert_response :success
  end

  test "should get new" do
    get new_pum_url
    assert_response :success
  end

  test "should create pum" do
    assert_difference('Pum.count') do
      post pums_url, params: { pum: { account_id: @pum.account_id, account_name: @pum.account_name, ad_group_id: @pum.ad_group_id, ad_group_name: @pum.ad_group_name, campaign_id: @pum.campaign_id, campaign_name: @pum.campaign_name, click_count: @pum.click_count, clickouts: @pum.clickouts, cost: @pum.cost, cost_per_click: @pum.cost_per_click, date: @pum.date, device_type: @pum.device_type, focus_word: @pum.focus_word, impressions: @pum.impressions, industry: @pum.industry, keyword: @pum.keyword, keyword_id: @pum.keyword_id, label: @pum.label, lead_request_users: @pum.lead_request_users, lead_users: @pum.lead_users, leads: @pum.leads, publisher: @pum.publisher, total_clickout_revenue: @pum.total_clickout_revenue, total_unreconciled_revenue: @pum.total_unreconciled_revenue } }
    end

    assert_redirected_to pum_url(Pum.last)
  end

  test "should show pum" do
    get pum_url(@pum)
    assert_response :success
  end

  test "should get edit" do
    get edit_pum_url(@pum)
    assert_response :success
  end

  test "should update pum" do
    patch pum_url(@pum), params: { pum: { account_id: @pum.account_id, account_name: @pum.account_name, ad_group_id: @pum.ad_group_id, ad_group_name: @pum.ad_group_name, campaign_id: @pum.campaign_id, campaign_name: @pum.campaign_name, click_count: @pum.click_count, clickouts: @pum.clickouts, cost: @pum.cost, cost_per_click: @pum.cost_per_click, date: @pum.date, device_type: @pum.device_type, focus_word: @pum.focus_word, impressions: @pum.impressions, industry: @pum.industry, keyword: @pum.keyword, keyword_id: @pum.keyword_id, label: @pum.label, lead_request_users: @pum.lead_request_users, lead_users: @pum.lead_users, leads: @pum.leads, publisher: @pum.publisher, total_clickout_revenue: @pum.total_clickout_revenue, total_unreconciled_revenue: @pum.total_unreconciled_revenue } }
    assert_redirected_to pum_url(@pum)
  end

  test "should destroy pum" do
    assert_difference('Pum.count', -1) do
      delete pum_url(@pum)
    end

    assert_redirected_to pums_url
  end
end
