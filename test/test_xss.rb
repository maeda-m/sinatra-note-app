# frozen_string_literal: true

require_relative '../note_helper'
require 'test/unit'

class TestXss < Test::Unit::TestCase
  include NoteHelper

  def test_escape_tag
    expect = '&lt;script type=&quot;text&#x2F;javascript&quot;&gt;alert(&quot;警告&quot;)&lt;&#x2F;script&gt;'
    actual = h('<script type="text/javascript">alert("警告")</script>')

    assert_equal expect, actual
  end
end
