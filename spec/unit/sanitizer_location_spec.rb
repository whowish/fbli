# encoding: utf-8
require 'spec_helper'

describe "SanitizerLocationSpec" do
  
  
  it "sanitizes correctly (for location)" do
    
    value = SanitizerLocation.sanitize(0.0005, 100.2343)
    value.should == 100.2340

  end


  it "sanitizes correctly (for score by area)" do
    
    value = SanitizerLocation.sanitize(0.01, 100.2343)
    value.should == 100.23

  end

  it "sanitizes correctly" do
    
    value = SanitizerLocation.sanitize(0.5, 100.7343)
    value.should == 100.5

  end

  it "sanitizes correctly" do
    
    value = SanitizerLocation.sanitize(0.5, 100.5100)
    value.should == 100.5

  end

  it "sanitizes correctly" do
    
    value = SanitizerLocation.sanitize(0.5, 100.49000)
    value.should == 100.5

  end


  it "sanitizes integer correctly" do
    
    value = SanitizerLocation.sanitize(5, 97.2343)
    value.should == 95

  end

  it "sanitizes integer correctly" do
    
    value = SanitizerLocation.sanitize(1, 97.2343)
    value.should == 97

  end



end