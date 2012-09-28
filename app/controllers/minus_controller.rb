require 'zip/zip'
require 'uri'
require 'json'
require 'yaml'
require 'httparty'

class MinusController < ActionController::Base
  protect_from_forgery

  def index
  end

  def new
    @link = ""
    url = params[:folderurl]
    is_valid = /.minus.*\/m/i.match(url)
    @count = 0
    if is_valid.class == MatchData
      user_url = URI(url)

      config = YAML::load_file("#{Dir.pwd}/config/minus_api.yml")
      api_key = config["Key"]
      secret = config["Secret"]
      username = config["Username"]
      password = config["Password"]
      access_json = HTTParty.get("http://minus.com/oauth/token?grant_type=password&client_id=#{api_key}&client_secret=#{secret}&scope=read_public+read_all&username=#{username}&password=#{password}")
      access = ActiveSupport::JSON.decode(access_json.body)
      btoken = access["access_token"]

      temp = URI(user_url).path.split("/")[1]
      album_id = temp[1...temp.length]

      api_url = "http://minus.com/api/v2/folders/#{album_id}/files"
      folder_list_json = HTTParty.get(api_url + "?bearer_token=#{btoken}")
      folder_list = ActiveSupport::JSON.decode(folder_list_json.body)

      results = folder_list["results"]

      @total = results.length

      `mkdir /tmp/#{album_id}`
      for i in 0...results.length
        file_ext = File.extname(results[i]["name"])
        file_id = results[i]["id"]
        `wget http://minus.com/#{"i" + file_id + file_ext} -P /tmp/#{album_id}`
        @count = @count + 1
      end

      Zip::ZipFile.open("/tmp/#{album_id}.zip", Zip::ZipFile::CREATE) do |zipfile|
        Dir.entries("/tmp/#{album_id}").each do |filename|
          zipfile.add(filename, "/tmp/#{album_id}/#{filename}")
        end
      end

      `mv /tmp/#{album_id}.zip #{Dir.pwd}/public/zips && chmod 777 #{Dir.pwd}/public/zips/#{album_id}.zip`
      `rm -Rf /tmp/#{album_id}`

      @link = "http://rails.zamn.net/zips/#{album_id}.zip"

    end
  end

end
