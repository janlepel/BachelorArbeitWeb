require 'rubygems'
require 'sinatra'
require './building'
require './logging'

def initialize()
 @logger = Logging.new("TestLog")
end

def getCountChoices()
@countChoices = {
  '1' => '1',
  '2' => '2',
}
end

def getProgramChoices()
 @programChoices = {
  'Apache' => 'sudo apt-get Apache',
  'OpenCRM' => 'sudo apt-get OpenCRM',
  'MySQL' => 'sudo apt-get MySQL',
 }
end 

def getAllNotes()
  @notes = Note.all :order => :id.desc
end


get '/' do
	redirect '/config'
end

not_found do
  status 404
  'not found'
end



get '/add' do
 @programs = Programs.all :order => :id.desc
erb :add

end

get '/config' do
 
 @logger.log("Start")
 getCountChoices()
 getProgramChoices()
 erb :config
end

post '/config' do

@programVote = params['progVote']
@countVote  = params['countVote']

erb :publish  
end

post '/publish' do


  @programVote = params['progVote']
  @countVote  = params['countVote']
  
  filename = 'myfile.out'
  
  FileExists = File.exist?(filename)
 
  if FileExists ? fileswitch = 'a' : fileswitch = 'w'
  	 open(filename, fileswitch){ |i|
  		 
  		if ( !@programVote.nil? ) 
  		  	@programVote.each{|x| 
            i << "#{getProgramChoices()[x]}\n" }
  		end
        i << "#{@countVote}\n\n"
   	 }
  end 	
  puts "Deleted: #{deleteAllContent()}"
  addContentToDb(@countVote)
  

  erb :publish
end

post '/done' do 
erb :done
end



def addContentToDb(countVote)

  n = Note.new
  n.content = countVote
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
end

def deleteAllContent()
 Note.destroy
end


