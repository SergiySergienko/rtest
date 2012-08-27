
class MainController < ApplicationController

  def asd
    require 'game_core.rb'
    require 'game_flow.rb'
    a = GameFlow.new
    puts "!"*50
    puts a.inspect
    a.make_action(params)
  end

end
