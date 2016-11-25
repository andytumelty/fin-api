require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_one = users(:user_one)
    @user_one_auth = ActionController::HttpAuthentication::Basic.
      encode_credentials(@user_one.email, 'test')
    @user_two = users(:user_two)
    @user_two_auth = ActionController::HttpAuthentication::Basic.
      encode_credentials(@user_two.email, 'test')
    @account = accounts(:account_one)
  end

  test "should require auth to index accounts" do
    get accounts_url,
      as: :json
    assert_response :unauthorized
  end

  test "should require auth to show account" do
    get account_url(@account),
      as: :json
    assert_response :unauthorized
  end

  test "should require auth to update account" do
    patch account_url(@account),
      params: {
        account: {
          name: 'auth_fail'
        }
      },
      as: :json
    assert_response :unauthorized
  end

  test "should require auth to delete account" do
    delete account_url(@account),
      as: :json
    assert_response :unauthorized
  end

  test "should prevent showing other users accounts" do
    get account_url(@account),
      headers: { 'HTTP_AUTHORIZATION' => @user_two_auth },
      as: :json
    assert_response :not_found
  end

  test "should prevent updating other users accounts" do
    patch account_url(@account),
      headers: { 'HTTP_AUTHORIZATION' => @user_two_auth },
      params: {
        account: {
          name: 'not_authorized'
        }
      },
      as: :json
    assert_response :not_found
  end

  test "should prevent deleting other users accounts" do
    delete account_url(@account),
      headers: { 'HTTP_AUTHORIZATION' => @user_two_auth },
      as: :json
    assert_response :not_found
  end

  test "should prevent updating user" do
    patch account_url(@account),
      headers: { 'HTTP_AUTHORIZATION' => @user_one_auth },
      params: {
        account: {
          name: 'not_authorized',
          user_id: @user_two.id
        }
      },
      as: :json
    assert_response :bad_request
  end

  test "should get index" do
    get accounts_url,
      headers: { 'HTTP_AUTHORIZATION' => @user_one_auth },
      as: :json
    assert_response :success
    assert_equal @user_one.accounts.ids, JSON.parse(@response.body).collect{ |a| a['id'] }
  end

  test "should create account" do
    assert_difference('Account.count') do
      post accounts_url,
        headers: { 'HTTP_AUTHORIZATION' => @user_one_auth },
        params: {
          account: {
            name: 'test'
          }
        },
        as: :json
    end

    assert_response 201
  end

  test "should show account" do
    get account_url(@account),
      headers: { 'HTTP_AUTHORIZATION' => @user_one_auth },
      as: :json
    assert_response :success
    assert_equal ['id', 'name'], JSON.parse(@response.body).keys
  end

  test "should update account" do
    patch account_url(@account),
      headers: { 'HTTP_AUTHORIZATION' => @user_one_auth },
      params: {
        account: {
          name: 'update_test'
        }
      },
      as: :json
    assert_response 200
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete account_url(@account),
        headers: { 'HTTP_AUTHORIZATION' => @user_one_auth },
        as: :json
    end

    assert_response 204
  end

end
