module V1
  class BlogPostsController < ApiController
    def index
      @blog_posts = BlogPost.published.newest_first
    end

    def show
      @blog_post = BlogPost.published.find_by(slug: params[:slug])
      head :not_found unless @blog_post
    end
  end
end
