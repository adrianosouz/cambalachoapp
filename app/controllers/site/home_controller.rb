class Site::HomeController < SiteController
	
  def index
  	@categories = Category.order_by_description
  	@ad = Ad.descending_order(6, params[:page])
  	@carousel = Ad.random(3)

  end
end
