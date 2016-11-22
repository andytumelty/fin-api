require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test "require email on create" do
        u = User.new(
            email: nil                      ,
            password: 'test'                ,
            password_confirmation: 'test' 
        )
        assert_not u.save, "Saved user without an email"
    end

    test "require password on create" do
        u = User.new(
            email: 'user_1@email.com'       ,
            password: nil                   ,
            password_confirmation: 'nada'
        )
        assert_not u.save, "Saved user without password"
    end

    test "require password_confirmation on create" do
        u = User.new(
            email: 'user_1@email.com'       ,
            password: 'test'                ,
            password_confirmation: nil
        )
        assert_not u.save, "Saved user without password_confirmation"
    end

    test "prevent duplicate email on create" do
        u_1 = User.new(
            email: 'duplicate@email.com'    ,
            password: 'test'                ,
            password_confirmation: 'test'
        )
        assert u_1.save
        u_2 = User.new(
            email: 'duplicate@email.com'    ,
            password: 'test'                ,
            password_confirmation: 'test'
        )
        assert_not u_2.save, "Created user with duplicate email"
    end

    test "prevent duplicate email on update" do
        u_1 = User.new(
            email: 'duplicate@email.com'    ,
            password: 'test'                ,
            password_confirmation: 'test'
        )
        assert u_1.save
        u_2 = User.new(
            email: 'not_duplicate@email.com',
            password: 'test'                ,
            password_confirmation: 'test'
        )
        assert u_2.save
        u_2.email = 'duplicate@email.com'
        assert_not u_2.save, "Updated user with duplicate email"
    end
end
