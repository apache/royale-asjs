/** @preserve CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:53:00
 */
/**
 * CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:52:57
 *
 * Class: MyInitialView
 * @constructor
 * @extends org.apache.flex.core.ViewBase
 */
// protected: ProtectedNs:"MyInitialView"
MyInitialView = adobe.extend( "MyInitialView", org.apache.flex.core.ViewBase, {

	// Constructor
	

	/**
	 * Constructor: MyInitialView()
	 * @constructor
	 */
	init : function()
	{
		/** @type {MyInitialView} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
		self._super();
		return self;
	}
,

	/**
	 * Member: MyInitialView.lbl
	 * @type {org.apache.flex.html.staticControls.Label}
	 */
	lbl /* : Label */ : undefined,
	

	/**
	 * Method: MyInitialView.get_uiDescriptors()
	 * @this {MyInitialView}
	 * @override
	 * @return {Array}
	 */
	get_uiDescriptors : function() /* : Array */
	{
		/** @type {MyInitialView} */
		var self = this;
		return [org.apache.flex.html.staticControls.Label, null, "lbl", 2, "x", 100, "y", 25, 0, 0, 1, "text", 0, "model", "labelText", "labelTextChanged", org.apache.flex.html.staticControls.TextButton, null, null, 3, "text", "OK", "x", 100, "y", 75, 0, 1, "click", self.clickHandler, 0];
	},
	

	/**
	 * Method: MyInitialView.clickHandler()
	 * @this {MyInitialView}
	 * @private
	 * @param {flash.events.Event} event
	 */
	clickHandler : function(event /* : Event */) /* : void */
	{
		/** @type {MyInitialView} */
		var self = this;
		self.dispatchEvent(adobe.newObject(flash.events.Event, ["buttonClicked"]));
	}
});


/**
 * Member: MyInitialView.prototype._CLASS
 * @const
 * @type {MyInitialView}
 */
MyInitialView.prototype._CLASS = MyInitialView;


/**
 * Member: MyInitialView._PACKAGE
 * @const
 * @type {MyInitialView}
 */
MyInitialView._PACKAGE = adobe.globals;


/**
 * Member: MyInitialView._NAME
 * @const
 * @type {string}
 */
MyInitialView._NAME = "MyInitialView";

/**
 * Member: MyInitialView._FULLNAME
 * @const
 * @type {string}
 */
MyInitialView._FULLNAME = "MyInitialView";

/**
 * Member: MyInitialView._SUPER
 * @const
 * @type {org.apache.flex.core.ViewBase}
 */
MyInitialView._SUPER = org.apache.flex.core.ViewBase;

/**
 * Member: MyInitialView._NAMESPACES
 * @const
 * @type {Object}
 */
MyInitialView._NAMESPACES = {
	"uiDescriptors::2" : true,
	"lbl::2" : true,
	"clickHandler::7:MyInitialView" : true
}

adobe.classes["MyInitialView"]  = MyInitialView;

