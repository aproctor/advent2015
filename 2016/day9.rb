#!/usr/bin/env ruby
# Day 1 2016
# See http://adventofcode.com/2016/day/8

puts "Advent of Code 2016 day 9"


#Part 1 - decompress
path = "day9.out"
File.delete(path) if(File.exist?(path))
f = File.new("day9.out", "w")

File.open('day9.data').each do |line|
  next if(line.nil?)

  in_instruction = false
  instruction = ""

  in_repeat_section = false
  repeat_chars = 0
  repeat_times = 0
  repeat_section = ""  

  #f.write(line)

  line.each_char do |c|
    #skip whitespace
    next if(/\s/.match(c))

    if(in_instruction == true)
      if(c == ")")
        #instruction ended, parse command
        md = /(\d+)x(\d+)/.match(instruction)
        repeat_chars = md[1].to_i
        repeat_times = md[2].to_i
        in_instruction = false

        repeat_section = ""
        in_repeat_section = true
        next
      else
        #add to instruction string
        instruction = instruction + c
      end    
    elsif(in_repeat_section == true)
      #scanning for characters to repeat until ready
      repeat_section = repeat_section + c

      if(repeat_section.length >= repeat_chars)
        repeat_times.times do 
          f.write(repeat_section)
        end
        in_repeat_section = false        
      end
    elsif(c == "(")
      #instruction started
      in_instruction = true
      instruction = ""
      next    
    else
      #nothing special, just write the byte
      f.write(c)
      
    end
  end

  #f.write("\n")  
 
end

f.close
puts "Part 1 Size: #{File.size(path)}"


#part 2 - I was going to decompress the file, but apparently it's like 11 GB
fsize = 0

def size_of_chunk(line)
  in_instruction = false
  instruction = ""

  in_repeat_section = false
  repeat_chars = 0
  repeat_times = 0
  repeat_section = ""

  size = 0
  line.each_char do |c|
    #skip whitespace
    next if(/\s/.match(c))

    if(in_instruction == true)
      if(c == ")")
        #instruction ended, parse command
        md = /(\d+)x(\d+)/.match(instruction)
        repeat_chars = md[1].to_i
        repeat_times = md[2].to_i
        in_instruction = false

        repeat_section = ""
        in_repeat_section = true
        next
      else
        #add to instruction string
        instruction = instruction + c
      end    
    elsif(in_repeat_section == true)
      #scanning for characters to repeat until ready
      repeat_section = repeat_section + c

      if(repeat_section.length >= repeat_chars)
        size += size_of_chunk(repeat_section) * repeat_times
        in_repeat_section = false        
      end
    elsif(c == "(")
      #instruction started
      in_instruction = true
      instruction = ""
      next    
    else
      #nothing special, just write the byte
      size += 1
      
    end
  end

  return size
end

File.open('day9.data').each do |line|
  next if(line.nil?)

  fsize += size_of_chunk(line)
end

puts "part 2 - File Size: #{fsize}"