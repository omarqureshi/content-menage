content_fields = lambda { |x|
  x.title "test title"
  x.publish_date Date.today
  x.published true
  x.priority 1
}
article_fields = lambda { |x| 
  x.body "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}

Factory.define :content do |c|
  content_fields.call(c)
end

Factory.define :article do |a|
  content_fields.call(a)
  article_fields.call(a)
end