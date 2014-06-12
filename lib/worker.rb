require 'crawl'
class Worker
  @queue = :default
  def initialize
  end

  def self.perform(name)
    crawler = Crawler.new
    crawler.crawl
  end
end

