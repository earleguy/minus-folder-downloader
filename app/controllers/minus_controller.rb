require 'zip/zip'
require 'yaml'

class MinusController < ActionController::Base
  protect_from_forgery

  def index
  end

  def new
    url = params[:folderurl]
    is_valid = /.minus.*\/m/i.match(url)
    if is_valid.class == MatchData
      puts "WE HAVE A MATCH!!"
    end
    puts "PARAMS: #{url}"
    #`wget http://zamn.net/joe/replays/Purple_Red_Explosion.jpg -P /home/zamn/temp`
  end

end
