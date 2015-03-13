require 'rubygems'
require "google_drive"

client_id       = ENV['CLIENT_ID']
client_secret   = ENV['CLIENT_SECRET']

client = Google::APIClient.new(
  :application_name => 'google api',
  :application_version => '0.0.1'
)
auth = client.authorization
auth.client_id = client_id
auth.client_secret = client_secret
auth.scope =
    "https://www.googleapis.com/auth/drive " +
    "https://spreadsheets.google.com/feeds/"
auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
print("2. Enter the authorization code shown in the page: ")
auth.code = $stdin.gets.chomp
auth.fetch_access_token!
access_token = auth.access_token
refresh_token = auth.refresh_token

session = GoogleDrive.login_with_oauth(access_token)

puts "your access_token is:\n#{access_token}"
puts "----"

puts "your refresh_token is:\n#{refresh_token}"
puts "----"

session.files.each do |file|
  puts file.title
end
puts "----"

puts "done!"
