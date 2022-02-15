module PostsHelper

  def placeholders
    [
      "What's new?",
      "To shine your brightest light is to be who you truly are. - Roy T. Bennett",
      "Shine on you crazy diamond. - Pink Floyd",
    ]
  end

  def abbreviated(post)
    post.content.split[0..20].join(' ')
  end
end
