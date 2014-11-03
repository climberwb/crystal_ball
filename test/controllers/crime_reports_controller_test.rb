require 'test_helper'

class CrimeReportsControllerTest < ActionController::TestCase
  setup do
    @crime_report = crime_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crime_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crime_report" do
    assert_difference('CrimeReport.count') do
      post :create, crime_report: {  }
    end

    assert_redirected_to crime_report_path(assigns(:crime_report))
  end

  test "should show crime_report" do
    get :show, id: @crime_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @crime_report
    assert_response :success
  end

  test "should update crime_report" do
    patch :update, id: @crime_report, crime_report: {  }
    assert_redirected_to crime_report_path(assigns(:crime_report))
  end

  test "should destroy crime_report" do
    assert_difference('CrimeReport.count', -1) do
      delete :destroy, id: @crime_report
    end

    assert_redirected_to crime_reports_path
  end
end
