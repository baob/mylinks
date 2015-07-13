RSpec.describe 'middleman build', type: :aruba do

  specify 'runs without error' do
    run_simple('middleman build', true, 6) # 6 second timeout
  end

end
