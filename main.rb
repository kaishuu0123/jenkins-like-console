require 'rubygems'
require 'sinatra/base'
require 'logger'
require 'erb'

class MainApp < Sinatra::Base
  enable :sessions

  get '/' do
    erb :index
  end

  post '/startCommand' do
    cmd = @params[:command]
    cmd2 = cmd + " 2>&1 > command.log"
    pid = spawn(cmd2)
    #session[:th] = Process.detach(pid)
    session[:start_time] = Time.now
    erb :index
  end

  post '/progressiveHtml' do
    start = @params[:start]

    f = File.open("command.log")
    f.seek(start.to_i)
    body = f.read()
    f.close()

    end_time = Time.now
    if (end_time - session[:start_time]) < 10
      response.headers['X-MORE-DATA'] = "true"
    else
      #session[:th].kill
      response.headers['X-MORE-DATA'] = "false"
      return status 403
    end

    body
  end
end
