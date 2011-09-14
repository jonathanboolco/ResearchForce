require 'spec_helper'

describe SurveysController do

  describe "GET 'builder'" do
    it "should be successful" do
      get 'builder'
      response.should be_success
    end
  end

  describe "GET 'preview'" do
    it "should be successful" do
      get 'preview'
      response.should be_success
    end
  end

end
