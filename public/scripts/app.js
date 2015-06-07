window.addEventListener = function(el, eventName, handler) {
  if (el.addEventListener) {
    el.addEventListener(eventName, handler);
  } else {
    el.attachEvent('on' + eventName, function(){
      handler.call(el);
    });
  }
};

// U for utilities
window.U = {};

window.U.toggleClass = function(el, className) {
  if (el.classList) {
    el.classList.toggle(className);
  } else {
    var classes = el.className.split(' ');
    var existingIndex = -1;
    for (var i = classes.length; i--;) {
      if (classes[i] === className)
        existingIndex = i;
    }

    if (existingIndex >= 0)
      classes.splice(existingIndex, 1);
    else
      classes.push(className);

    el.className = classes.join(' ');
  }
};

window.U.addClass = function(el, className) {
  if (el.classList)
      el.classList.add(className);
  else
      el.className += ' ' + className;
};

window.U.toggleAttr = function(el, attr) {
  var oldState = (el.getAttribute(attr) === 'true'),
      newState = !oldState;

  el.setAttribute(attr, newState);
  return newState;
};

// caches reused dom elements
window.cache = {};

window.cache.editTrigger = document.getElementById('edit-trigger');
window.cache.boxList = document.getElementById('box-list');

// This wrapper prevents variables
// from being placed on `window`
(function(){

  // This is in a `setTimeout` to prevent initial transitions on page load
  window.setTimeout(function(){U.addClass(document.documentElement, 'enable-transitions');}, 100);

  addEventListener(window.cache.editTrigger, 'touchend', function(e){
    e.preventDefault();

    U.toggleAttr(window.cache.editTrigger, 'aria-checked');
    U.toggleClass(window.cache.boxList, 'box--is-in-edit-mode');
  });
  addEventListener(window.cache.editTrigger, 'click', function(e){
    U.toggleAttr(window.cache.editTrigger, 'aria-checked');
    U.toggleClass(window.cache.boxList, 'box--is-in-edit-mode');
  });
  addEventListener(window.cache.editTrigger, 'mouseout', function(e){
    // get rid of the blur leftover from clicking button element.
    // is this bad for a11y?
    this.blur();
  });

})();
