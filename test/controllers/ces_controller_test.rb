require 'test_helper'

class CesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ce = ces(:one)
  end

  test "should get index" do
    get ces_url
    assert_response :success
  end

  test "should get new" do
    get new_ce_url
    assert_response :success
  end

  test "should create ce" do
    assert_difference('Ce.count') do
      post ces_url, params: { ce: {  } }
    end

    assert_redirected_to ce_url(Ce.last)
  end

  test "should show ce" do
    get ce_url(@ce)
    assert_response :success
  end

  test "should get edit" do
    get edit_ce_url(@ce)
    assert_response :success
  end

  test "should update ce" do
    patch ce_url(@ce), params: { ce: {  } }
    assert_redirected_to ce_url(@ce)
  end

  test "should destroy ce" do
    assert_difference('Ce.count', -1) do
      delete ce_url(@ce)
    end

    assert_redirected_to ces_url
  end
end
