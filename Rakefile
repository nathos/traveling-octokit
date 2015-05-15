# For Bundler.with_clean_env
require 'bundler/setup'

PACKAGE_NAME = "gh-org-users"
VERSION = "0.9.0"
TRAVELING_RUBY_VERSION = "20150210-2.1.5"

desc "Package your app"
task :package => ['package:linux:x86', 'package:linux:x86_64', 'package:osx']

namespace :package do
  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install, "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz"] do
      create_package("linux-x86")
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install, "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz"] do
      create_package("linux-x86_64")
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install, "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz"] do
    create_package("osx")
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.1\./
      abort "You can only 'bundle install' using Ruby 2.1, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp Gemfile Gemfile.lock packaging/tmp/"
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -rf packaging/tmp"
    sh "rm -f packaging/vendor/*/*/cache/*"
    # Remove tests
    sh "rm -rf packaging/vendor/ruby/*/gems/*/test"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/tests"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/spec"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/features"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/benchmark"
    # Remove documentation
    sh "rm -f packaging/vendor/ruby/*/gems/*/readme*"
    sh "rm -f packaging/vendor/ruby/*/gems/*/CHANGE*"
    sh "rm -f packaging/vendor/ruby/*/gems/*/Change*"
    sh "rm -f packaging/vendor/ruby/*/gems/*/COPYING*"
    sh "rm -f packaging/vendor/ruby/*/gems/*/LICENSE*"
    sh "rm -f packaging/vendor/ruby/*/gems/*/MIT-LICENSE*"
    sh "rm -f packaging/vendor/ruby/*/gems/*/TODO"
    sh "rm -f packaging/vendor/ruby/*/gems/*/*.txt"
    sh "rm -f packaging/vendor/ruby/*/gems/*/*.md"
    sh "rm -f packaging/vendor/ruby/*/gems/*/*.rdoc"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/doc"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/docs"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/example"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/examples"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/sample"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/doc-api"
    sh "find packaging/vendor/ruby -name '*.md' | xargs rm -f"
    # Remove misc unnecessary files
    sh "rm -rf packaging/vendor/ruby/*/gems/*/.gitignore"
    sh "rm -rf packaging/vendor/ruby/*/gems/*/.travis.yml"
    # Remove RDoc
    sh "rm -rf packaging/ruby/lib/ruby/*/rdoc*"
  end
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime("linux-x86")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime("osx")
end

def create_package(target)
  package_dir = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  sh "rm -rf #{package_dir}"
  sh "mkdir #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "cp #{PACKAGE_NAME}.rb #{package_dir}/lib/app/"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  sh "cp packaging/wrapper.sh #{package_dir}/#{PACKAGE_NAME}"
  sh "cp -pR packaging/vendor #{package_dir}/lib/"
  sh "cp Gemfile Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"
  if !ENV['DIR_ONLY']
    sh "tar -czf #{package_dir}.tar.gz #{package_dir}"
    sh "rm -rf #{package_dir}"
  end
end

def download_runtime(target)
  sh "cd packaging && curl -L -O --fail " +
    "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end
