require 'workflow'
#
# A technology is an invention, or any other asset held by the organization
# @api workflow
# @author Ivan Storck ivanoats@uw.edu
# @version 2.0a (dimitri)
#
class Technology
  include Workflow
  workflow do
    state :new do
      event :submit, :transitions_to => :unapproved
    end
    state :unapproved do
      event :approve, :transitions_to => :approved
      event :reject, :transitions_to => :rejected
    end
    state :approved do
      event :publish, :transitions_to => :published
      event :unapprove, :transitions_to => :unapproved
    end
    state :published do
      event :revise, :transitions_to => :revised
      event :retire,  :transitions_to => :retired
    end
    state :revised do
      event :submit, :transitions_to => :unapproved
    end
    state :retired
    state :rejected
  end
 
  def submit
    puts 'technology is submitted'
  end
  
  def approve
    puts 'technology is approved'
    # send an email or log to a file
  end

  def unapprove
    puts 'technology is unapproved'
  end
  
  def publish
    puts 'technology is published'
  end
  
  def revise
    puts 'technology is revised'
  end
  
  def retire
    puts 'technology is retired'
  end
  
  def reject
    puts 'technology is rejected'
  end
end
