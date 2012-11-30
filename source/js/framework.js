// JavaScript Document
if (!("models" in window))
	window.models = {};
	
if (!("controllers" in window))
	window.controllers = {};
	
if (!("flash" in window))
	window.flash = {};
	
if (!("events" in flash))
	flash.events = {};
	
if (!("org" in window))
	window.org = {};

if (!("apache" in org))
	org.apache = {};
	
if (!("flex" in org.apache))
	org.apache.flex = {};

if (!("core" in org.apache.flex))
	org.apache.flex.core = {};
	
if (!("html" in org.apache.flex))
	org.apache.flex.html = {};

if (!("binding" in org.apache.flex))
	org.apache.flex.binding = {};

if (!("static" in org.apache.flex.html))
	org.apache.flex.html.staticControls = {};

if (!("beads" in org.apache.flex.html.staticControls))
	org.apache.flex.html.staticControls.beads = {};

if (!("static" in org.apache.flex.html.staticControls.beads))
	org.apache.flex.html.staticControls.beads.models = {};

/*******************************
*
* Application
*
********************************/

org.apache.flex.core.Application = adobe.extend("org.apache.flex.core.Application", adobe, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.core.Application()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.core.Application} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
    
    queuedListeners : undefined,
    
    addEventListener : function(type, handler)
    {
        // at contructor time, the element may not be available yet
        if (typeof this.element == "undefined")
        {
            if (typeof this.queuedListeners == "undefined")
                this.queuedListeners = [];
            this.queuedListeners.push ({ type: type, handler: handler});
            return;
        }
        
        if (typeof this.element.attachEvent == "function")
            this.element.attachEvent(adobe.eventMap[type], handler);
        else if (typeof this.element.addEventListener == "function")
        {
            this.element.addEventListener(type, handler);
        }
    },
    
    start : function()
    {
		/** @type {org.apache.flex.core.Application} */
		var self = this;

        this.element = document.getElementsByTagName('body')[0];
        
        if (typeof this.queuedListeners != "undefined")
        {
            var n = this.queuedListeners.length;
            for (var i = 0; i < n; i++)
            {
                var q = this.queuedListeners[i];
                this.addEventListener(q.type, q.handler);
            }
        }

        self.valuesImpl = new self.valuesImplClass;
        org.apache.flex.core.ValuesManager.valuesImpl = self.valuesImpl;
			
        self.initialView = new self.initialViewClass;
        self.initialView.addToParent(this.element);
        self.initialView.initUI(self);
        // create the event
        var evt = document.createEvent('Event');
        // define that the event name is `build`
        evt.initEvent('viewChanged', true, true);

        // elem is any element
        this.element.dispatchEvent(evt);

    }
    
});


/**
 * Member: org.apache.flex.core.Application.prototype._CLASS
 * @const
 * @type {org.apache.flex.core.Application}
 */
org.apache.flex.core.Application.prototype._CLASS = org.apache.flex.core.Application;


/**
 * Member: org.apache.flex.core.Application._PACKAGE
 * @const
 * @type {org.apache.flex.core.Application}
 */
org.apache.flex.core.Application._PACKAGE = org.apache.flex.core;


/**
 * Member: org.apache.flex.core.Application._NAME
 * @const
 * @type {string}
 */
org.apache.flex.core.Application._NAME = "org.apache.flex.core.Application";

/**
 * Member: org.apache.flex.core.Application._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.core.Application._FULLNAME = "org.apache.flex.core.Application";

/**
 * Member: org.apache.flex.core.Application._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.core.Application._SUPER = Object;

/**
 * Member: org.apache.flex.core.Application._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.core.Application._NAMESPACES = {};

adobe.classes["org.apache.flex.core.Application"]  = org.apache.flex.core.Application;

/*******************************
*
* UIBase
*
********************************/

org.apache.flex.core.UIBase = adobe.extend("org.apache.flex.core.UIBase", adobe, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.core.UIBase()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.core.UIBase} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
    
    addEventListener : function(type, handler)
    {
        if (typeof this.element.attachEvent == "function")
            this.element.attachEvent(adobe.eventMap[type], handler);
        else if (typeof this.element.addEventListener == "function")
            this.element.addEventListener(type, handler);
    },
    
    dispatchEvent : function(evt)
    {
		/** @type {org.apache.flex.core.UIBase} */
		var self = this;

        // elem is any element
        this.element.dispatchEvent(evt);
    },
    
    set_x : function(n)
    {
        this.positioner.style.position = "absolute";
        this.positioner.style.left = n.toString() + "px";
    },

    set_y : function(n)
    {
        this.positioner.style.position = "absolute";
        this.positioner.style.top = n.toString() + "px";
    }
    
});


