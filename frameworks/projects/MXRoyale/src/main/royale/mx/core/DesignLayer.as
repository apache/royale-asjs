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

package mx.core
{
    import mx.events.PropertyChangeEvent;
    import mx.events.PropertyChangeEventKind;
    import org.apache.royale.events.EventDispatcher;
        
    /**
     *  Dispatched by the layer when either <code>effectiveVisibility</code> or 
     *  <code>effectiveAlpha</code> changes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="layerPropertyChange", type="mx.events.PropertyChangeEvent")]
    
    /**
     *  The DesignLayer class represents a visibility group that can be associated
     *  with one or more IVisualElement instances at runtime.  
     * 
     *  DesignLayer instances support a <code>visible</code> and alpha property 
     *  that when set will propagate to the associated layer children.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public class DesignLayer extends EventDispatcher implements IMXMLObject
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function DesignLayer()
        {
            super();
        }
        
        //----------------------------------
        //  id
        //----------------------------------

        /**
         *  @private
         *  Storage for id property.
         */
        private var _id:String;
        
        /**
         *  ID of the layer component. This value becomes the instance name of the 
         *  layer and as such, should not contain any white space or special 
         *  characters. 
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get id():String
        {
            return _id;
        }
        
        /**
         *  @private
         */
        public function set id(value:String):void
        {
            _id = value;
        }
        
        //----------------------------------
        //  parent
        //----------------------------------

        /**
         *  @private
         *  Storage for parent property.
         */
        private var _parent:DesignLayer;
        
        /**
         *  This layer's parent layer. 
         *  
         *  @default null
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get parent():DesignLayer
        {
            return _parent;
        }
        
        /**
         *  @private
         *  Called when a DesignLayer instance is added to or removed from a parent.
         *  Developers typically never need to call this method.
         *
         *  @param p The new parent layer of this DesignLayer instance.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        protected function parentChanged(value:DesignLayer):void
        {
            // We remove our layer from the old parent unless the new
            // parent is null (in this case we know we are invoking this 
            // directly from removeLayer).
            if (_parent && value)
                _parent.removeLayer(this);
            
            _parent = value;
            effectiveVisibilityChanged(_visible);
            effectiveAlphaChanged(_alpha);
        }
        
        //----------------------------------
        //  layerChildren
        //----------------------------------
        
        /**
         * @private
         */  
        private var layerChildren:Array = new Array();
        
        //----------------------------------
        //  visible
        //----------------------------------
        
        /**
         * @private
         */  
        private var _visible:Boolean = true;

        /**
         *  The visibility for this design layer instance.
         *
         *  <p>When updated, the appropriate change event for <code>effectiveVisibility</code> 
         *  will be dispatched to all <code>layerPropertyChange</code> listeners for 
         *  this layer, as well as those of affected descendant layers if any.</p>
         *
         *  @default true
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get visible():Boolean
        {
            return _visible;
        }
 
        /**
         * @private
         */
        public function set visible(value:Boolean):void
        {
            if (_visible != value)
            {
                _visible = value;
                effectiveVisibilityChanged(effectiveVisibility);
            }
        }
        
        //----------------------------------
        //  effectiveVisibility
        //----------------------------------
        
        /**
         *  Returns the effective visibility of this design layer.
         *  This value takes into consideration the  visibility of 
         *  this layer and any ancestor layers.  
         * 
         *  @default true
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */   
        public function get effectiveVisibility():Boolean
        {
            var isVisible:Boolean = _visible;
            var currentLayer:DesignLayer = this;
            while (isVisible && currentLayer.parent)
            {
                currentLayer = currentLayer.parent;
                isVisible = currentLayer.visible;
            }
            return isVisible;
        }
        
        /**
         * @private
         * Used to notify the visual elements associated with this layer that the 
         * effective visiblity has changed.  Dispatches a <code>layerPropertyChange</code> 
         * event with property field set to "effectiveVisibility".
         */  
        protected function effectiveVisibilityChanged(value:Boolean):void
        {
            dispatchEvent(new PropertyChangeEvent("layerPropertyChange", false, 
                false, PropertyChangeEventKind.UPDATE, "effectiveVisibility", 
                !effectiveVisibility, effectiveVisibility));
            
            for (var i:int = 0; i < layerChildren.length; i++)
            {
                var layerChild:DesignLayer = layerChildren[i];
                
                // We only need to notify those layers that are visible, because
                // those that aren't don't really care about their layer parents
                // visibility.
                if (layerChild.visible)
                    layerChild.effectiveVisibilityChanged(value);
            }
        }
        
        //----------------------------------
        //  alpha
        //----------------------------------
        
        /**
         * @private
         */  
        private var _alpha:Number = 1.0;
        
        /**
         *  The alpha for this design layer instance, between 0.0 and 1.0.
         *
         *  <p>When updated, the appropriate change event for <code>effectiveAlpha</code> 
         *  will be dispatched to all <code>layerPropertyChange</code> listeners 
         *  for this layer, as well as those of affected descendant layers if any.</p>
         *
         *  @default 1.0
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get alpha():Number
        {
            return _alpha;
        }
 
        /**
         * @private
         */
        public function set alpha(value:Number):void
        {
            if (_alpha != value)
            {
                var oldAlpha:Number = _alpha;
                _alpha = value;
                effectiveAlphaChanged(oldAlpha);
            }
        }
        
        //----------------------------------
        //  effectiveAlpha
        //----------------------------------
        
        /**
         *  Property that returns the effective alpha, between 0.0 and 1.0,
         *  of this design layer. 
         *  This value multiplies the alpha of this layer by the alpha of 
         *  any ancestor layers.  
         * 
         *  @default 1.0
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */ 
        public function get effectiveAlpha():Number
        {
            var currentAlpha:Number = _alpha;
            var currentLayer:DesignLayer = this;
            while (currentLayer.parent)
            {
                currentLayer = currentLayer.parent;
                currentAlpha = currentAlpha * currentLayer.alpha;
            }
            return currentAlpha;
        }
        
        /**
         * @private
         * Used to notify the visual elements associated with this layer that the 
         * effective alpha has changed.  Dispatches a <code>layerPropertyChange</code> 
         * event with the property field set to "effectiveAlpha".
         */  
        protected function effectiveAlphaChanged(oldAlpha:Number):void
        {
            dispatchEvent(new PropertyChangeEvent("layerPropertyChange", false, 
                false, PropertyChangeEventKind.UPDATE, "effectiveAlpha", 
                oldAlpha, effectiveAlpha));
            
            for (var i:int = 0; i < layerChildren.length; i++)
            {
                var layerChild:DesignLayer = layerChildren[i];
                layerChild.effectiveAlphaChanged(layerChild.alpha);
            }
        }
 
        //----------------------------------
        //  numLayers
        //----------------------------------
        
        /**
         *  The number of DesignLayer children directly parented by this layer.
         *
         *  @default 0
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get numLayers():int
        {
            return layerChildren.length;
        }
        
        //----------------------------------------------------------------------
        //
        //  Methods
        //
        //----------------------------------------------------------------------
        
        /**
         *  Adds a DesignLayer child to this layer.
         *
         *  @param value The layer child to add.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function addLayer(value:DesignLayer):void
        {
            value.parentChanged(this);
            layerChildren.push(value);
        }
        
        /**
         *  Returns the DesignLayer child at the specified index.
         *
         *  <p>Note that the order of DesignLayer children is insignificant.
         *  The <code>getLayerAt</code> method is meant to be used in 
         *  conjunction with numLayers to iterate over the child list.</p> 
         *
         *  @param index The 0-based index of a DesignLayer child.
         *
         *  @return The specified DesignLayer child if index is between
         *  0 and <code>numLayers</code> - 1.  Returns <code>null</code> 
         *  if the index is invalid.
         * 
         *  @see numLayers
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function getLayerAt(index:int):DesignLayer
        {
            return ((index < layerChildren.length) && index >= 0) ? 
                layerChildren[index] : null;
        }
        
        /**
         *  @inheritDoc
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function initialized(document:Object, id:String):void
        {
            this.id = id;
        }

        /**
         *  Removes a DesignLayer child from this layer.
         *
         *  @param value The layer child to remove.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function removeLayer(value:DesignLayer):void
        {
            for (var i:int = 0; i < layerChildren.length; i++)
            {
                if (layerChildren[i] == value)
                {
                    value.parentChanged(null);
                    layerChildren.splice(i,1);
                    return;
                }
            }
        }
         
    }
}
