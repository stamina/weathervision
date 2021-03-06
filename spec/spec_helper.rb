path = File.expand_path(File.dirname(__FILE__) + "/../lib/")
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
Bundler.require(:default, :development, :test)
# requires supporting files with custom matchers and macros, etc, in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
RSpec.configure do |config|
  #suppress all output to only show relevant test data
  config.before(:all) do
    $stdout = StringIO.new
  end
end
