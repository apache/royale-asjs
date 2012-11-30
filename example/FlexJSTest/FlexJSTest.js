/** @preserve CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:52:57
 */
/**
 * CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:52:56
 *
 * Class: FlexJSTest
 * @constructor
 * @extends org.apache.flex.core.Application
 */
FlexJSTest = adobe.extend( "FlexJSTest", org.apache.flex.core.Application, {

	// Constructor
	

	/**
	 * Constructor: FlexJSTest()
	 * @constructor
	 */
	init : function()
	{
		/** @type {FlexJSTest} */
		var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
		self.valuesImplClass = MySimpleValuesImpl;
		self.initialViewClass = MyInitialView;
		self.model = adobe.newObject(models.MyModel, []);
		self.model.set_labelText("Hello World!");
		self.controller = adobe.newObject(controllers.MyController, [self]);
		return self;
	}
,

	/**
	 * Member: FlexJSTest.controller
	 * @private
	 * @type {controllers.MyController}
	 */
	controller /* : MyController */ : undefined,

	/**
	 * Member: FlexJSTest.model
	 * @type {models.MyModel}
	 */
	model /* : MyModel */ : undefined
});


/**
 * Member: FlexJSTest.prototype._CLASS
 * @const
 * @type {FlexJSTest}
 */
FlexJSTest.prototype._CLASS = FlexJSTest;


/**
 * Member: FlexJSTest._PACKAGE
 * @const
 * @type {FlexJSTest}
 */
FlexJSTest._PACKAGE = adobe.globals;


/**
 * Member: FlexJSTest._NAME
 * @const
 * @type {string}
 */
FlexJSTest._NAME = "FlexJSTest";

/**
 * Member: FlexJSTest._FULLNAME
 * @const
 * @type {string}
 */
FlexJSTest._FULLNAME = "FlexJSTest";

/**
 * Member: FlexJSTest._SUPER
 * @const
 * @type {org.apache.flex.core.Application}
 */
FlexJSTest._SUPER = org.apache.flex.core.Application;

/**
 * Member: FlexJSTest._NAMESPACES
 * @const
 * @type {Object}
 */
FlexJSTest._NAMESPACES = {
	"controller::7:FlexJSTest" : true,
	"model::2" : true
}

adobe.classes["FlexJSTest"]  = FlexJSTest;

