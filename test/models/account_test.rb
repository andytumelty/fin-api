require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "require name on create" do
    u = User.create(
      email: 'account@test.com',
      password: 'test',
      password_confirmation: 'test'
    )
    a = Account.new(
      name: nil,
      user: u
    )
    assert_not a.save, "Saved account without name"
  end

  test "require name to be unique to user" do
    u_1 = User.create(
      email: 'account@test.com',
      password: 'test',
      password_confirmation: 'test'
    )
    u_2 = User.create(
      email: 'account_2@test.com',
      password: 'test',
      password_confirmation: 'test'
    )
    a = Account.new(
      name: 'not_unique',
      user: u_1
    )
    assert a.save
    a = Account.new(
      name: 'not_unique',
      user: u_2
    )
    assert a.save
    a = Account.new(
      name: 'not_unique',
      user: u_2
    )
    assert_not a.save, "Saved account with non unique name"
  end
end
