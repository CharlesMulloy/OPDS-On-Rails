class FileObject
	attr_accessor :title, :author, :description, :file_path, :image_location

	def initialize
		@title, @author, @description, @file_path, @image_location = ''
	end

end