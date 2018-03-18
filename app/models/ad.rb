class Ad < ActiveRecord::Base
  
  #Ratyrate gem
  ratyrate_rateable 'quality' 

  #Callbacks
  before_save :md_to_html

  # Associations
  belongs_to :member
  belongs_to :category, counter_cache: true
  has_many :comments

  # validades

  validates :title, :description_md, :description_md, :category, presence:true
  validates :picture, :finish_date, presence:true
  validates :price, numericality: { greater_than: 0}

  # Scope
  scope :descending_order, ->(quantity = 10 , page = 1) {
         limit(quantity).order(created_at: :desc).page(page).per(6) 
 }
 
  scope :search, ->(term, page = 1) {
         where("lower(title) LIKE ?", "%#{term.downcase}%").page(page).per(6)
}


  scope :to_the, ->(member){ where(member: member) }
  scope :by_category, -> (id, page) { where(category: id).page(page).per(6) }


  scope :random, ->(quantity){
    if Rails.env.production?
      limit(quantity).order("RAND()") # MySQL
    else
      limit(quantity).order("RANDOM()") #SQLFF
    end
}

  # paperclip
  has_attached_file :picture, styles: { large: "800x300",medium: "320x150#", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/



  # gem money-rails
  monetize :price_cents

def second
    self[1]
end

def third
    self[2]
end

  private 

  def md_to_html
    options = {
    filter_html: true,
    link_attributes: {
      rel: "nofollow",
      target: "_blank"
    }
}

  extensions = {
  space_after_headers: true,
  autolink: true
}

  renderer = Redcarpet::Render::HTML.new(options)
  markdown = Redcarpet::Markdown.new(renderer, extensions)

  self.description = markdown.render(self.description_md)
    
  end


end
