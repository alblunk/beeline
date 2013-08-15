require "test_helper"

describe BrandsController do
  include Devise::TestHelpers

  describe "as an authenticated user" do

    before { sign_in users(:alex) }

    describe "#create" do

      it "succeeds with valid params" do
        assert_difference "Brand.count" do
          post :create, brand: { name: "Steve's Tees", profile: "They're all blue." }
        end
        
        assert_redirected_to brand_path(assigns(:brand))
      end

      it "fails with invalid params" do
        assert_no_difference "Brand.count" do
          post :create, brand: { bad: "params" }
        end
        
        assert_response :unprocessable_entity
        assert_template :new
      end

    end

    describe "#update" do

      let(:brand) { brands(:one) }

      it "suceeds with valid params" do
        put :update, id: brand, brand: { name: "Mike's Bikes" }
        
        assert_redirected_to brand_path(assigns(:brand))
      end

    end

  end

  describe "as an unauthenticated user" do

    describe "#create" do
      
      it "fails and requires sign in" do
        post :create, brand: { name: "Steve's Tees", profile: "They're all blue." }
        assert_redirected_to new_user_session_path
      end

    end

    describe "#update" do

      let(:brand) { brands(:one) }
      
      it "fails and requires sign in" do
        put :update, id: brand, brand: { name: "Mike's Bikes" }
        assert_redirected_to new_user_session_path
      end

    end

  end

end