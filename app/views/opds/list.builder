xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.feed("xmlns"=>"http://www.w3t.org/2005/Atom", "xmlns:dc"=>"http://www.w3.org/2005/Atom", "xmlns:opds" => "http://opds-spec.org/2010/catalog"){


	#Entry that forces a refresh of the current directory.
	xml.entry{
		xml.title '.'
		xml.link("rel" => "subsection", "href" => "/#{params['path']}/list", "type" => "application/atom+xml;profile=opds-catalog;kind=acquisition")
	}

	#Entry that goes up one directory

	xml.entry{
		xml.title '..'
		xml.link("rel" => "subsection", "href" => "#{@folder}/list", "type" => "application/atom+xml;profile=opds-catalog;kind=acquisition")
	}	


	for i in @folders
		xml.entry{
			xml.title i
			xml.link("rel" => "subsection", "href" => i + "list", "type" => "application/atom+xml;profile=opds-catalog;kind=acquisition")
		}
	end
	
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