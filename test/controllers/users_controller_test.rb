require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
    @user_auth = ActionController::HttpAuthentication::Basic.
      encode_credentials(@user.email, 'test')
  end

  test "should create user" do
    assert_difference('User.count') do
      # FIXME want to create @user here instead of in setup
      post user_url, params: {
        user: { 
          email: 'test@email.com',
          password: 'test',
          password_confirmation: 'test'
        } 
      },
      as: :json
    end
    assert_response 201
  end

  test "should require auth to show user" do
    get user_url,
      as: :json
    assert_response 401
  end

  test "should require auth to update user" do
    patch user_url,
      params: {
        user: {
          email: 'change@email.com'
        }
      },
      as: :json
    assert_response 401
  end

  test "should require auth to delete user" do
    delete user_url,
      as: :json
    assert_response 401
  end

  test "should show user" do
    #puts @user.inspect
    get user_url,
      headers: { 'HTTP_AUTHORIZATION' => @user_auth },
      as: :json
    assert_response :success
    assert_equal @user.email, JSON.parse(@response.body)['email']
    assert_equal ['email'], JSON.parse(@response.body).keys
  end

  test "should update user" do
    patch user_url,
      params: { user: { email: 'change@email.com' } },
      headers: { 'HTTP_AUTHORIZATION' => @user_auth },
      as: :json
    assert_equal 'change@email.com', JSON.parse(@response.body)['email']
    assert_response 200, "couldn't update user: #{@response.body}"
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
    delete user_url,
      headers: { 'HTTP_AUTHORIZATION' => @user_auth },
      as: :json
    end
    assert_response 204
  end

  test "user doesn't exist should not authenticate" do
    user_auth = ActionController::HttpAuthentication::Basic.
      encode_credentials('not_there@email.com', 'nope')
    #puts @user.inspect
    get user_url,
      headers: { 'HTTP_AUTHORIZATION' => user_auth },
      as: :json
    assert_response 401
  end

  test "should get accounts" do
    flunk
  end
end
