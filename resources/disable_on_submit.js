/*  DisableOnSubmit, version 1.0
 *  (c) 2010 B.V.Satyaram
 *
 *  disable_on_submit is a rails plugin that disables form button on click.
 *  For details, see the DisableOnSubmit github page: http://github.com/bvsatyaram/disable_on_submit
 *
 *--------------------------------------------------------------------------*/

/* This function is to disable the submit button on form submission */
var DisableOnSubmit = {
  shouldDisableElement: null,
  elementToDisable: null,
  elementToReenable: null,
  disableText: null,
  reenableText: null,
  originalOnclick: null,
  deactivateButton: null,

  // Mark the button whch is clicked so that it can be retrieved before unload
  markElementForDisable: function(element, disable_with_text, deactivate) {
    DisableOnSubmit.reset();
    element = $(element);
    DisableOnSubmit.disableText = disable_with_text;
    DisableOnSubmit.shouldDisableElement = true;
    DisableOnSubmit.elementToDisable = element;
    DisableOnSubmit.deactivateButton = deactivate;
  },

  // On page unload check if a button was marked clicked. If yes, then disable the button before page unload
  disableElement: function() {
    if (DisableOnSubmit.shouldDisableElement) {
      element = DisableOnSubmit.elementToDisable;
      DisableOnSubmit.reenableText = element.value
      element.value = DisableOnSubmit.disableText;
      element.addClassName('disabled_button');

      if (DisableOnSubmit.deactivateButton){
        element.disabled = true;
      }

      DisableOnSubmit.originalOnclick = element.getAttribute('onclick');
      element.setAttribute('onclick', 'return false');
      DisableOnSubmit.elementToReenable = element;
      DisableOnSubmit.shouldDisableElement = false;
    }
  },

  // On ajax response reenable buttons which are disabled
  reEnableElement: function() {
    element = DisableOnSubmit.elementToReenable;

    // If the element itself is gone, just return
    if (!element) {
      DisableOnSubmit.reset();
      return;
    }

    element.value = DisableOnSubmit.reenableText;
    element.removeClassName('disabled_button');

    if (DisableOnSubmit.deactivateButton){
      element.disabled = false;
      DisableOnSubmit.deactivateButton = false;
    }

    element.setAttribute('onclick', DisableOnSubmit.originalOnclick);
    DisableOnSubmit.reset();
  },

  // Disable links with method on click
  disableLink: function(element) {
    element = $(element);
    element.setAttribute('onclick', 'return false');
    element.setAttribute('href', '#');
    element.addClassName('disabled_link');
  },

  // Reset DisableOnSubmit
  reset: function(){
    this.shouldDisableElement = false;
    this.elementToDisable =  '';
    this.elementToReenable = '';
    this.disableText = '';
    this.reenableText = '';
    this.originalOnclick = '';
    this.deactivateButton = false;
  }
}

DisableOnSubmit.reset();

/* This is to disable the buttons once a non-ajax form is submitted */
window.onbeforeunload = DisableOnSubmit.disableElement;