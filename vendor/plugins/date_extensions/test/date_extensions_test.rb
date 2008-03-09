require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/date_extensions"
require 'date'

class DateExtensionsTest < Test::Unit::TestCase
  def setup
    @d = Date.today #can't freeze date or datetime - they break :(
    @dt = DateTime.now
    @t = Time.now.freeze
  end
  # Test week constructors.
  def test_week_initialize
    assert Week.new(@t)
    assert Week.new(@d)
    assert Week.new(@dt)
    assert_equal Week.new(@t), Week.new(@d)
    assert_equal Week.new(@dt), Week.new(@d)
    assert_equal Week.new(@d).days.length, 7
    assert_raise(ArgumentError) {Week.new("this is unacceptable")}
    assert_equal Week.new(@d), Week.new
  end
  #Test week comparisons.
  def test_week_comparisons
    assert Week.new(@d) > Week.new(@d - 7)
    assert Week.new.between?(Week.last, Week.next)
    assert case @d; when Week.new: true; else false; end #these test ===
    assert case @dt; when Week.new: true; else false; end
    assert case @t; when Week.new: true; else false; end
  end
  #Test math operations.
  def test_week_math
    assert_equal (Week.new(@d) + 7), Week.new(@d + 7)
    assert_equal (Week.new(@d) - 7), Week.new(@d - 7)
    assert_equal Week.new(@d).next, Week.new(@d + 7)
  end
  #Test forwarded methods
  def test_forwarded_methods
    assert_raise(TypeError) {Week.new(@d)[0]=5}
  end
end
