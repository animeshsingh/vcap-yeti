source "http://rubygems.org"

gem "rake"
gem "rspec"
gem "parallel_tests"

gem "rest-client"
gem "mongo"

gem "bson_ext"
gem "yajl-ruby"
gem "nokogiri"
gem "blue-shell", :github => "shageman/blue-shell"

gem "ci_reporter"

group :vcap do
  gem "vcap_logging", ">= 1.0"

  gem "cfoundry", {
    :github => "cloudfoundry/cfoundry",
    :submodules => true,
  }

  gem "cf", :github => "cloudfoundry/cf"
end