/**
 * Member: org.apache.flex.core.UIBase.prototype._CLASS
 * @const
 * @type {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.UIBase.prototype._CLASS = org.apache.flex.core.UIBase;


/**
 * Member: org.apache.flex.core.UIBase._PACKAGE
 * @const
 * @type {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.UIBase._PACKAGE = org.apache.flex.core;


/**
 * Member: org.apache.flex.core.UIBase._NAME
 * @const
 * @type {string}
 */
org.apache.flex.core.UIBase._NAME = "org.apache.flex.core.UIBase";

/**
 * Member: org.apache.flex.core.UIBase._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.core.UIBase._FULLNAME = "org.apache.flex.core.UIBase";

/**
 * Member: org.apache.flex.core.UIBase._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.core.UIBase._SUPER = Object;

/**
 * Member: org.apache.flex.core.UIBase._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.core.UIBase._NAMESPACES = {};

adobe.classes["org.apache.flex.core.UIBase"]  = org.apache.flex.core.UIBase;

/*******************************
*
* ViewBase
*
********************************/

org.apache.flex.core.ViewBase = adobe.extend("org.apache.flex.core.ViewBase", org.apache.flex.core.UIBase, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.core.ViewBase()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.core.ViewBase} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
    
    addToParent : function(p)
    {
        this.element = document.createElement("div");
        p.appendChild(this.element);
    },

    initUI: function(app)
    {
		/** @type {org.apache.flex.core.ViewBase} */
		var self = this;

        // cache this for speed
        var descriptors = self.get_uiDescriptors();
			
        var n = descriptors.length;
        var i = 0;
        
        var value;
        var valueName;
        
        while (i < n)
        {
            var c = descriptors[i++];					// class
            var o = new c();
            o.addToParent(this.element);
            c = descriptors[i++];							// model
            if (c)
            {
                value = new c();
                o.addBead(value);
            }
            if (typeof o.initModel == "function")
                o.initModel();
            var j;
            var m;
            valueName = descriptors[i++];					// id
            if (valueName)
                this[valueName] = o;

            m = descriptors[i++];							// num props
            for (j = 0; j < m; j++)
            {
                valueName = descriptors[i++];
                value = descriptors[i++];
                o["set_" + valueName](value);
            }
            m = descriptors[i++];							// num beads
            for (j = 0; j < m; j++)
            {
                c = descriptors[i++];
                value = new c();
                o.addBead(value);
            }
            if (typeof o.initSkin == "function")
                o.initSkin();
            m = descriptors[i++];							// num events
            for (j = 0; j < m; j++)
            {
                valueName = descriptors[i++];
                value = descriptors[i++];
                o.addEventListener(valueName, adobe.createProxy(this, value));
            }
            m = descriptors[i++];							// num bindings
            for (j = 0; j < m; j++)
            {
                valueName = descriptors[i++];
                var bindingType = descriptors[i++];
                switch (bindingType)
                {
                    case 0: 
                        var sb = new org.apache.flex.binding.SimpleBinding();
                        sb.destination = o;
                        sb.destinationPropertyName = valueName;
                        sb.source = app[descriptors[i++]];
                        sb.sourcePropertyName = descriptors[i++];
                        sb.eventName = descriptors[i++];
                        sb.initialize();
                }
            }
        }
    }

});


/**
 * Member: org.apache.flex.core.ViewBase.prototype._CLASS
 * @const
 * @type {org.apache.flex.core.ViewBase}
 */
org.apache.flex.core.ViewBase.prototype._CLASS = org.apache.flex.core.ViewBase;


/**
 * Member: org.apache.flex.core.ViewBase._PACKAGE
 * @const
 * @type {org.apache.flex.core.ViewBase}
 */
org.apache.flex.core.ViewBase._PACKAGE = org.apache.flex.core;


/**
 * Member: org.apache.flex.core.ViewBase._NAME
 * @const
 * @type {string}
 */
org.apache.flex.core.ViewBase._NAME = "org.apache.flex.core.ViewBase";

