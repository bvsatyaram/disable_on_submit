disable_on_submit
=============

`disable_on_submit` rails plugin avoids mulitple submission of forms by disabling the submit button once pressed. The button is re-enabled once the response is back.
Please note that this plugin assumes usage of `prototype` in the rails app.
The plugin overrides the rails inbuilt `method_javascript_function_with_disable` method, retaining all its functionality.

Installation
------------

Run the following script in your rails root directory to install the plugin.

    ./script/plugin install git@github.com:bvsatyaram/disable_on_submit.git

Then, copy the file `resources/disable_on_submit` to your `public/javascripts` directory and make sure that this JS file is loaded in the view.

Usage
-----

Once the plugin is installed, all you need to do is, add the html class attribute `button` to all the form submit tags. Thats all!!

## Customization

Of course, the plugin can be customized.

The default text with which the submit button ext is replaced is `Processing...`.
You may change this to anything you want, say, 'Please wait...' by passing `:disable_with` option to the submit tag.

    submit_tag "Save", :disable_with => "Please wait..."

If a need arises where you actually need an html css attribute `button` to a form submit tag but you don't want the plugin to disable,
you may do the same by passing `:mark_for_disable` option with the value `false`

    submit_tag "Save", :mark_for_disable => false

The button is not `deactivated` by default after clicking the button. You may disable it by passing `:deactivate_button` with the value `true`

    submit_tag "Save", :deactivate_button => true

Please note that the default functionality of submit tag is not altered and all the options can still be utilized.

    submit_tag "Save", :disable_with => "Updating...", :onclick => "ValidateForm()"

Author
------

B V Satyaram <[bvsatyaram.com](http://bvsatyaram.com)>