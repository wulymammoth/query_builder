# encoding: utf-8

guard :rspec, cmd: "bundle exec rspec" do

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/query_builder/(.+)\.rb}) do |m|
    "spec/unit/#{m[1]}_spec.rb"
  end

  watch("lib/query_builder.rb")  { "spec/integration" }
  watch("spec/spec_helper.rb") { "spec" }

end # guard :rspec