/**
 * Member: org.apache.flex.core.ViewBase._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.core.ViewBase._FULLNAME = "org.apache.flex.core.ViewBase";

/**
 * Member: org.apache.flex.core.ViewBase._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.core.ViewBase._SUPER = Object;

/**
 * Member: org.apache.flex.core.ViewBase._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.core.ViewBase._NAMESPACES = {};

adobe.classes["org.apache.flex.core.ViewBase"]  = org.apache.flex.core.ViewBase;

/*******************************
*
* Label
*
********************************/

org.apache.flex.html.staticControls.Label = adobe.extend("org.apache.flex.html.staticControls.Label", org.apache.flex.core.UIBase, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.html.staticControls.Label()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.html.staticControls.Label} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
    
    addToParent : function(p)
    {
        this.element = document.createElement("div");
        this.positioner = this.element;
        p.appendChild(this.element);
    },
    
    get_text : function()
    {
        return this.element.innerHTML;
    },
    
    set_text : function(s)
    {
        this.element.innerHTML = s; 
    }

});


/**
 * Member: org.apache.flex.html.staticControls.Label.prototype._CLASS
 * @const
 * @type {org.apache.flex.html.staticControls.Label}
 */
org.apache.flex.html.staticControls.Label.prototype._CLASS = org.apache.flex.html.staticControls.Label;


/**
 * Member: org.apache.flex.html.staticControls.Label._PACKAGE
 * @const
 * @type {org.apache.flex.html.staticControls.Label}
 */
org.apache.flex.html.staticControls.Label._PACKAGE = org.apache.flex.html.staticControls;


/**
 * Member: org.apache.flex.html.staticControls.Label._NAME
 * @const
 * @type {string}
 */
org.apache.flex.html.staticControls.Label._NAME = "org.apache.flex.html.staticControls.Label";

/**
 * Member: org.apache.flex.html.staticControls.Label._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.html.staticControls.Label._FULLNAME = "org.apache.flex.html.staticControls.Label";

/**
 * Member: org.apache.flex.html.staticControls.Label._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.html.staticControls.Label._SUPER = Object;

/**
 * Member: org.apache.flex.html.staticControls.Label._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.html.staticControls.Label._NAMESPACES = {};

adobe.classes["org.apache.flex.html.staticControls.Label"]  = org.apache.flex.html.staticControls.Label;

/*******************************
*
* TextButton
*
********************************/
org.apache.flex.html.staticControls.TextButton = adobe.extend("org.apache.flex.html.staticControls.TextButton", org.apache.flex.core.UIBase, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.html.staticControls.TextButton()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.html.staticControls.TextButton} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
    
    addToParent : function(p)
    {
        this.positioner = document.createElement("input");
        this.element = this.positioner;
        this.element.setAttribute("type", "button");
        p.appendChild(this.positioner);
    },
    
    get_text : function()
    {
        return this.element.getAttribute("value");
    },
    
    set_text : function(s)
    {
        this.element.setAttribute("value", s); 
    }
    
});


/**
 * Member: org.apache.flex.html.staticControls.TextButton.prototype._CLASS
 * @const
 * @type {org.apache.flex.html.staticControls.TextButton}
 */
org.apache.flex.html.staticControls.TextButton.prototype._CLASS = org.apache.flex.html.staticControls.TextButton;


/**
 * Member: org.apache.flex.html.staticControls.TextButton._PACKAGE
 * @const
 * @type {org.apache.flex.html.staticControls.TextButton}
 */
org.apache.flex.html.staticControls.TextButton._PACKAGE = org.apache.flex.html.staticControls;


/**
 * Member: org.apache.flex.html.staticControls.TextButton._NAME
 * @const
 * @type {string}
 */
org.apache.flex.html.staticControls.TextButton._NAME = "org.apache.flex.html.staticControls.TextButton";

/**
 * Member: org.apache.flex.html.staticControls.TextButton._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.html.staticControls.TextButton._FULLNAME = "org.apache.flex.html.staticControls.TextButton";

/**
 * Member: org.apache.flex.html.staticControls.TextButton._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.html.staticControls.TextButton._SUPER = Object;

/**
 * Member: org.apache.flex.html.staticControls.TextButton._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.html.staticControls.TextButton._NAMESPACES = {};

adobe.classes["org.apache.flex.html.staticControls.TextButton"]  = org.apache.flex.html.staticControls.TextButton;

/*******************************
*
* SimpleValuesImpl
*
********************************/

org.apache.flex.core.SimpleValuesImpl = adobe.extend("org.apache.flex.core.SimpleValuesImpl", adobe, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.core.SimpleValuesImpl()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.core.SimpleValuesImpl} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
        
});


