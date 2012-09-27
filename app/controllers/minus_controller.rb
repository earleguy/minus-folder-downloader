class MinusController < ActionController::Base
  protect_from_forgery

  def index
  end

  def new
    puts "PARAMS: #{params[:folderurl]}"
    `wget http://zamn.net/joe/replays/Purple_Red_Explosion.jpg -P /home/zamn/temp`
  end

end
