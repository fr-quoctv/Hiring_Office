# Installing factory_girl:

# 0. Check spec/support dir is auto-required in spec/rails_helper.rb.
#
# 1. Add factory_girl_rails to Gemfile:
#
# group :development, :test do
#  gem 'factory_girl_rails', '~> 4.5'
# end

# 2. Create a file like this one you're reading in spec/support/factory_girl.rb:
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      # Test factories in spec/factories are working.
      # FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

end
# 3. Start making use of Factory Girl. See factories in the spec/factories/ directory
#    and how they're used in the specs (search for "create(:").

# Suggested docs
# --------------
# http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
# https://github.com/thoughtbot/factory_girl/wiki/Example-factories.rb-file
