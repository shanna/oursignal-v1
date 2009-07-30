require File.join(File.dirname(__FILE__), 'helper')

class UserTest < ModelTest
  context User do
    context '.username' do
      should 'be required'
      should 'be formatted'
      should 'be unique'
    end
  end
end

