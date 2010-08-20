module UrlHelperExtensions
  # Override the default behaviour of the link_to with
  # :method attribute to disable on click
  # link_to function points to 'method_javascript_function' eventually to generate the
  # hidden fom for links with a :method
  def method_javascript_function_with_disable(method, url = '', href = nil)
    disable_code = "BetterProgressBar.disableLink(this); "
    code = method_javascript_function_without_disable(method, url, href)
    code += disable_code if method != :get
    return code
  end

end

ActionView::Base.send :include, UrlHelperExtensions
# method_javascript_function is a private method and hence using alias_method_chain
ActionView::Base.alias_method_chain :method_javascript_function, :disable

module PrototypeHelperExtensions
  # Over ride the default behaviour of the remote_function
  # to add :before and :after actions to disable and enable the submit button respectively
  # ajax methods like 'form_remote_for' points to remote_function to add the ajax script
  # required to carry out the ajax operations
  def remote_function(options)
    options[:before] = options[:before] ? options[:before] + "; " : ""
    options[:before] << "BetterProgressBar.disableElement();"
    options[:complete] = 'BetterProgressBar.reEnableElement(); ' +  (options[:complete] || '')
    super(options)
  end
end

ActionView::Base.send :include, PrototypeHelperExtensions

module ActionViewExtensions
  # Over ride the default behaviour of the submit_tag to prevent multiple
  # clicks before the form is submitted. This is implemeneted by replacing
  # the :onclick action of the element to "return false" rather than actually
  # disabling button.
  #
  # ==== Options
  # * <tt>:mark_for_disable</tt> - When set to false, this override does happen.
  #
  # Other options remain same as for sumbit_tag with the following modifications
  # * <tt>:onclick</tt> - Any existing javascript action for :onclick will be retained.
  # The javascript for marking the clicked button will be added to the :onclick
  # * <tt>:disable_with</tt> - Value of this parameter will be used as the value for a disabled version
  #   of the submit button when the form is submitted. Defaults to 'Processing...'
  # * <tt>:deactivate_button</tt> - When set to true, this disable the button. Defaults to false.
  # This can be set to true when the element needs to be exclusively disabled rather than just
  # assigning "return false" to :onclick aattribute of the element
  #
  #   submit_tag "Update", :mark_for_disable => false
  #   # => <input name="commit" type="submit" value="Update" />
  #
  #   submit_tag "Update"
  #   # => <input name="commit" onclick="DisableFormButton.markButton(this, 'Processing...', false);"
  #   #    type="submit" value="Update" />
  #
  #   submit_tag "Update", :disable_with => "Updating..."
  #   # => <input name="commit" onclick="DisableFormButton.markButton(this, 'Updating...', false);"
  #   #    type="submit" value="Update" />
  #
  #   submit_tag "Update", :deactivate_button => true
  #   # => <input name="commit" onclick="DisableFormButton.markButton(this, 'Processing...', true);"
  #   #    type="submit" value="Update" />
  #
  #   submit_tag "Update", :disable_with => "Updating...", :onclick => "ValidateForm()"
  #   # => <input name="commit" onclick="ValidateForm(); DisableFormButton.markButton(this, 'Updating...', false);"
  #   #    type="submit" value="Update" />
  def submit_tag_with_disable(value = "Save changes", options = {})
    if options[:class] =~ /button/ && (options.delete(:mark_for_disable) != false)
      disable_with_text = options.delete(:disable_with) || 'Processing...'
      deactivate_button = options.delete(:deactivate_button) || false
      options[:onclick] ||= ""
      options[:onclick] = "BetterProgressBar.markElementForDisable(this, '#{disable_with_text}', #{deactivate_button}); " + options[:onclick]
    end

    submit_tag_without_disable(value, options)
  end
end

ActionView::Base.send :include, ActionViewExtensions
ActionView::Base.alias_method_chain :submit_tag, :disable