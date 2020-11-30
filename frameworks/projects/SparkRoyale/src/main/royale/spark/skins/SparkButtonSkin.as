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

package spark.skins
{
    import mx.core.IVisualElement;
    import mx.styles.IStyleClient;
    
    import org.apache.royale.core.IChild;
    import spark.components.Group;
    import spark.components.IconPlacement;
    import spark.components.supportClasses.ButtonBase;
    import spark.components.supportClasses.LabelAndIconLayout;
    import spark.core.IDisplayText;
    import spark.layouts.*;
    import spark.primitives.BitmapImage;

    import org.apache.royale.events.Event;
    
    /**
     *  Base class for Spark button skins. Primarily used for
     *  pay-as-you-go icon management.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.5
     */    
    public class SparkButtonSkin extends SparkSkin
    {              
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4.5
         */
        public function SparkButtonSkin()
        {
            super();
        }    
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         * Internal flag used to determine if we should consider icon construction,
         * placement, or layout in commitProperties.
         */  
        private var iconChanged:Boolean = true;
        private var iconPlacementChanged:Boolean = false;
        private var groupPaddingChanged:Boolean = true;
        
        /**
         * @private
         * Our transient icon and label Group.
         */ 
        private var iconGroup:Group;
        private var _icon:Object;
        
        /**
         * @private
         * Saves our label's previous textAlign value.
         */ 
        private var prevTextAlign:String;
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
           
        //----------------------------------
        //  autoIconManagement
        //----------------------------------
        
        private var _autoIconManagement:Boolean = true;
        
        /**
         *  If enabled will automatically construct the necessary
         *  constructs to present and layout an iconDisplay
         *  part.
         * 
         *  @default true
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get autoIconManagement():Boolean
        {
            return _autoIconManagement;
        }
        
        /**
         *  @private
         */
        public function set autoIconManagement(value:Boolean):void
        {
            _autoIconManagement = value;
            invalidateProperties();
        }
        
        //----------------------------------
        //  gap
        //----------------------------------
        
        private var _gap:Number = 6;
        
        /**
         *  Number of pixels between the buttons's icon and
         *  label.
         * 
         *  @default 6
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get gap():Number
        {
            return _gap;
        }
        
        /**
         *  @private
         */
        public function set gap(value:Number):void
        {
            _gap = value;
            groupPaddingChanged = true;
            invalidateProperties();
        }
                
        //----------------------------------
        //  hostComponent
        //----------------------------------
        
        /**
         *  @private
         */
        private var _hostComponent:ButtonBase;
        
        /**
         *  @private 
         */ 
        public function set hostComponent(value:ButtonBase):void
        {
            if (_hostComponent)
                _hostComponent.removeEventListener("contentChange", contentChangeHandler);
            
            _hostComponent = value;
            
            if (value)
                _hostComponent.addEventListener("contentChange", contentChangeHandler);
        }
        
        /**
         *  @private 
         */ 
        public function get hostComponent():ButtonBase
        {
            return _hostComponent;
        }
        
        //----------------------------------
        //  iconDisplay
        //----------------------------------
        
        /**
         * @copy spark.components.supportClasses.ButtonBase#iconDisplay
         */  
        [Bindable]
        public var iconDisplay:BitmapImage;
        
        //----------------------------------
        //  labelDisplay
        //----------------------------------
        
        /**
         * @copy spark.components.supportClasses.ButtonBase#labelDisplay
         */  
        [Bindable]
        public var labelDisplay:IDisplayText;

        
        //----------------------------------
        //  paddingLeft
        //----------------------------------
        
        private var _iconGroupPaddingLeft:Number = 10;
        
        /**
         *  The minimum number of pixels between the buttons's left edge and
         *  the left edge of the icon or label.
         * 
         *  @default 0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4.5
         */
        public function get iconGroupPaddingLeft():Number
        {
            return _iconGroupPaddingLeft;
        }
        
        /**
         *  @private
         */
        public function set iconGroupPaddingLeft(value:Number):void
        {
            _iconGroupPaddingLeft = value;
            groupPaddingChanged = true;
            invalidateProperties();
        }    
        
        //----------------------------------
        //  paddingRight
        //----------------------------------
        
        private var _iconGroupPaddingRight:Number = 10;
        
        [Inspectable(category="General")]
        
        /**
         *  The minimum number of pixels between the buttons's right edge and
         *  the right edge of the icon or label.
         * 
         *  @default 0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get iconGroupPaddingRight():Number
        {
            return _iconGroupPaddingRight;
        }
        
        /**
         *  @private
         */
        public function set iconGroupPaddingRight(value:Number):void
        {
            _iconGroupPaddingRight = value;
            groupPaddingChanged = true;
            invalidateProperties();
        }    
        
        //----------------------------------
        //  paddingTop
        //----------------------------------
        
        private var _iconGroupPaddingTop:Number = 2;
                
        /**
         *  Number of pixels between the buttons's top edge
         *  and the top edge of the first icon or label.
         * 
         *  @default 0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get iconGroupPaddingTop():Number
        {
            return _iconGroupPaddingTop;
        }
        
        /**
         *  @private
         */
        public function set iconGroupPaddingTop(value:Number):void
        {
            _iconGroupPaddingTop = value;
            groupPaddingChanged = true;
            invalidateProperties();
        }    
        
        //----------------------------------
        //  paddingBottom
        //----------------------------------
        
        private var _iconGroupPaddingBottom:Number = 2;
        
        /**
         *  Number of pixels between the buttons's bottom edge
         *  and the bottom edge of the icon or label.
         * 
         *  @default 0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get iconGroupPaddingBottom():Number
        {
            return _iconGroupPaddingBottom;
        }
        
        /**
         *  @private
         */
        public function set iconGroupPaddingBottom(value:Number):void
        {
            _iconGroupPaddingBottom = value;
            groupPaddingChanged = true;
            invalidateProperties();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private 
         */ 
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (!autoIconManagement)
                return;

            if (iconChanged)
            {
                // Make sure the icon has really changed, to avoid doing extra work for 
                // broad stylesheet changes that don't actually change the "icon" style
                var icon:Object = getStyle("icon");
                if (_icon == icon)
                    iconChanged = false;
                else
                    _icon = icon;
            }

            if (!(iconChanged || iconPlacementChanged || groupPaddingChanged))
                return;

            // If we have an icon to render we ensure the necessary
            // parts are created and we configure a helper layout
            // (LabelAndIconLayout) to manage our display parts.
            if (_icon)
            {
                if (iconChanged)
                    constructIconParts(true);

                var layout:LabelAndIconLayout = iconGroup.layout as LabelAndIconLayout;
                
                if (groupPaddingChanged || iconChanged)
                {
                    layout.gap = _gap;
                    layout.paddingLeft = _iconGroupPaddingLeft;
                    layout.paddingRight = _iconGroupPaddingRight;
                    layout.paddingTop = _iconGroupPaddingTop;
                    layout.paddingBottom = _iconGroupPaddingBottom;
                }
                
                if (iconPlacementChanged || iconChanged)
                {
                    layout.iconPlacement = getStyle("iconPlacement");
                    alignLabelForPlacement();
                }
            }
            else
            {
                // If we've previously realized our iconDisplay or iconGroup
                // remove them from the display list as they are no long required.
                constructIconParts(false);
            }
            
            iconChanged = false;
            iconPlacementChanged = false;
            groupPaddingChanged = false;
        }
        
        /**
         *  @private 
         *  Detected changes to iconPlacement and update as necessary.
         */ 
        override public function styleChanged(styleProp:String):void 
        {
            var allStyles:Boolean = !styleProp || styleProp == "styleName";

            if (allStyles || styleProp == "iconPlacement")
            {
                iconPlacementChanged = true;
                invalidateProperties();
            }

            if (allStyles || styleProp == "icon")
            {
                iconChanged = true;
                invalidateProperties();
            }

            super.styleChanged(styleProp);
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private 
         *  Creates our iconDisplay and containing Group
         *  or removes them from the display list and restores
         *  our single labelDisplay.
         */ 
        private function constructIconParts(construct:Boolean):void
        {
            if (!autoIconManagement)
                return;
            
            if (construct)
            {
                if (!iconDisplay)
                    iconDisplay = new BitmapImage();
                
                if (!iconGroup)
                {
                    iconGroup = new Group();
                    iconGroup.left = iconGroup.right = 0;
                    iconGroup.top = iconGroup.bottom = 0;
                    iconGroup.layout = new LabelAndIconLayout();
                }
                
                iconGroup.addElement(iconDisplay as IChild);
                
                iconGroup.clipAndEnableScrolling = true;
                addElement(iconGroup);
                
                if (labelDisplay && IVisualElement(labelDisplay).parent != iconGroup)
                {
                    iconGroup.addElement(IChild(labelDisplay));
                    if (labelDisplay is IStyleClient)
                        prevTextAlign = IStyleClient(labelDisplay).getStyle("textAlign");
                }
            }
            else
            {
                if (iconDisplay && (iconDisplay as IChild).parent)
                    iconGroup.removeElement(iconDisplay as IChild);
                
                if (iconGroup && iconGroup.parent)
                {
                    removeElement(iconGroup);
                    addElement(IChild(labelDisplay));
                    
                    //if (labelDisplay is IStyleClient)
                        //IStyleClient(labelDisplay).setStyle("textAlign", prevTextAlign);
                }
            }
        }
        
        /**
         *  @private
         */
        private function alignLabelForPlacement():void
        {
            if (labelDisplay is IStyleClient)
            {
                var iconPlacement:String = getStyle("iconPlacement");
                
                var alignment:String = 
                    iconPlacement == IconPlacement.LEFT ||
                    iconPlacement == IconPlacement.RIGHT ? "start" : "center"
                
                //IStyleClient(labelDisplay).setStyle("textAlign", alignment);
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event Handlers
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private 
         */ 
        protected function contentChangeHandler(event:Event):void
        {
            // Ensure empty label is not included in layout else
            // a gap between icon and label would be applied.
            if (labelDisplay)
            {
                IVisualElement(labelDisplay).includeInLayout = labelDisplay.text != null 
                    && labelDisplay.text.length;
            }
        }
    }
}
