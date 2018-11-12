RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      Rails.application.load_seed
      FactoryBot.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
