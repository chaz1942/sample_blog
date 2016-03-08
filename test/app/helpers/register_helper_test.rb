require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class SampleBlog::App::RegisterHelperTest < Test::Unit::TestCase
  context "SampleBlog::App::RegisterHelper" do
    setup do
      @helpers = Class.new
      @helpers.extend SampleBlog::App::RegisterHelper
    end

    should "return nil" do
      assert_equal nil, @helpers.foo
    end
  end
end
