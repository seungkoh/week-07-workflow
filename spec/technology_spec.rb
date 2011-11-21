require "rubygems"
require "bundler/setup"
require 'simplecov'
SimpleCov.start
require File.expand_path(File.dirname(__FILE__) + '/../lib/technology.rb')

describe "states" do

  subject { Technology.new } 

  it "should start new" do
    subject.current_state.to_s.should == "new"
  end

  # I moved this out of the "when approved" context
  context "when unapproved" do
    it "should not be publishable" do
      subject.submit!
      expect { subject.publish! }.to raise_error
    end
    it "can be rejected" do
      subject.submit!
      subject.current_state.events.should have_key(:reject)
      subject.current_state.events.keys.should include(:reject)
    end
  end

  context "when approved" do
    it "should be approved" do
      subject.submit!
      subject.approve!
      subject.approved?.should == true
      subject.current_state.to_s.should == "approved"
    end
    it "should tell us it is approved" do
      subject.submit!
      expect { subject.approve! }.to_s == "technology is approved"
    end
    it "can be set back to unapproved" do
      subject.submit!
      subject.approve!
      subject.unapprove!
      subject.current_state.to_s.should == "unapproved"
    end
    it "available events should be publish and unapprove" do
      subject.submit!
      subject.approve!
      subject.current_state.events.should have_key(:publish)
      subject.current_state.events.should have_key(:unapprove)
      subject.current_state.events.keys.should == [:publish,:unapprove]
    end
  end

  context "when published" do
    it "should be published" do
      subject.submit!
      subject.approve!
      subject.publish!
      subject.current_state.to_s.should == "published"
    end
    it "available events should be retire and revise" do
      subject.submit!
      subject.approve!
      subject.publish!
      subject.current_state.events.should have_key(:retire)
      subject.current_state.events.should have_key(:revise)
      subject.current_state.events.keys.should == [:revise, :retire]
    end
  end
  
  context "when revised" do
    it "should be submitted again before approval" do
      subject.submit!
      subject.approve!
      subject.publish!
      subject.revise!
      subject.submit!
      subject.approved?.should == false
      subject.current_state.to_s.should == "unapproved"
    end
    it "should not be immediately publishable" do
      subject.submit!
      subject.approve!
      subject.publish!
      subject.revise!
      expect { subject.publish! }.to raise_error      
    end
  end

  context "when rejected" do
    it "should be rejected" do
      subject.submit!
      subject.reject!
      subject.current_state.to_s.should == "rejected"
    end
    it "should not have any available events" do
      subject.submit!
      subject.reject!
      subject.current_state.events.should be_empty
    end
  end

  context "when retired" do
    it "should be retired" do
      subject.submit!
      subject.approve!
      subject.publish!
      subject.retire!
      subject.current_state.to_s.should == "retired"
    end
    it "should not have any available events" do
      subject.submit!
      subject.approve!
      subject.publish!
      subject.retire!
      subject.current_state.events.should be_empty
    end
  end  
end
