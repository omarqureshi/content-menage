require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  should validate_presence_of :title
end
