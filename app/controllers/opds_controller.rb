class OpdsController < ApplicationController

	#http_basic_authenticate_with name: "admin_main", password: "WhiteFeathers"

  def root_folder

  	require 'zip/zip'
  	require 'nokogiri'
  	require_relative 'FileObject.rb'


	@folders = []

  	for i in Dir["files/*/"]
  		@folders.push i.gsub("files/","")
  	end

  	@books = []

	for i in Dir["files/*.epub*"]  	
		Zip::ZipFile.open(i){
			|zipfile|
			root_path = Nokogiri::XML(zipfile.read("META-INF/container.xml")).css('rootfile')[0]['full-path']
			
			root_dir = File.dirname(root_path) + "/"
			if root_dir == "./"
				root_dir = ""
			end

			noko = zipfile.read(root_path)

			@title = Nokogiri::XML(noko).xpath('//dc:title', 'dc' => "http://purl.org/dc/elements/1.1/").text
			@author = Nokogiri::XML(noko).xpath('//dc:creator', 'dc' => "http://purl.org/dc/elements/1.1/").text
			@description = Nokogiri::XML(noko).xpath('//dc:description', 'dc' => "http://purl.org/dc/elements/1.1/").text

			if Nokogiri::XML(noko).css("meta[name='cover']")[0] != nil
				# first = Nokogiri::XML(noko).css("meta[name='cover']")[0]["content"]
				# image = Nokogiri::XML(noko).css("item[id='#{first}']")[0]["href"]
				@image = true
			else
				@image = false
			end

			#image = Nokogiri::XML(noko).css("item[id='#{first}']")[0]["href"]
			#@image_title = "#{Book.count}#{File.extname(image)}"

			#File.open("public/images/#{@image_title}",'wb'){ |f| f.puts(zipfile.read(root_dir + image))}
		}

		location = "#{@books.count}/get"
		image_location = "#{@books.count}/image"

		book = FileObject.new
		book.title = @title
		book.author = @author
		book.description = @description
		book.file_path = location 
		if @image
			book.image_location = image_location
		else 
			book.image_location = nil
		end

		@books.push book
	end



  end

  def list
  	require 'zip/zip'
  	require 'nokogiri'
  	require_relative 'FileObject.rb'

	@folders = []

  	for i in Dir["files/#{params['path']}/*/"]
  		@folders.push i.gsub("files/#{params["path"]}/","")
  	end


  	@books = []

	for i in Dir["files/#{params['path']}/*.epub"]  	
		Zip::ZipFile.open(i){
			|zipfile|
			root_path = Nokogiri::XML(zipfile.read("META-INF/container.xml")).css('rootfile')[0]['full-path']
			
			root_dir = File.dirname(root_path) + "/"
			if root_dir == "./"
				root_dir = ""
			end

			noko = zipfile.read(root_path)

			@title = Nokogiri::XML(noko).xpath('//dc:title', 'dc' => "http://purl.org/dc/elements/1.1/").text
			@author = Nokogiri::XML(noko).xpath('//dc:creator', 'dc' => "http://purl.org/dc/elements/1.1/").text
			@description = Nokogiri::XML(noko).xpath('//dc:description', 'dc' => "http://purl.org/dc/elements/1.1/").text

			if Nokogiri::XML(noko).css("meta[name='cover']")[0] != nil
				# first = Nokogiri::XML(noko).css("meta[name='cover']")[0]["content"]
				# image = Nokogiri::XML(noko).css("item[id='#{first}']")[0]["href"]
				@image = true
			else
				@image = false
			end
			#image = Nokogiri::XML(noko).css("item[id='#{first}']")[0]["href"]

			#@image_title = "#{Book.count}#{File.extname(image)}"

			#File.open("public/images/#{@image_title}",'wb'){ |f| f.puts(zipfile.read(root_dir + image))}
		}

		location = "/#{params['path']}/#{@books.count}/get"
		image_location = "/#{params['path']}/#{@books.count}/image"

		book = FileObject.new
		book.title = @title
		book.author = @author
		book.description = @description
		book.file_path = location 
		if @image
			book.image_location = image_location
		else 
			book.i
		end
		@books.push book
	end

	#@folder = File.dirname("/"+params['path'])
	

  end

  def get_book

  	if params['path'] == nil

  		files = Dir["files/*.epub*"]

  		send_file files[params['index'].to_i]

  	else

  		puts params['path']

  		files = Dir["files/#{params['path']}/*.epub"]

  		send_file files[params['index'].to_i]

  	end

  end

  def get_image
  	require 'zip/zip'
  	require 'nokogiri'

   	if params['path'] == nil

   		files = Dir["files/*.epub"]

  		Zip::ZipFile.open("#{files[params['index'].to_i]}"){
			|zipfile|

			root_path = Nokogiri::XML(zipfile.read("META-INF/container.xml")).css('rootfile')[0]['full-path']
			
			root_dir = File.dirname(root_path) + "/"
			if root_dir == "./"
				root_dir = ""
			end
			puts root_dir

			noko = zipfile.read(root_path)

			first = Nokogiri::XML(noko).css("meta[name='cover']")[0]["content"]
			@image = Nokogiri::XML(noko).css("item[id='#{first}']")[0]["href"]
			
			render :text => zipfile.read("#{root_dir}#{@image}")
		}

  	else

  		files = Dir["files/#{params['path']}/*.epub"]

  		Zip::ZipFile.open("#{files[params['index'].to_i]}"){
  			|zipfile|
			root_path = Nokogiri::XML(zipfile.read("META-INF/container.xml")).css('rootfile')[0]['full-path']
			
			root_dir = File.dirname(root_path) + "/"
			if root_dir == "./"
				root_dir = ""
			end
			puts root_dir

			noko = zipfile.read(root_path)

			first = Nokogiri::XML(noko).css("meta[name='cover']")[0]["content"]
			@image = Nokogiri::XML(noko).css("item[id='#{first}']")[0]["href"]
			
			render :text => zipfile.read("#{root_dir}#{@image}")
		}

  	end

  end


    def get_root_path s
		Nokogiri::XML(s).css('rootfile')[0]['full-path']
	end
end