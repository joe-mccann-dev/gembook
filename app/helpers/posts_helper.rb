module PostsHelper
  def abbreviated(post)
    post.content.split[0..20].join(' ')
  end
end
