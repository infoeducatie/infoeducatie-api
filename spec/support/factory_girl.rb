RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      Rails.application.load_seed
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
