package flex.text
{

COMPILE::SWF
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

COMPILE::SWF
public class TextField extends flash.text.TextField
{
	public function TextField()
	{
		super();
	}
}

COMPILE::JS
public class TextField extends Label
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
	
	public function get mouseX():Number
	{
		trace("TextField.mouseX not implemented");
		return 0;
	}
	
	public function get mouseY():Number
	{
		trace("TextField.mouseY not implemented");
		return 0;
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
	
	public function get numLines():int
	{
		trace("TextField.numLines not implemented");
		return -1;
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
	
	public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat
	{
		trace("TextField.getTextFormat not implemented");
		return null;
	}
	
	public function replaceSelectedText(text:String):void
	{
		trace("TextField.replaceSelectedText not implemented");
	}
	
	public function replaceText(begin:int, end:int, text:String):void
	{
		trace("TextField.replaceText not implemented");
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
	
	/**
	 * @flexjsignorecoercion flex.display.DisplayObjectContainer
	 */
	override public function get parent():DisplayObjectContainer
	{
		return super.parent as DisplayObjectContainer;
	}

}
}
