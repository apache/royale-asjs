////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.html.beads
{
    
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IItemRendererClassFactory;
    import org.apache.flex.core.IItemRendererParent;
    import org.apache.flex.core.ISelectionModel;
    import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.ItemRendererEvent;
	
	[Event(name="itemRendererCreated",type="org.apache.flex.events.ItemRendererEvent")]

    /**
     *  The TextItemRendererFactoryForStringVectorData class is the 
     *  IDataProviderItemRendererMapper for creating 
     *  ITextItemRenderers and assigning them data from an vector
     *  of Strings.  Other IDataProviderItemRendererMapper implementations
     *  assign specific array or vector types to item
     *  renderers expecting those types.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class TextItemRendererFactoryForStringVectorData extends EventDispatcher implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function TextItemRendererFactoryForStringVectorData(target:Object=null)
		{
			super(target);
		}
		
		private var selectionModel:ISelectionModel;
		
		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("beadsAdded",finishSetup);
		}
		
		private function finishSetup(event:Event):void
		{
			selectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			dataGroup = listView.dataGroup;
			selectionModel.addEventListener("dataProviderChange", dataProviderChangeHandler);
			dataProviderChangeHandler(null);
		}
		
        private var _itemRendererFactory:IItemRendererClassFactory;
        
        /**
         *  An IItemRendererClassFactory that should generate ITextItemRenderers
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get itemRendererFactory():IItemRendererClassFactory
        {
            return _itemRendererFactory
        }
        
        /**
         *  @private
         */
        public function set itemRendererFactory(value:IItemRendererClassFactory):void
        {
            _itemRendererFactory = value;
        }
        
        /**
         *  The IItemRendererParent that should parent the ITextItemRenderers
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected var dataGroup:IItemRendererParent;
		
		private function dataProviderChangeHandler(event:Event):void
		{
			var dp:Vector.<String> = selectionModel.dataProvider as Vector.<String>;
			
			dataGroup.removeAllElements();
			
			var n:int = dp.length; 
			for (var i:int = 0; i < n; i++)
			{
				var tf:ITextItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ITextItemRenderer;
                tf.index = i;
                dataGroup.addElement(tf);
				tf.text = dp[i];
				
				var newEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.CREATED);
				newEvent.itemRenderer = tf;
				dispatchEvent(newEvent);
			}			
		}
		
	}
}
