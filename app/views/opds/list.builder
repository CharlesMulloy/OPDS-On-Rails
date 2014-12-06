xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.feed("xmlns"=>"http://www.w3t.org/2005/Atom", "xmlns:dc"=>"http://www.w3.org/2005/Atom", "xmlns:opds" => "http://opds-spec.org/2010/catalog"){

	#Lists the folders in the current directory
	for i in @folders
		xml.entry{
			xml.title i
			xml.link("rel" => "subsection", "href" => i + "list", "type" => "application/atom+xml;profile=opds-catalog;kind=acquisition")
		}
	end

	#List the files in the current directory.
	for i in @books 
		xml.entry{
			xml.title i.title
			xml.author{
				xml.name i.author
			}
			xml.content(i.description, "type" => "text")
			xml.link("rel" => "alternate", "href" => i.file_path, "type" => "application/epub+zip")
			if i.image_location != nil
				xml.link("rel" => "http://opds-spec.org/image/thumbnail","href" => i.image_location)
			end
		}
	end
}