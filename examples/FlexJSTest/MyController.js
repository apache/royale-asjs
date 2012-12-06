/** @preserve CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:53:06
 */
/**
 * CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:52:56
 *
 * Class: controllers.MyController
 */
controllers.MyController = adobe.extend( "MyController", Object, {

	// Constructor
	

	/**
	 * Constructor: controllers.MyController()
	 * @constructor
	 * @this {controllers}
	 * @param {FlexJSTest} app
	 */
	init : function(app /* : FlexJSTest */)
	{
		/** @type {controllers.MyController} */
		var self = this;
		
		self.app = app;
		app.addEventListener("viewChanged", adobe.createProxy(self, self.viewChangeHandler));
		return self;
	}
,

	/**
	 * Member: controllers.MyController.app
	 * @private
	 * @type {FlexJSTest}
	 */
	app /* : FlexJSTest */ : undefined,
	

	/**
	 * Method: controllers.MyController.viewChangeHandler()
	 * @this {controllers.MyController}
	 * @private
	 * @param {flash.events.Event} event
	 */
	viewChangeHandler : function(event /* : Event */) /* : void */
	{
		/** @type {controllers.MyController} */
		var self = this;
		self.app.initialView.addEventListener("buttonClicked", adobe.createProxy(self, self.buttonClickHandler));
	},
	

	/**
	 * Method: controllers.MyController.buttonClickHandler()
	 * @this {controllers.MyController}
	 * @private
	 * @param {flash.events.Event} event
	 */
	buttonClickHandler : function(event /* : Event */) /* : void */
	{
		/** @type {controllers.MyController} */
		var self = this;
		self.app.model.set_labelText("Hello Universe");
	}
});


/**
 * Member: controllers.MyController.prototype._CLASS
 * @const
 * @type {controllers.MyController}
 */
controllers.MyController.prototype._CLASS = controllers.MyController;


/**
 * Member: controllers.MyController._PACKAGE
 * @const
 * @type {controllers}
 */
controllers.MyController._PACKAGE = controllers;


/**
 * Member: controllers.MyController._NAME
 * @const
 * @type {string}
 */
controllers.MyController._NAME = "MyController";

/**
 * Member: controllers.MyController._FULLNAME
 * @const
 * @type {string}
 */
controllers.MyController._FULLNAME = "controllers.MyController";

/**
 * Member: controllers.MyController._SUPER
 * @const
 * @type {Object}
 */
controllers.MyController._SUPER = Object;

/**
 * Member: controllers.MyController._NAMESPACES
 * @const
 * @type {Object}
 */
controllers.MyController._NAMESPACES = {
	"app::7:controllers.MyController" : true,
	"viewChangeHandler::7:controllers.MyController" : true,
	"buttonClickHandler::7:controllers.MyController" : true
}

adobe.classes["controllers.MyController"]  = controllers.MyController;

