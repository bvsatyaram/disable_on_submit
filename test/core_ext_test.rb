require File.dirname(__FILE__) + '/test_helper.rb'
require 'action_view/test_case'

class CoreExtTest < Test::Unit::TestCase
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionViewExtensions
  include PrototypeHelperExtensions
  include UrlHelperExtensions

  alias_method_chain :submit_tag, :disable
  alias_method_chain :method_javascript_function, :disable


  def setup
    self.stubs(:protect_against_forgery?).returns(false)
  end

  def test_submit_tag
    tag = submit_tag "Update"
    assert_no_match /DisableOnSubmit.markElementForDisable/, tag

    tag = submit_tag "Update", :class => 'button'
    assert_match /DisableOnSubmit.markElementForDisable\(this, 'Processing...', false\);/, tag

    tag = submit_tag "Update", :class => 'button', :mark_for_disable => false
    assert_no_match /DisableOnSubmit.markElementForDisable/, tag

    tag = submit_tag "Update", :class => 'button', :disable_with => 'Please wait...'
    assert_match /DisableOnSubmit.markElementForDisable\(this, 'Please wait...', false\);/, tag

    tag = submit_tag "Update", :class => 'button', :deactivate_button => false
    assert_match /DisableOnSubmit.markElementForDisable\(this, 'Processing...', false\);/, tag

    tag = submit_tag "Update", :class => 'button', :deactivate_button => true
    assert_match /DisableOnSubmit.markElementForDisable\(this, 'Processing...', true\);/, tag

    tag = submit_tag "Update", :class => 'button', :onclick => "someFunction('chumma')"
    assert_match /DisableOnSubmit.markElementForDisable\(this, 'Processing...', false\); someFunction\('chumma'\)/, tag

    tag = submit_tag_without_disable "Update", :class => 'button'
    assert_no_match /DisableOnSubmit.markElementForDisable/, tag

    tag = submit_tag_with_disable "Update", :class => 'button'
    assert_match /DisableOnSubmit.markElementForDisable\(this, 'Processing...', false\);/, tag

    tag = submit_tag_with_disable "Update"
    assert_no_match /DisableOnSubmit.markElementForDisable/, tag
  end

  def test_remote_function
    tag = remote_function :method => :get, :url => '/birds'
    assert_match /method:'get'/, tag
    assert_match /new Ajax\.Request\('\/birds'/, tag
    assert_match /^DisableOnSubmit\.disableElement/, tag
    assert_match /onComplete:function\(request\)\{DisableOnSubmit\.reEnableElement/, tag

    tag = remote_function :method => :get, :url => '/birds', :before => "beforeFunction()", :after => "afterFunction()"
    assert_match /method:'get'/, tag
    assert_match /new Ajax\.Request\('\/birds'/, tag
    assert_match /^beforeFunction\(\); DisableOnSubmit\.disableElement\(\);/, tag
    assert_match /onComplete:function\(request\)\{DisableOnSubmit\.reEnableElement/, tag
  end

  def test_method_javascript_function
    tag = method_javascript_function :get, '/birds'
    assert_no_match /DisableOnSubmit\.disableLink/, tag
    assert_match /var\sf/, tag

    tag = method_javascript_function :post, '/birds'
    assert_match /DisableOnSubmit\.disableLink\(this\);\s$/, tag
    assert_match /var\sf/, tag

    tag = method_javascript_function :put, '/birds'
    assert_match /DisableOnSubmit\.disableLink\(this\);\s$/, tag
    assert_match /var\sf/, tag

    tag = method_javascript_function :delete, '/birds'
    assert_match /DisableOnSubmit\.disableLink\(this\);\s$/, tag
    assert_match /var\sf/, tag

    tag = method_javascript_function_with_disable :post, '/birds'
    assert_match /DisableOnSubmit\.disableLink\(this\);\s$/, tag
    assert_match /var\sf/, tag

    tag = method_javascript_function_with_disable :get, '/birds'
    assert_no_match /DisableOnSubmit\.disableLink\(this\);\s$/, tag
    assert_match /var\sf/, tag

    tag = method_javascript_function_without_disable :post, '/birds'
    assert_no_match /DisableOnSubmit\.disableLink\(this\);\s$/, tag
    assert_match /var\sf/, tag

    tag = method_javascript_function_without_disable :get, '/birds'
    assert_no_match /DisableOnSubmit\.disableLink\(this\);\s$/, tag
    assert_match /var\sf/, tag
  end

  def test_link_to_override
    tag = link_to "Submit", '/birds', :method => :post
    assert_match /var\sf/, tag
    assert_match /DisableOnSubmit.disableLink\(this\);/, tag
  end

  def test_submit_to_remote_override
    tag = submit_to_remote 'create_btn', 'Create', :url => '/birds'
    assert_match /input\sname="create_btn"/, tag
    assert_match /onclick="DisableOnSubmit\.disableElement\(\);/, tag
    assert_match /DisableOnSubmit\.reEnableElement\(\);/, tag
  end
end