/**
 * Member: org.apache.flex.core.SimpleValuesImpl.prototype._CLASS
 * @const
 * @type {org.apache.flex.core.SimpleValuesImpl}
 */
org.apache.flex.core.SimpleValuesImpl.prototype._CLASS = org.apache.flex.core.SimpleValuesImpl;


/**
 * Member: org.apache.flex.core.SimpleValuesImpl._PACKAGE
 * @const
 * @type {org.apache.flex.core.SimpleValuesImpl}
 */
org.apache.flex.core.SimpleValuesImpl._PACKAGE = org.apache.flex.core;


/**
 * Member: org.apache.flex.core.SimpleValuesImpl._NAME
 * @const
 * @type {string}
 */
org.apache.flex.core.SimpleValuesImpl._NAME = "org.apache.flex.core.SimpleValuesImpl";

/**
 * Member: org.apache.flex.core.SimpleValuesImpl._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.core.SimpleValuesImpl._FULLNAME = "org.apache.flex.core.SimpleValuesImpl";

/**
 * Member: org.apache.flex.core.SimpleValuesImpl._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.core.SimpleValuesImpl._SUPER = Object;

/**
 * Member: org.apache.flex.core.SimpleValuesImpl._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.core.SimpleValuesImpl._NAMESPACES = {};

adobe.classes["org.apache.flex.core.SimpleValuesImpl"]  = org.apache.flex.core.SimpleValuesImpl;

/*******************************
*
* ValuesManager
*
********************************/

org.apache.flex.core.ValuesManager = adobe.extend("org.apache.flex.core.ValuesManager", adobe, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.core.ValuesManager()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.core.ValuesManager} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
        
});


/**
 * Member: org.apache.flex.core.ValuesManager.prototype._CLASS
 * @const
 * @type {org.apache.flex.core.ValuesManager}
 */
org.apache.flex.core.ValuesManager.prototype._CLASS = org.apache.flex.core.ValuesManager;


/**
 * Member: org.apache.flex.core.ValuesManager._PACKAGE
 * @const
 * @type {org.apache.flex.core.ValuesManager}
 */
org.apache.flex.core.ValuesManager._PACKAGE = org.apache.flex.core;


/**
 * Member: org.apache.flex.core.ValuesManager._NAME
 * @const
 * @type {string}
 */
org.apache.flex.core.ValuesManager._NAME = "org.apache.flex.core.ValuesManager";

/**
 * Member: org.apache.flex.core.ValuesManager._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.core.ValuesManager._FULLNAME = "org.apache.flex.core.ValuesManager";

/**
 * Member: org.apache.flex.core.ValuesManager._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.core.ValuesManager._SUPER = Object;

/**
 * Member: org.apache.flex.core.ValuesManager._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.core.ValuesManager._NAMESPACES = {};

adobe.classes["org.apache.flex.core.ValuesManager"]  = org.apache.flex.core.ValuesManagerValuesManager;

/*******************************
*
* SimpleBinding
*
********************************/

org.apache.flex.binding.SimpleBinding = adobe.extend("org.apache.flex.binding.SimpleBinding", adobe, {

	// Constructor
	

	/**
	 * Constructor: org.apache.flex.binding.SimpleBinding()
	 * @constructor
	 */
	init : function()
	{
		/** @type {org.apache.flex.binding.SimpleBinding} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},
    
    source: null,
    sourcePropertyName: null,
    eventName: null,
    destination: null,
    destinationPropertyName: null,
    
    changeHandler : function()
    {
		/** @type {org.apache.flex.binding.SimpleBinding} */
		var self = this;

        self.destination["set_" + self.destinationPropertyName](self.source["get_" + self.sourcePropertyName]());
    },
    
    initialize : function()
    {
		/** @type {org.apache.flex.binding.SimpleBinding} */
		var self = this;

        self.source.addEventListener(self.eventName, adobe.createProxy(self, self.changeHandler));
        self.destination["set_" + self.destinationPropertyName](self.source["get_" + self.sourcePropertyName]());
    }
    
    
    
});


/**
 * Member: org.apache.flex.binding.SimpleBinding.prototype._CLASS
 * @const
 * @type {org.apache.flex.binding.SimpleBinding}
 */
org.apache.flex.binding.SimpleBinding.prototype._CLASS = org.apache.flex.binding.SimpleBinding;


/**
 * Member: org.apache.flex.binding.SimpleBinding._PACKAGE
 * @const
 * @type {org.apache.flex.binding.SimpleBinding}
 */
