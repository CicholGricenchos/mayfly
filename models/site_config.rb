class SiteConfig < ActiveRecord::Base
  def self.fetch
    $SITE_CONFIG = {}
    SiteConfig.all.each do |s|
      $SITE_CONFIG[s.name.to_sym] = s.value
    end
  end
end
