require 'time'
require 'rubygems'

class Logging

def initialize(fileName)
    @filename = fileName << ".txt"
end

def log(param)
   fileExists = File.exist?(@filename)
   puts "Datei existiert: #{fileExists}"
   if fileExists ? fileswitch = 'a' : fileswitch = 'w'
  	 open(@filename, fileswitch){ |i|
  		 
  		i << "#{Time.now.getutc}; #{param}\n" 
  	  }
   end 	
end


end