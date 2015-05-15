#!/usr/bin/env ruby

require "octokit.rb"

Octokit.auto_paginate = true

if ARGV.length != 1
  $stderr.puts "Pass in the name of the organization for which you'd like a list of users."
  exit 1
end

if ENV["GITHUB_TOKEN"].nil?
  $stderr.puts "No GITHUB_TOKEN environment variable set."
  exit 1
end

TOKEN = ENV["GITHUB_TOKEN"]

client = Octokit::Client.new :access_token => TOKEN

ORG = ARGV[0].to_s

members = client.org_members ORG

require "csv"

CSV.open("#{ORG}-users.csv", "wb") do |csv|
  members.each do |m|
    csv << [m[:login], m[:id], m[:html_url]]
  end
end
