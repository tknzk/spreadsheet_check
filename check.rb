require 'rubygems'
require 'google/api_client'
require 'google_drive'
require 'uri'
require 'colorize'

target_url = ARGV[0]

refresh_token   = ENV['REFRESH_TOKEN']
client_id       = ENV['CLIENT_ID']
client_secret   = ENV['CLIENT_SECRET']

sheet_key   = ENV['SHEET_KEY']


client              = Google::APIClient.new(
  :application_name => 'google api',
  :application_version => '0.0.1'
)
auth                = client.authorization
auth.client_id      = client_id
auth.client_secret  = client_secret
auth.refresh_token  = refresh_token
auth.fetch_access_token!

# Creates a session.
session = GoogleDrive.login_with_oauth(client)

sheets = session.spreadsheet_by_key(sheet_key).worksheets

sheet = nil
sheets.each do |ws|
  if ws.title == 'target sheet title'
    sheet = ws
  end
end

lists = Array.new
if sheet != nil
  for row in 2..sheet.num_rows

    listed_url = posting_sheet[row, 1]

    if listed_url != ''
      lists.push listed_url
    end

  end
end

hosts = Array.new
lists.each do |url|
  uri = URI(url)
  hosts.push.push uri.host
end

puts ("check url : " + target_url).blue.on_white

lists.each do |url|
  if url == target_url
    puts ('aleady listed : ' + target_url).red
  end
end

hosts.each do |host|
  uri = URI(target_url)
  if host == uri.host
    puts ('aleady host : ' + uri.host).yellow
  end
end
