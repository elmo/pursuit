require 'test_helper'

class PursuitMetricsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pursuit_metric = pursuit_metrics(:one)
  end

  test "should get index" do
    get pursuit_metrics_url
    assert_response :success
  end

  test "should get new" do
    get new_pursuit_metric_url
    assert_response :success
  end

  test "should create pursuit_metric" do
    assert_difference('PursuitMetric.count') do
      post pursuit_metrics_url, params: { pursuit_metric: { account_id: @pursuit_metric.account_id, custom: @pursuit_metric.custom, date: @pursuit_metric.date, earnings: @pursuit_metric.earnings } }
    end

    assert_redirected_to pursuit_metric_url(PursuitMetric.last)
  end

  test "should show pursuit_metric" do
    get pursuit_metric_url(@pursuit_metric)
    assert_response :success
  end

  test "should get edit" do
    get edit_pursuit_metric_url(@pursuit_metric)
    assert_response :success
  end

  test "should update pursuit_metric" do
    patch pursuit_metric_url(@pursuit_metric), params: { pursuit_metric: { account_id: @pursuit_metric.account_id, custom: @pursuit_metric.custom, date: @pursuit_metric.date, earnings: @pursuit_metric.earnings } }
    assert_redirected_to pursuit_metric_url(@pursuit_metric)
  end

  test "should destroy pursuit_metric" do
    assert_difference('PursuitMetric.count', -1) do
      delete pursuit_metric_url(@pursuit_metric)
    end

    assert_redirected_to pursuit_metrics_url
  end
end
