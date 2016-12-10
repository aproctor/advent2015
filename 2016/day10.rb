#!/usr/bin/env ruby
# Day 10 2016
# See http://adventofcode.com/2016/day/10

puts "Advent of Code 2016 day 10"


#Part 1 - 
class Factory
  attr_reader :bots

  def initialize()
    @bots = {}    
    @outputs = []
  end

  def find_bot(bot_num)
    @bots[bot_num] = Bot.new(self, bot_num) if(!@bots.key?(bot_num))

    return @bots[bot_num]
  end

  def take_output(index, val)
    @outputs[index] = val
  end
end

class Bot  
  MAX_CHIPS = 2

  def initialize(parent, num)
    @chips = []
    @instruction = nil
    @factory = parent
    @number = num
  end

  def instruction=(val)
    @instruction = val
    try_instruction()
  end

  def try_instruction()
    if(!@instruction.nil? && @chips.length == MAX_CHIPS)      

      if(@chips[0] == 17 and @chips[1] == 61)
        puts "Part 1 Bot comp: #{@number}" 
      else
        #puts "#{@instruction} - #{@chips}"
      end

      #low chip
      if(@instruction[0] == :output)
        @factory.take_output(@instruction[1], @chips[0])
      elsif(@instruction[0] == :bot)
        @factory.find_bot(@instruction[1]).take_chip(@chips[0])
      end

      #high chip
      if(@instruction[3] == :output)
        @factory.take_output(@instruction[4], @chips[1])
      elsif(@instruction[3] == :bot)
        @factory.find_bot(@instruction[4]).take_chip(@chips[1])
      end

      @chips = []
      @instruction = nil

    end
  end

  def take_chip(chip)
    @chips << chip
    @chips = @chips.sort

    #puts "Bot-#{@number} took #{chip}"

    try_instruction()    
  end
end

factory = Factory.new
answer = 0
File.open('day10.data').each do |line|
  continue if(line.nil?)

  #puts "#{line}"

  assignment = /value (\d+) goes to bot (\d+)/.match(line)
  if(!assignment.nil?)    
    bot_num = assignment[2].to_i    
    bot = factory.find_bot(bot_num)    
    bot.take_chip(assignment[1].to_i)
  end

  delivery = /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/.match(line)
  if(!delivery.nil?)    
    source_bot = factory.find_bot(delivery[1].to_i)
    source_bot.instruction = [delivery[2].to_sym,delivery[3].to_i,delivery[4].to_sym,delivery[5].to_i]
  end

  puts "ERROR - #{line}" if(delivery.nil? && assignment.nil?)
  

end

puts "part 1 - #{answer}"

