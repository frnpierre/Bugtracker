require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home" do
    it "returns http redirect" do
      get :home
      expect(response).to have_http_status(:redirect)
    end
  end

end
