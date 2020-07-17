require "http"
require 'json'
require 'open-uri'
class Subreddit < ApplicationRecord
  has_one_attached :sub_img
  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations
  has_many :images, dependent: :destroy
  validates :name, presence: true
  validates :name, :uniqueness => { :case_sensitive => false }
  validate :is_existing_subreddit

  def query_for_images
    query = "https://www.reddit.com/r/#{name}.json?limit=50"
    resp = HTTP.get(query)
    json = JSON.parse(resp)
    cardsAdded = 0
    i = 0
    while cardsAdded < 10 && i < 50 do
      base = json["data"]["children"][i]["data"]
      img_name = base["title"]
      img_picture = base["url"]
      image = self.images.build
      image.caption = img_name
      image.upvotes = 0
      if img_picture.chars.last(3).join == "jpg"
        puts "jpg"
        image.picture_img.attach(io: open(img_picture), filename: "#{img_name}.jpg", content_type: "image/jpg")
      elsif img_picture.chars.last(3).join == "png"
        puts "png"
        image.picture_img.attach(io: open(img_picture), filename: "#{img_name}.png", content_type: "image/png")
      elsif img_picture.chars.last(3).join == "mp4"
        puts "mp4"
        videoBase = "#{img_picture.delete_suffix!('mp4')}"
        image.picture_img.attach(io: open("#{videoBase}mp4"), filename: "#{img_name}.mp4", content_type: "video/mp4")
        image.thumbnail_img.attach(io: open("#{videoBase}jpg"), filename: "#{img_name}.jpg", content_type: "image/jpg")
      elsif img_picture.chars.last(4).join == "gifv"
        puts "gifv"
        videoBase = "#{img_picture.delete_suffix!('gifv')}"
        img_picture = "#{videoBase}mp4"
        image.picture_img.attach(io: open(img_picture), filename: "#{img_name}.mp4", content_type: "video/mp4")
        image.thumbnail_img.attach(io: open("#{videoBase}jpg"), filename: "#{img_name}.jpg", content_type: "image/jpg")
      elsif img_picture.chars.last(3).join == "gif"
        puts "gif"
        image.picture_img.attach(io: open(img_picture), filename: "#{img_name}.gif", content_type: "image/gif")
      end

      if image.picture_img.attached?
        image.save
        cardsAdded = cardsAdded + 1
      else
        image.destroy
      end

      i = i + 1
    end
  end

  def get_sub_image_count
    count = 0
    Image.all.each do |image|
      count = count + image.upvotes if image.subreddit == self
    end
    count
  end


  def adjust_description
    query = "https://www.reddit.com/r/#{name}/about.json"
    resp = HTTP.get(query)
    json = JSON.parse(resp)
    icon = json["data"]["icon_img"]
    descrip = json["data"]["public_description"]
    self.description = descrip
    if icon != ""
      self.sub_img.attach(io: open(icon), filename: "#{name}.png", content_type: "image/png") 
    else
      self.sub_img.attach(io: open("app/assets/images/RedditLogo.png"), filename: "RedditLogo.png", content_type: "image/png")
    end
    self.save
  end


  private
  def is_existing_subreddit
    link = "https://www.reddit.com/r/#{name}.json"
    url = URI.parse("#{link}")
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = true
    res = req.request_head(url.path, {'User-Agent' => 'your_agent'})

    if res.code == "429"
      errors.add(:name, :invalid, message: ": Too many requests. Please wait.")
    elsif res.code == "302" || res.code == "500" || res.code == "404"
      errors.add(:name, :invalid, message: ": Must be a valid subreddit name")
    else
      resp = HTTP.get(link)
      json = JSON.parse(resp)
      errors.add(:name, :invalid, message: ": Must be a valid subreddit name") if !json.has_key?("data") || json["data"]["children"].length == 0
    end
  end
end
