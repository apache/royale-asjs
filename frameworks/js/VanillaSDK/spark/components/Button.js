goog.provide('spark.components.Button');

goog.require("goog.dom");
goog.require("goog.events");

goog.require("other.ViewElement");

/**
 * @constructor
 * @extends {other.ViewElement}
 */
spark.components.Button = function() {
	var self = this;
	goog.base(this);
	
	self.element = goog.dom.createDom('button');
}
goog.inherits(spark.components.Button, other.ViewElement);

/**
 * @this {goog.events.EventTarget}
 * @param {string} type
 * @param {Object} listener
 * @param {boolean=} captureOnly
 * @param {Object=} handler
 */
spark.components.Button.prototype.addEventListener = function(type, listener, captureOnly, handler) {
	var self = this;
	goog.events.listen(self.element, type, listener, false, self.owner);
};

/**
 * @type {string}
 */
spark.components.Button.prototype.label;
Object.defineProperty(
	spark.components.Button.prototype, 
	'label', 
	{
		get:function() {
			var self = this;
			return self.element.innerHTML;
		}, 
		set:function(value) {
			var self = this;
			self.element.innerHTML = value;
		}
	}
);
