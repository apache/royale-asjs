package flex.text
{
COMPILE::AS3
{
	import flash.text.TextField;		
}
COMPILE::JS
{
	import mx.core.IFlexModuleFactory;
	import mx.core.IUITextField;
	import mx.core.UITextFormat;
	import mx.managers.ISystemManager;
	
	import flex.display.DisplayObject;
	import flex.display.DisplayObjectContainer;
	import flex.display.Sprite;
	import flex.display.TopOfDisplayList;
	
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.html.Label;
}

COMPILE::AS3
public class TextField extends flash.text.TextField
{
	public function TextField()
	{
		super();
	}
}

COMPILE::JS
public class TextField extends Label implements IUITextField
{

	private var _alwaysShowSelection:Boolean;
	public function get alwaysShowSelection():Boolean
	{
		return _alwaysShowSelection;
	}
	public function set alwaysShowSelection(value:Boolean):void
	{
		_alwaysShowSelection = value;
		trace("TextField.alwaysShowSelection not implemented");
	}
	
	private var _antiAliasType:String;
	public function get antiAliasType():String
	{
		trace("TextField.antiAliasType not implemented");
		return _antiAliasType;
	}
	public function set antiAliasType(value:String):void
	{
		_antiAliasType = value;
		trace("TextField.antiAliasType not implemented");
	}

	private var _autoSize:String;
	public function get autoSize():String
	{
		trace("TextField.autoSize not implemented");
		return _autoSize;
	}
	public function set autoSize(value:String):void
	{
		_autoSize = value;
		trace("TextField.autoSize not implemented");
	}

	private var _background:Boolean;
	public function get background():Boolean
	{
		return _background;
	}
	public function set background(value:Boolean):void
	{
		_background = value;
		if (!value)
			element.style.backgroundColor = undefined;
		else
			element.style.backgroundColor = "#" + _backgroundColor.toString(16);
	}
	
	private var _backgroundColor:uint;
	public function get backgroundColor():uint
	{
		return _backgroundColor;
	}
	public function set backgroundColor(value:uint):void
	{
		_backgroundColor = value;
		if (_background)
			element.style.backgroundColor = "#" + _backgroundColor.toString(16);
	}

	public function get baselinePosition():Number
	{
		trace("TextField.baselinePosition not implemented");
		return 0;
	}
	
	private var _border:Boolean;
	public function get border():Boolean
	{
		return _border;
	}
	public function set border(value:Boolean):void
	{
		_border = value;
		if (!value)
			element.style.border = "1px none";
		else
			element.style.border = "1px solid";
	}
	
	private var _borderColor:uint;
	public function get borderColor():uint
	{
		return _borderColor;
	}
	public function set borderColor(value:uint):void
	{
		_borderColor = value;
		if (_border)
			element.style.borderColor = "#" + _borderColor.toString(16);
	}
	
	public function get bottomScrollV():int
	{
		trace("TextField.bottomScrollV not implemented");
		return 0;
	}
	
	public function get caretIndex():int
	{
		trace("TextField.caretIndex not implemented");
		return 0;
	}
	
	private var _condenseWhite:Boolean;
	public function get condenseWhite():Boolean
	{
		trace("TextField.condenseWhite not implemented");
		return _condenseWhite;
	}
	public function set condenseWhite(value:Boolean):void
	{
		_condenseWhite = value;
		trace("TextField.condenseWhite not implemented");
	}

	private var _defaultTextFormat:TextFormat;
	public function get defaultTextFormat():TextFormat
	{
		trace("TextField.defaultTextFormat not implemented");
		return _defaultTextFormat;
	}
	public function set defaultTextFormat(value:TextFormat):void
	{
		_defaultTextFormat = value;
		trace("TextField.defaultTextFormat not implemented");
	}
	
	private var _displayAsPassword:Boolean;
	public function get displayAsPassword():Boolean
	{
		return _displayAsPassword;
	}
	/**
	 * @flexjsignorecoercion HTMLInputElement
	 */
	public function set displayAsPassword(value:Boolean):void
	{
		_displayAsPassword = value;
		if (value)
			(element as HTMLInputElement).type = "password";
		else
			(element as HTMLInputElement).type = "input";
	}

	private var _document:Object;
	public function get document():Object
	{
		return _document;
	}
	public function set document(value:Object):void
	{
		_document = value;
	}
	
	private var _doubleClickEnabled:Boolean;
	public function get doubleClickEnabled():Boolean
	{
		trace("TextField.doubleClickEnabled not implemented");
		return _doubleClickEnabled;
	}
	public function set doubleClickEnabled(value:Boolean):void
	{
		_doubleClickEnabled = value;
		trace("TextField.doubleClickEnabled not implemented");
	}
	
	private var _embedFonts:Boolean;
	public function get embedFonts():Boolean
	{
		trace("TextField.embedFonts not implemented");
		return _embedFonts;
	}
	public function set embedFonts(value:Boolean):void
	{
		_embedFonts = value;
		trace("TextField.embedFonts not implemented");
	}
	
	private var _enabled:Boolean;
	public function get enabled():Boolean
	{
		return _enabled;
	}
	public function set enabled(value:Boolean):void
	{
		_enabled = value;
	}
	
	public function get enableIME():Boolean
	{
		trace("TextField.enableIME not implemented");
		return false;
	}
	
	public function get explicitMaxWidth():Number
	{
		trace("TextField.explicitMaxWidth not implemented");
		return 0;
	}
	
	public function get explicitMaxHeight():Number
	{
		trace("TextField.explicitMaxHeight not implemented");
		return 0;
	}
	
	public function get explicitMinHeight():Number
	{
		trace("TextField.explicitMinHeight not implemented");
		return 0;
	}
	
	public function get explicitMinWidth():Number
	{
		trace("TextField.explicitMinWidth not implemented");
		return 0;
	}
	
	private var _focusPane:Sprite;
	public function get focusPane():Sprite
	{
		trace("TextField.focusPane not implemented");
		return _focusPane;
	}
	public function set focusPane(value:Sprite):void
	{
		_focusPane = value;
		trace("TextField.focusPane not implemented");
	}
	
	private var _focusRect:Object;
	public function get focusRect():Object
	{
		trace("TextField.focusRect not implemented");
		return _focusRect;
	}
	public function set focusRect(value:Object):void
	{
		_focusRect = value;
		trace("TextField.focusRect not implemented");
	}

	private var _gridFitType:String;
	public function get gridFitType():String
	{
		trace("TextField.gridFitType not implemented");
		return _gridFitType;
	}
	public function set gridFitType(value:String):void
	{
		_gridFitType = value;
		trace("TextField.gridFitType not implemented");
	}
	
	private var _htmlText:String;
	public function get htmlText():String
	{
		return _htmlText;
	}
	public function set htmlText(value:String):void
	{
		element.innerHTML = _htmlText = value;
	}
	
	private var _ignorePadding:Boolean;
	public function get ignorePadding():Boolean
	{
		trace("TextField.ignorePadding not implemented");
		return _ignorePadding;
	}
	public function set ignorePadding(value:Boolean):void
	{
		_ignorePadding = value;
		trace("TextField.ignorePadding not implemented");
	}
	
	private var _imeMode:String;
	public function get imeMode():String
	{
		return _imeMode;
	}
	public function set imeMode(value:String):void
	{
		_imeMode = value;
	}
	
	private var _includeInLayout:Boolean;
	public function get includeInLayout():Boolean
	{
		trace("TextField.includeInLayout not implemented");
		return _includeInLayout;
	}
	public function set includeInLayout(value:Boolean):void
	{
		_includeInLayout = value;
		trace("TextField.includeInLayout not implemented");
	}

	private var _inheritingStyles:Object;
	public function get inheritingStyles():Object
	{
		trace("TextField.inheritingStyles not implemented");
		return _inheritingStyles;
	}
	public function set inheritingStyles(value:Object):void
	{
		_inheritingStyles = value;
		trace("TextField.inheritingStyles not implemented");
	}

	private var _isPopUp:Boolean;
	public function get isPopUp():Boolean
	{
		trace("TextField.isPopUp not implemented");
		return _isPopUp;
	}
	public function set isPopUp(value:Boolean):void
	{
		_isPopUp = value;
		trace("TextField.isPopUp not implemented");
	}
	
	public function get length():int
	{
		return element.innerText.length;
	}
	
	private var _maxChars:int;
	public function get maxChars():int
	{
		return _maxChars;
	}
	public function set maxChars(value:int):void
	{
		_maxChars = value;
		(element as HTMLInputElement).maxLength = value;
	}
	
	public function get maxHeight():Number
	{
		trace("TextField.maxHeight not implemented");
		return 0;
	}
	
	public function get maxScrollH():int
	{
		trace("TextField.maxScrollH not implemented");
		return 0;
	}
	
	public function get maxScrollV():int
	{
		trace("TextField.maxScrollV not implemented");
		return 0;
	}
	
	public function get maxWidth():Number
	{
		trace("TextField.maxWidth not implemented");
		return 0;
	}
	
	public function get measuredHeight():Number
	{
		trace("TextField.measuredHeight not implemented");
		return 0;
	}
		
	private var _measuredMinHeight:Number;
	public function get measuredMinHeight():Number
	{
		trace("TextField.measuredMinHeight not implemented");
		return _measuredMinHeight;
	}
	public function set measuredMinHeight(value:Number):void
	{
		_measuredMinHeight = value;
		trace("TextField.measuredMinHeight not implemented");
	}
	
	public function get measuredWidth():Number
	{
		trace("TextField.measuredWidth not implemented");
		return 0;
	}
	
	private var _measuredMinWidth:Number;
	public function get measuredMinWidth():Number
	{
		trace("TextField.measuredMinWidth not implemented");
		return _measuredMinWidth;
	}
	public function set measuredMinWidth(value:Number):void
	{
		_measuredMinWidth = value;
		trace("TextField.measuredMinWidth not implemented");
	}
	
	public function get minHeight():Number
	{
		trace("TextField.minHeight not implemented");
		return 0;
	}
	
	public function get minWidth():Number
	{
		trace("TextField.minWidth not implemented");
		return 0;
	}

	private var _moduleFactory:IFlexModuleFactory;
	public function get moduleFactory():IFlexModuleFactory
	{
		trace("TextField.moduleFactory not implemented");
		return _moduleFactory;
	}
	public function set moduleFactory(value:IFlexModuleFactory):void
	{
		_moduleFactory = value;
		trace("TextField.moduleFactory not implemented");
	}
	
	private var _mouseEnabled:Boolean;
	public function get mouseEnabled():Boolean
	{
		trace("TextField.mouseEnabled not implemented");
		return _mouseEnabled;
	}
	public function set mouseEnabled(value:Boolean):void
	{
		_mouseEnabled = value;
		trace("TextField.mouseEnabled not implemented");
	}
		
	private var _mouseWheelEnabled:Boolean;
	public function get mouseWheelEnabled():Boolean
	{
		trace("TextField.mouseWheelEnabled not implemented");
		return _mouseWheelEnabled;
	}
	public function set mouseWheelEnabled(value:Boolean):void
	{
		_mouseWheelEnabled = value;
		trace("TextField.mouseWheelEnabled not implemented");
	}
	
	private var _multiline:Boolean;
	public function get multiline():Boolean
	{
		trace("TextField.multiline not implemented");
		return _multiline;
	}
	public function set multiline(value:Boolean):void
	{
		_multiline = value;
		trace("TextField.multiline not implemented");
	}
	
	private var _name:String;
	public function get name():String
	{
		return _name;
	}
	public function set name(value:String):void
	{
		_name = value;
		element.id = name;
	}
	
	private var _owner:DisplayObjectContainer;
	public function get owner():DisplayObjectContainer
	{
		return _owner;
	}
	public function set owner(value:DisplayObjectContainer):void
	{
		_owner = value;
	}
	
	private var _nestLevel:int;
	public function get nestLevel():int
	{
		return _nestLevel;
	}
	public function set nestLevel(value:int):void
	{
		_nestLevel = value;
	}
	
	private var _nonInheritingStyles:Object;
	public function get nonInheritingStyles():Object
	{
		trace("TextField.nonInheritingStyles not implemented");
		return _nonInheritingStyles;
	}
	public function set nonInheritingStyles(value:Object):void
	{
		_nonInheritingStyles = value;
		trace("TextField.nonInheritingStyles not implemented");
	}
	
	public function get nonZeroTextHeight():Number
	{
		trace("TextField.nonZeroTextHeight not implemented");
		return 0;
	}
	
	public function get numLines():int
	{
		trace("TextField.numLines not implemented");
		return 0;
	}

	private var _restrict:String;
	public function get restrict():String
	{
		trace("TextField.restrict not implemented");
		return _restrict;
	}
	public function set restrict(value:String):void
	{
		_restrict = value;
		trace("TextField.restrict not implemented");
	}
	
	private var _scrollH:int;
	public function get scrollH():int
	{
		trace("TextField.scrollH not implemented");
		return _scrollH;
	}
	public function set scrollH(value:int):void
	{
		_scrollH = value;
		trace("TextField.scrollH not implemented");
	}
	
	private var _scrollV:int;
	public function get scrollV():int
	{
		trace("TextField.scrollV not implemented");
		return _scrollV;
	}
	public function set scrollV(value:int):void
	{
		_scrollV = value;
		trace("TextField.scrollV not implemented");
	}
	
	public function get root():DisplayObject
	{
		trace("TextField.root not implemented");
		return null;
	}
	
	private var _selectable:Boolean;
	public function get selectable():Boolean
	{
		trace("TextField.selectable not implemented");
		return _selectable;
	}
	public function set selectable(value:Boolean):void
	{
		_selectable = value;
		trace("TextField.selectable not implemented");
	}
	
	public function get selectionBeginIndex():int
	{
		trace("TextField.selectionBeginIndex not implemented");
		return 0;
	}
	
	public function get selectionEndIndex():int
	{
		trace("TextField.selectionEndIndex not implemented");
		return 0;
	}

	private var _sharpness:Number;
	public function get sharpness():Number
	{
		trace("TextField.sharpness not implemented");
		return _sharpness;
	}
	public function set sharpness(value:Number):void
	{
		_sharpness = value;
		trace("TextField.sharpness not implemented");
	}
	
	private var _styleName:Object;
	public function get styleName():Object
	{
		return _styleName;
	}
	public function set styleName(value:Object):void
	{
		_styleName = value;
		element.className = styleName.toString();
	}
	
	private var _styleSheet:StyleSheet;
	public function get styleSheet():StyleSheet
	{
		trace("TextField.styleSheet not implemented");
		return _styleSheet;
	}
	public function set styleSheet(value:StyleSheet):void
	{
		_styleSheet = value;
		trace("TextField.styleSheet not implemented");
	}
	
	private var _systemManager:ISystemManager;
	public function get systemManager():ISystemManager
	{
		trace("TextField.systemManager not implemented");
		return _systemManager;
	}
	public function set systemManager(value:ISystemManager):void
	{
		_systemManager = value;
		trace("TextField.systemManager not implemented");
	}
	
	private var _tabEnabled:Boolean;
	public function get tabEnabled():Boolean
	{
		trace("TextField.tabEnabled not implemented");
		return _tabEnabled;
	}
	public function set tabEnabled(value:Boolean):void
	{
		_tabEnabled = value;
		trace("TextField.tabEnabled not implemented");
	}
	
	private var _tabIndex:int;
	public function get tabIndex():int
	{
		trace("TextField.tabIndex not implemented");
		return _tabIndex;
	}
	public function set tabIndex(value:int):void
	{
		_tabIndex = value;
		trace("TextField.tabIndex not implemented");
	}
	
	private var _textColor:uint;
	public function get textColor():uint
	{
		return _textColor;
	}
	public function set textColor(value:uint):void
	{
		_textColor = value;
		element.style.color = "#" + value.toString(16);
	}
	
	public function get textHeight():Number
	{
		return element.offsetHeight;
	}
	
	public function get textWidth():Number
	{
		return element.offsetWidth;
	}
	
	private var _thickness:Number;
	public function get thickness():Number
	{
		trace("TextField.thickness not implemented");
		return _thickness;
	}
	public function set thickness(value:Number):void
	{
		_thickness = value;
		trace("TextField.thickness not implemented");
	}
	
	private var _toolTip:String;
	public function get toolTip():String
	{
		trace("TextField.toolTip not implemented");
		return _toolTip;
	}
	public function set toolTip(value:String):void
	{
		_toolTip = value;
		trace("TextField.toolTip not implemented");
	}
	
	private var _tweeningProperties:Array;
	public function get tweeningProperties():Array
	{
		trace("TextField.tweeningProperties not implemented");
		return _tweeningProperties;
	}
	public function set tweeningProperties(value:Array):void
	{
		_tweeningProperties = value;
		trace("TextField.tweeningProperties not implemented");
	}
	
	public function get topOfDisplayList():TopOfDisplayList
	{
		trace("TextField.topOfDisplayList not implemented");
		return null;
	}
	
	private var _type:String;
	public function get type():String
	{
		trace("TextField.type not implemented");
		return _type;
	}
	public function set type(value:String):void
	{
		_type = value;
		trace("TextField.type not implemented");
	}
	
	private var _useRichTextClipboard:Boolean;
	public function get useRichTextClipboard():Boolean
	{
		trace("TextField.useRichTextClipboard not implemented");
		return _useRichTextClipboard;
	}
	public function set useRichTextClipboard(value:Boolean):void
	{
		_useRichTextClipboard = value;
		trace("TextField.useRichTextClipboard not implemented");
	}
	
	private var _wordWrap:Boolean;
	public function get wordWrap():Boolean
	{
		trace("TextField.wordWrap not implemented");
		return _wordWrap;
	}
	public function set wordWrap(value:Boolean):void
	{
		_wordWrap = value;
		trace("TextField.wordWrap not implemented");
	}
	
	public function appendText(value:String):void
	{
		element.innerText += value;
	}
	
	public function getCharBoundaries(charIndex:int):Rectangle
	{
		trace("TextField.getCharBoundaries not implemented");
		return null;
	}

	public function getCharIndexAtPoint(x:Number, y:Number):int
	{
		trace("TextField.getCharIndexAtPoint not implemented");
		return 0;
	}
	
	public function getExplicitOrMeasuredHeight():Number
	{
		trace("TextField.getExplicitOrMeasuredHeight not implemented");
		return 0;
	}
	
	public function getExplicitOrMeasuredWidth():Number
	{
		trace("TextField.getExplicitOrMeasuredWidth not implemented");
		return 0;
	}
	
	public function getFirstCharInParagraph(index:int):int
	{
		trace("TextField.getFirstCharInParagraph not implemented");
		return 0;
	}
	
	public function getImageReference(id:String):DisplayObject
	{
		trace("TextField.getImageReference not implemented");
		return null;
	}
	
	public function getLineIndexAtPoint(x:Number, y:Number):int
	{
		trace("TextField.getLineIndexAtPoint not implemented");
		return 0;
	}
	
	public function getLineIndexOfChar(index:int):int
	{
		trace("TextField.getLineIndexOfChar not implemented");
		return 0;
	}
	
	public function getLineLength(index:int):int
	{
		trace("TextField.getLineLength not implemented");
		return 0;
	}
	
	public function getLineMetrics(index:int):TextLineMetrics
	{
		trace("TextField.getLineMetrics not implemented");
		return null;
	}
	
	public function getLineOffset(index:int):int
	{
		trace("TextField.getLineOffset not implemented");
		return 0;
	}
	
	public function getLineText(index:int):String
	{
		trace("TextField.getLineText not implemented");
		return null;
	}
	
	public function getParagraphLength(index:int):int
	{
		trace("TextField.getParagraphLength not implemented");
		return 0;
	}
	
	public function getStyle(styleName:String):*
	{
		trace("TextField.getStyle not implemented");
		return undefined;
	}
	
	public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat
	{
		trace("TextField.getTextFormat not implemented");
		return null;
	}
	
	public function getUITextFormat():UITextFormat
	{
		trace("TextField.getUITextFormat not implemented");
		return null;
	}
	
	public function initialize():void
	{
		trace("TextField.initialize not implemented");
	}

	public function invalidateDisplayList():void
	{
		trace("TextField.invalidateDisplayList not implemented");
	}
	
	public function invalidateProperties():void
	{
		trace("TextField.invalidateProperties not implemented");
	}
	
	public function invalidateSize():void
	{
		trace("TextField.invalidateSize not implemented");
	}
	
	public function move(x:Number, y:Number):void
	{
		this.x = x;
		this.y = y;
	}
	
	public function owns(child:DisplayObject):Boolean
	{
		return false;
	}
	
	public function parentChanged(parent:DisplayObjectContainer):void
	{
	}
	
	public function replaceSelectedText(text:String):void
	{
		trace("TextField.replaceSelectedText not implemented");
	}
	
	public function replaceText(begin:int, end:int, text:String):void
	{
		trace("TextField.replaceText not implemented");
	}
	
	public function setActualSize(x:Number, y:Number):void
	{
		setWidthAndHeight(x, y, true);
	}
	
	public function setColor(color:uint):void
	{
		element.style.color = "#" + color.toString(16);
	}

	public function setFocus():void
	{
		element.focus();
	}
	
	public function setSelection(begin:int, end:int):void
	{
		trace("TextField.setSelection not implemented");
	}
	
	public function setTextFormat(format:TextFormat, begin:int = -1, end:int = -1):void
	{
		trace("TextField.setTextFormat not implemented");
	}
	
	public function setVisible(value:Boolean, noEvent:Boolean = false):void
	{
		if (value)
			element.style.display = "inline";
		else
			element.style.display = "none";
	}
	
	public function styleChanged(styleProp:String):void
	{
		trace("TextField.styleChanged not implemented");		
	}
		
	public function truncateToFit(truncationIndicator:String = null):Boolean
	{
		trace("TextField.truncateToFit not implemented");
		return false;
	}
	
	public function validateNow():void
	{
	}
	

}
}