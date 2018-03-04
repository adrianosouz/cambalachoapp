class Site::SearchController < SiteController
 
  def ads 
    @ad = Ad.search(params[:q], params[:page])
    @categories = Category.all
  end
end