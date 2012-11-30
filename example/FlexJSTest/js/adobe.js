// JavaScript Document
/* Simple JavaScript Inheritance
 * By John Resig http://ejohn.org/
 * MIT Licensed.
 */
// Inspired by base2 and Prototype

// Modifications from original:
// - "Class" replaced by "adobe"
// - Refactored as a singleton class factory.  You call adobe.extend for all classes
// instead of calling the class's extend method as shown in the blog aritcle
// - createProxy added
// - newObject added
// - eventMap added
(function(){
  var initializing = false, fnTest = /xyz/.test(function(){xyz;}) ? /\b_super\b/ : /.*/;
  // The base Class implementation (does nothing)
  this.adobe = function(){};
  
  adobe.eventMap = {
  	click: "onClick"
  }
  
  adobe.classes = {
  }
  
  adobe.createProxy = function(context, method)
  {
	  var self = context;
	  return function(e) { method.apply(self, [e]) };
  }
  
  adobe.newObject = function(ctor, ctorArgs)
  {
	  if (ctor === flash.events.Event && ctorArgs.length == 1)
	  {
		  var evt = document.createEvent('Event');
		  evt.initEvent(ctorArgs[0], false, false);
		  return evt;
	  }
	  
	  if (ctorArgs.length == 1)
		return new ctor(ctorArgs[0]);
	  if (ctorArgs.length == 0)
	  	return new ctor();
  }
  
  adobe.prototype.init = function () {};
  
  // Create a new Class that inherits from this class
  adobe.extend = function(className, superClass, prop) {
    var _super = superClass.prototype;
    
    // Instantiate a base class (but only create the instance,
    // don't run the init constructor)
    initializing = true;
    var prototype = new superClass();
    initializing = false;
    
    // Copy the properties over onto the new prototype
    for (var name in prop) {
      // Check if we're overwriting an existing function
      prototype[name] = typeof prop[name] == "function" && 
        typeof _super[name] == "function" && fnTest.test(prop[name]) ?
        (function(name, fn){
          return function() {
            var tmp = this._super;
            
            // Add a new ._super() method that is the same method
            // but on the super-class
            this._super = _super[name];
            
            // The method only need to be bound temporarily, so we
            // remove it when we're done executing
            var ret = fn.apply(this, arguments);        
            this._super = tmp;
            
            return ret;
          };
        })(name, prop[name]) :
        prop[name];
    }
    
    // The dummy class constructor
    function adobe() {
      // All construction is actually done in the init method
      if ( !initializing && this.init )
        this.init.apply(this, arguments);
    }
    
	// Populate our constructed prototype object
    adobe.prototype = prototype;
    
    // Enforce the constructor to be what we expect
    adobe.prototype.constructor = adobe;

	// AJH remove this for now
    // And make this class extendable
    // adobe.extend = arguments.callee;
    
    return adobe;
  };
})();