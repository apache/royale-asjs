/** @preserve CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:53:04
 */
/**
 * CROSS-COMPILED BY MXMLJSC (329449.1) ON 2012-11-19 11:52:56
 *
 * Class: models.MyModel
 * @constructor
 * @extends flash.events.EventDispatcher
 */
models.MyModel = adobe.extend( "MyModel", flash.events.EventDispatcher, {

	// Constructor
	

	/**
	 * Constructor: models.MyModel()
	 * @constructor
	 * @this {models}
	 */
	init : function()
	{
	var self = this;
		
		self._super(); /* Call to super() was missing in ctor! */
		return self;
	}
,

	/**
	 * Member: models.MyModel._labelText
	 * @private
	 * @type {string}
	 */
	_labelText /* : String */ : undefined,
	

	/**
	 * Method: models.MyModel.get_labelText()
	 * @this {models.MyModel}
	 * @return {string}
	 */
	get_labelText : function() /* : String */
	{
		/** @type {models.MyModel} */
		var self = this;
		return self._labelText;
	},
	

	/**
	 * Method: models.MyModel.set_labelText()
	 * @this {models.MyModel}
	 * @param {string} value
	 */
	set_labelText : function(value /* : String */) /* : void */
	{
		/** @type {models.MyModel} */
		var self = this;
		if((value != self._labelText))
		{
			self._labelText = value;
			self.dispatchEvent(adobe.newObject(flash.events.Event, ["labelTextChanged"]));
		}
	}
});


/**
 * Member: models.MyModel.prototype._CLASS
 * @const
 * @type {models.MyModel}
 */
models.MyModel.prototype._CLASS = models.MyModel;


/**
 * Member: models.MyModel._PACKAGE
 * @const
 * @type {models}
 */
models.MyModel._PACKAGE = models;


/**
 * Member: models.MyModel._NAME
 * @const
 * @type {string}
 */
models.MyModel._NAME = "MyModel";

/**
 * Member: models.MyModel._FULLNAME
 * @const
 * @type {string}
 */
models.MyModel._FULLNAME = "models.MyModel";

/**
 * Member: models.MyModel._SUPER
 * @const
 * @type {flash.events.EventDispatcher}
 */
models.MyModel._SUPER = flash.events.EventDispatcher;

/**
 * Member: models.MyModel._NAMESPACES
 * @const
 * @type {Object}
 */
models.MyModel._NAMESPACES = {
	"_labelText::7:models.MyModel" : true,
	"labelText::2" : true,
	"labelText::2" : true
}

adobe.classes["models.MyModel"]  = models.MyModel;