org.apache.flex.binding.SimpleBinding._PACKAGE = org.apache.flex.binding;


/**
 * Member: org.apache.flex.binding.SimpleBinding._NAME
 * @const
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding._NAME = "org.apache.flex.binding.SimpleBinding";

/**
 * Member: org.apache.flex.binding.SimpleBinding._FULLNAME
 * @const
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding._FULLNAME = "org.apache.flex.binding.SimpleBinding";

/**
 * Member: org.apache.flex.binding.SimpleBinding._SUPER
 * @const
 * @type {Object}
 */
org.apache.flex.binding.SimpleBinding._SUPER = Object;

/**
 * Member: org.apache.flex.binding.SimpleBinding._NAMESPACES
 * @const
 * @type {Object}
 */
org.apache.flex.binding.SimpleBinding._NAMESPACES = {};

adobe.classes["org.apache.flex.binding.SimpleBinding"]  = org.apache.flex.binding.SimpleBinding;

/*******************************
*
* EventDispatcher
*
********************************/

flash.events.EventDispatcher = adobe.extend("flash.events.EventDispatcher", adobe, {

	// Constructor
	

	/**
	 * Constructor: flash.events.EventDispatcher()
	 * @constructor
	 */
	init : function()
	{
		/** @type {flash.events.EventDispatcher} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
		return self;
	},

    listeners : {},
    
    addEventListener : function(type, handler)
    {
        if (typeof this.listeners.type === "undefined")
            this.listeners[type] = [];
            
        this.listeners[type].push(handler);
    },
    
    dispatchEvent : function(event)
    {
        var self = this;
        var type = event.type;
        if (typeof this.listeners[type] !== "undefined")
        {
            var arr = this.listeners[type];
            var n = arr.length;
            for (var i = 0; i < n; i++)
                arr[i](event);
        }
    }    
    
});


/**
 * Member: flash.events.EventDispatcher.prototype._CLASS
 * @const
 * @type {flash.events.EventDispatcher}
 */
flash.events.EventDispatcher.prototype._CLASS = flash.events.EventDispatcher;


/**
 * Member: flash.events.EventDispatcher._PACKAGE
 * @const
 * @type {flash.events.EventDispatcher}
 */
flash.events.EventDispatcher._PACKAGE = flash.events;


/**
 * Member: flash.events.EventDispatcher._NAME
 * @const
 * @type {string}
 */
flash.events.EventDispatcher._NAME = "flash.events.EventDispatcher";

/**
 * Member: flash.events.EventDispatcher._FULLNAME
 * @const
 * @type {string}
 */
flash.events.EventDispatcher._FULLNAME = "flash.events.EventDispatcher";

/**
 * Member: flash.events.EventDispatcher._SUPER
 * @const
 * @type {Object}
 */
flash.events.EventDispatcher._SUPER = Object;

/**
 * Member: flash.events.EventDispatcher._NAMESPACES
 * @const
 * @type {Object}
 */
flash.events.EventDispatcher._NAMESPACES = {};

adobe.classes["flash.events.EventDispatcher"]  = flash.events.EventDispatcher;

/*******************************
*
* Event
*
********************************/

flash.events.Event = adobe.extend("flash.events.Event", adobe, {

	// Constructor
	

	/**
	 * Constructor: flash.events.Event()
	 * @constructor
	 */
	init : function(type)
	{
		/** @type {flash.events.Event} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
        
        self.type = type;
		return self;
	},

    type : undefined
        
});


/**
 * Member: flash.events.Event.prototype._CLASS
 * @const
 * @type {flash.events.Event}
 */
flash.events.Event.prototype._CLASS = flash.events.Event;


/**
 * Member: flash.events.Event._PACKAGE
 * @const
 * @type {flash.events.Event}
 */
flash.events.Event._PACKAGE = flash.events;


/**
 * Member: flash.events.Event._NAME
 * @const
 * @type {string}
 */
flash.events.Event._NAME = "flash.events.Event";

/**
 * Member: flash.events.Event._FULLNAME
 * @const
 * @type {string}
 */
flash.events.Event._FULLNAME = "flash.events.Event";

/**
 * Member: flash.events.Event._SUPER
 * @const
 * @type {Object}
 */
flash.events.Event._SUPER = Object;

/**
 * Member: flash.events.Event._NAMESPACES
 * @const
 * @type {Object}
 */
flash.events.Event._NAMESPACES = {};

adobe.classes["flash.events.Event"]  = flash.events.Event;

