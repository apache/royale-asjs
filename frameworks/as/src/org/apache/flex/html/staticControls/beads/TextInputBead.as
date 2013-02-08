package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextBead;
	import org.apache.flex.core.ITextModel;
	
	public class TextInputBead implements IBead, ITextBead
	{
		public function TextInputBead()
		{
			_textField = new TextField();
			_textField.selectable = true;
			_textField.type = TextFieldType.INPUT;
			_textField.mouseEnabled = true;
			
			// for debug only
			_textField.border = true;
			_textField.borderColor = 0xFF0000;
		}
		private var textModel:ITextModel;
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			textModel = value.getBeadByType(ITextModel) as ITextModel;
			textModel.addEventListener("textChange", textChangeHandler);
			textModel.addEventListener("htmlChange", htmlChangeHandler);
			DisplayObjectContainer(value).addChild(_textField);
			if (textModel.text !== null)
				text = textModel.text;
			if (textModel.html !== null)
				html = textModel.html;
			
			// for input, listen for changes to the _textField and update
			// the model
			_textField.addEventListener(Event.CHANGE, inputChangeHandler);
		}
		
		private function textChangeHandler(event:Event):void
		{
			text = textModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = textModel.html;
		}
		
		private function inputChangeHandler(event:Event):void
		{
			textModel.text = _textField.text;
		}
		
		private var _textField:TextField;
		
		public function get text():String
		{
			return _textField.text;
		}
		public function set text(value:String):void
		{
			_textField.text = value;
		}
		
		public function get html():String
		{
			return _textField.htmlText;
		}
		
		public function set html(value:String):void
		{
			_textField.htmlText = value;
		}
	}
}