require File.join(File.dirname(__FILE__), 'helper')

class UserTest < ModelTest
  context User do
    setup do
      User.destroy_all
    end

    context '.username' do
      should 'be required'
      should 'be formatted'
      should 'be unique'
    end
  end
end

