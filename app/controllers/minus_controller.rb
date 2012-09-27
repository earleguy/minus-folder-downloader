require 'zip/zip'
require 'json'
require 'yaml'
require 'httparty'

class MinusController < ActionController::Base
  protect_from_forgery

  def index
  end

  def new
    url = params[:folderurl]
    is_valid = /.minus.*\/m/i.match(url)
    @count = 1
    if is_valid.class == MatchData
      config = YAML::load_file("/home/zamn/code/rails/minus-folder-downloader/config/minus_api.yml")
      api_key = config["Key"]
      secret = config["Secret"]
      username = config["Username"]
      password = config["Password"]
      access_json = HTTParty.get("http://minus.com/oauth/token?grant_type=password&client_id=#{api_key}&client_secret=#{secret}&scope=read_public+read_all&username=#{username}&password=#{password}")
      access = ActiveSupport::JSON.decode(access_json.body)
      btoken = access["access_token"]

      blah = "http://minus.com/api/v2/folders/0FQHJakL/files"
      folder_list_json = HTTParty.get(blah + "?bearer_token=#{btoken}")
      folder_list = ActiveSupport::JSON.decode(folder_list_json.body)

      results = folder_list["results"]

      for i in 0...results.length
        file_ext = File.extname(results[i]["name"])
        file_id = results[i]["id"]
        `wget http://minus.com/#{"i" + file_id + file_ext} -P /home/zamn/temp`
        @count = @count + 1
      end

      puts "WE HAVE A MATCH!!"
    end
  end

end
