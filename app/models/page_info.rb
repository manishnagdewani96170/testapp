class PageInfo < ActiveRecord::Base

  validates :url, :format => URI::regexp(%w(http https))
end
