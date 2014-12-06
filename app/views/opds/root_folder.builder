xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.feed("xmlns"=>"http://www.w3.org/2005/Atom"){
	xml.id("urn:uuid:2853dacf-ed79-42f5-8e8a-a7bb3d1ae6a2")
	xml.link("rel" => "self", "href" => "/", "type" => "application/atom+xml;profile=opds-catalog;kind=navigation")

	xml.link("rel" => "start", "href" => "/", "type" => "application/atom+xml;profile=opds-catalog;kind=navigation")

	xml.title("OPDS Catalog")
	xml.author{
		xml.name "Charles Mulloy"
		xml.uri "http://opds-spec.org"
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