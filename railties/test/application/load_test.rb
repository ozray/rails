require "isolation/abstract_unit"
# require "rails"
# require 'action_dispatch'

module ApplicationTests
  class LoadTest < Test::Unit::TestCase
    include ActiveSupport::Testing::Isolation

    def rackup
      require "rack"
      Rack::Builder.parse_file("#{app_path}/config.ru")
    end

    def setup
      build_app
      boot_rails
    end

    test "rails app is present" do
      assert File.exist?(app_path("config"))
    end

    test "config.ru can be racked up" do
      @app = rackup
      assert_welcome get("/")
    end

    test "Rails.application is available after config.ru has been racked up" do
      rackup
      assert Rails.application.is_a?(Rails::Application)
    end

    # Passenger still uses AC::Dispatcher, so we need to
    # keep it working for now
    test "deprecated ActionController::Dispatcher still works" do
      rackup
      assert ActionController::Dispatcher.new.is_a?(Rails::Application)
    end

    test "the config object is available on the application object" do
      rackup
      assert_equal 'UTC', Rails.application.config.time_zone
    end
  end
end
