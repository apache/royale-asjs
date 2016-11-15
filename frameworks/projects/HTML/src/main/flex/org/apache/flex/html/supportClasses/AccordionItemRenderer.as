package org.apache.flex.html.supportClasses
{
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITitleBarModel;
	import org.apache.flex.html.Panel;
	import org.apache.flex.html.TitleBar;
	import org.apache.flex.html.beads.PanelView;
	
	public class AccordionItemRenderer extends Panel implements ISelectableItemRenderer, ICollapsible
	{
		private var _index:int;
		private var _selected:Boolean;
		
		public function AccordionItemRenderer()
		{
			super();
			percentWidth = 100;
			addBead(new ClippingViewport());
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
			id = "item" + index;
		}

		public function get labelField():String
		{
			return null;
		}
		
		public function set labelField(value:String):void
		{
		}
				
		public function get hovered():Boolean
		{
			return false;
		}
		
		public function set hovered(value:Boolean):void
		{
		}
		
		public function get down():Boolean
		{
			return false;
		}
		
		public function set down(value:Boolean):void
		{
		}
		
		public function get data():Object
		{
			return numElements > 0 ? getElementAt(0) : null;
		}
		
		public function set data(value:Object):void
		{
			while (numElements > 0)
			{
				removeElement(getElementAt(0));
			}
			addElement(value as IChild);
			var dataAsStrand:IStrand = value as IStrand;
			if (dataAsStrand)
			{
				var dataTitleModel:ITitleBarModel = dataAsStrand.getBeadByType(ITitleBarModel) as ITitleBarModel;
				if (dataTitleModel)
				{
					titleBar.model = dataTitleModel;
				}
			}
		}
		
		public function get listData():Object
		{
			return null;
		}
		
		public function set listData(value:Object):void
		{
		}
		
		public function get itemRendererParent():Object
		{
			return null;
		}
		
		public function set itemRendererParent(value:Object):void
		{
		}
		
		public function get titleBar():TitleBar
		{
			return (getBeadByType(PanelView) as PanelView).titleBar;
		}
		
		public function get collapsedHeight():Number
		{
			return titleBar ? titleBar.height : NaN;
		}
		
		public function get collapsedWidth():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
	}
}