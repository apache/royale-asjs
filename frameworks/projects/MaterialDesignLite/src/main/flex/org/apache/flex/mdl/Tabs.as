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
package org.apache.flex.mdl
{
	import org.apache.flex.core.ContainerBase;
    import org.apache.flex.core.IChild;
    import org.apache.flex.core.IItemRenderer;
    import org.apache.flex.core.IItemRendererParent;
    import org.apache.flex.core.ILayoutHost;
    import org.apache.flex.core.ILayoutParent;
    import org.apache.flex.core.IParentIUIBase;
    import org.apache.flex.mdl.beads.models.ITabModel;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The Tabs class is a Container component capable of parenting other
	 *  components 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Tabs extends ContainerBase implements IItemRendererParent, ILayoutParent, ILayoutHost
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Tabs()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * @copy org.apache.flex.core.IDataProviderModel#dataProvider
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        public function get dataProvider():Object
        {
            return ITabModel(model).dataProvider;
        }
        public function set dataProvider(value:Object):void
        {
            ITabModel(model).dataProvider = value;
        }

        /**
         * @copy org.apache.flex.mdl.beads.models.ITabModel#tabIdField
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
		public function get tabIdField():String
		{
			return ITabModel(model).tabIdField;
		}

		public function set tabIdField(value:String):void
		{
			ITabModel(model).tabIdField = value;
		}

        /**
         * @copy org.apache.flex.core.IDataProviderModel#labelField
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        public function get labelField():String
        {
            return ITabModel(model).labelField;
        }
        public function set labelField(value:String):void
        {
            ITabModel(model).labelField = value;
        }

        public function set selectedIndex(value:int):void
        {
            ITabModel(model).selectedIndex = value;
        }

        public function getLayoutHost():ILayoutHost
        {
            return this;
        }

        public function get contentView():IParentIUIBase
        {
            return this;
        }

        public function getItemRendererForIndex(index:int):IItemRenderer
        {
            var child:IItemRenderer = getElementAt(index) as IItemRenderer;
            return child;
        }

        public function removeAllElements():void
        {
            while (numElements > 0) {
                var child:IChild = getElementAt(0);
                removeElement(child);
            }
        }

        public function updateAllItemRenderers():void
        {
            //todo: IItemRenderer does not define update function but DataItemRenderer does
            //for(var i:int = 0; i < numElements; i++) {
            //	var child:IItemRenderer = getElementAt(i) as IItemRenderer;
            //	child.update();
            //}
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-tabs mdl-js-tabs";

            element = document.createElement('div') as WrappedHTMLElement;
            
			positioner = element;
            
            // absolute positioned children need a non-null
            // position value in the parent.  It might
            // get set to 'absolute' if the container is
            // also absolutely positioned
            element.flexjs_wrapper = this;

            return element;
        }

		private var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *  Applies ripple click effect. May be used in combination with any other classes
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            _ripple = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-js-ripple-effect", _ripple);
                typeNames = element.className;
            }
        }
	}
}
