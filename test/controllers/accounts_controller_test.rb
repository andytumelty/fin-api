require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # FIXME don't create here
    @user = User.create(
      email: 'account_integration@test.com',
      password: 'test',
      password_confirmation: 'test'
    )
    @account = Account.create(
      name: 'account_1',
      user: @user
    )
    @user_auth = ActionController::HttpAuthentication::Basic.
      encode_credentials(@user.email, @user.password)
  end

  test "should require auth to index accounts" do
    get accounts_url,
      as: :json
    assert_response 401
  end

  test "should require auth to show account" do
    get account_url(@account),
      as: :json
    assert_response 401
  end

  test "should require auth to update account" do
    patch account_url(@account),
      params: {
        account: {
          name: 'auth_fail'
        }
      },
      as: :json
    assert_response 401
  end

  test "should require auth to delete account" do
    delete account_url(@account),
      as: :json
    assert_response 401
  end

  test "should prevent indexing other users accounts" do
    flunk 
    # create accounts for user 1
    # create accounts for user 2
    # confirm accounts shown are only user 1
  end

  test "should prevent showing other users accounts" do
    flunk 
    # create accounts for user 1
    # create accounts for user 2
    # get account_url(@account_2)
    # if it's not your resource, show it couldn't be found
    # assert_response 404
  end

  test "should prevent updating other users accounts" do
    flunk 
  end

  test "should prevent deleting other users accounts" do
    flunk 
  end

  test "should get index" do
    get accounts_url,
      headers: { 'HTTP_AUTHORIZATION' => @user_auth },
      as: :json
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post accounts_url,
        headers: { 'HTTP_AUTHORIZATION' => @user_auth },
        params: {
          account: {
            name: 'test',
            user: @user
          }
        },
        as: :json
    end

    assert_response 201
  end

  test "should show account" do
    get account_url(@account),
      headers: { 'HTTP_AUTHORIZATION' => @user_auth },
      as: :json
    assert_response :success
  end

  test "should update account" do
    patch account_url(@account), params: { account: { name: @account.name, user_id: @account.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete account_url(@account), as: :json
    end

    assert_response 204
  end

  test "attributes" do
    flunk
  end
end
