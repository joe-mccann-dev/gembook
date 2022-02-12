module PostsHelper

  def placeholders
    [
      "All that is gold does not glitter. Not all those who wander are lost. - J.R.R. Tolkien",
      "It's hard to be a bright light in a dim world. - Gary Starta",
      "To shine your brightest light is to be who you truly are. - Roy T. Bennett",
      "Shine on you crazy diamond. - Pink Floyd",
      "We've all got both light and dark inside us. What matters is the part we choose to act on. - Harry Potter and the Prisoner of Azkaban"
    ]
  end

  def abbreviated(post)
    @post.content.split[0..20].join(' ')
  end
end
