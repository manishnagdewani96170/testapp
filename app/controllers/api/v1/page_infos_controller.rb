require 'open-uri'
module API
  module V1
    class PageInfosController < Grape::API
      include API::V1::Defaults

      helpers do
        def valid?(uri)
          !!URI.parse(uri)
        rescue URI::InvalidURIError
          false
        end
      end  

      resource :page_infos do
        
        desc "Fetch All previous URL'S"
        get do
          @page_infos = PageInfo.all
        end  

        desc "Set PageInfo with content"
        params do
          requires :url, type: String
        end
         
        post do
          if valid?(permitted_params[:url])
            begin
              #Open URL and scrape
              page = Nokogiri::HTML(open(permitted_params[:url]))
              #Parse content and store into variable
              text = ""
              headers = ["h1", "h2", "h3"]
              headers.each do |header|
                header = page.css(header)
                text = text + header.map{|h| h.text}.join(",") if header.present?
              end  
              
              links = page.css("a")
              text = text + links.map{|h| h.text}.join(",") if links.present? 

              #Store URL and content
              PageInfo.create(url: permitted_params[:url], content: text)
            rescue OpenURI::HTTPError => e
              if e.message == '404 Not Found'
                # handle 404 error
              else
                raise e
              end
            end   
          end
          
        end  

      end  

    end
  end
end      
