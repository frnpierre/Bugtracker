require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  
  describe "flash_class" do 
    
    it "returns the correct string of bootstrap classes" do 
      base_string = "alert alert-dismissible"
      notice = helper.flash_class("notice")
      expect(notice).to eq("#{base_string} alert-info")
      notice = helper.flash_class("success")
      expect(notice).to eq("#{base_string} alert-success")
      notice = helper.flash_class("error")
      expect(notice).to eq("#{base_string} alert-danger")
      notice = helper.flash_class("alert")
      expect(notice).to eq("#{base_string} alert-danger")
    end
  end
end
