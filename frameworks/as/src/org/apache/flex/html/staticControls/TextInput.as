package org.apache.flex.html.staticControls
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.ITextBead;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	
	public class TextInput extends UIBase implements IInitSkin
	{
		public function TextInput()
		{
			super();
		}
		
		public function get text():String
		{
			return ITextModel(model).text;
		}
		public function set text(value:String):void
		{
			ITextModel(model).text = value;
		}
		
		public function get html():String
		{
			return ITextModel(model).html;
		}
		public function set html(value:String):void
		{
			ITextModel(model).html = value;
		}
		
		override public function initModel():void
		{
			if (getBeadByType(ITextModel) == null)
				addBead(new (ValuesManager.valuesImpl.getValue("ITextModel")) as IBead);
		}
		
		public function initSkin():void
		{
			if (getBeadByType(ITextBead) == null)
				addBead(new (ValuesManager.valuesImpl.getValue("ITextInputBead")) as IBead);			
		}
	}
}