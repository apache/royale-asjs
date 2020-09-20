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

package spark.core
{

import flash.display.BlendMode;
import mx.core.UIComponent;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import flash.geom.ColorTransform;
import org.apache.royale.geom.Matrix;
import org.apache.royale.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import flash.geom.Vector3D;

import mx.core.AdvancedLayoutFeatures;
import mx.core.DesignLayer;
import mx.core.FlexSprite;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;
import mx.core.IInvalidating;
import mx.core.ILayoutDirectionElement;
import mx.core.IMXMLObject;
import mx.core.IUIComponent;
import mx.core.IUITextField;
import mx.core.IVisualElement;
import mx.core.LayoutDirection;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;
import mx.filters.BaseFilter;
import mx.filters.IBitmapFilter;
import mx.geom.Transform;
import mx.geom.TransformOffsets;
import mx.graphics.shaderClasses.ColorBurnShader;
import mx.graphics.shaderClasses.ColorDodgeShader;
import mx.graphics.shaderClasses.ColorShader;
import mx.graphics.shaderClasses.ExclusionShader;
import mx.graphics.shaderClasses.HueShader;
import mx.graphics.shaderClasses.LuminosityShader;
import mx.graphics.shaderClasses.SaturationShader;
import mx.graphics.shaderClasses.SoftLightShader;
import mx.managers.ILayoutManagerClient;
import mx.utils.MatrixUtil;
import mx.utils.TransformUtil;

import spark.components.ResizeMode;
import spark.utils.MaskUtil;


use namespace mx_internal;

/**
 *  The SpriteVisualElement class is a light-weight Sprite-based implemention
 *  of the IVisualElement interface. Spark containers can lay out and render SpriteVisualElement objects.
 *  
 *  <p>If you use ActionScript to add an FXG component to an application, it should be of type SpriteVisualElement.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class SpriteVisualElement extends FlexSprite
    implements IVisualElement, IMXMLObject, IFlexModule
{
    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function SpriteVisualElement()
    {
        super();
        measure();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    // When changing these constants, make sure you change
    // the constants with the same name in UIComponent
    private static const DEFAULT_MAX_WIDTH:Number = 10000;
    private static const DEFAULT_MAX_HEIGHT:Number = 10000;

    /**
     *  @private
     *  Flag that signifies this SVE is nested and thus should search for an
     *  SVE ancestor at an arbitrary depth to report changes such as
     *  invalidating size.
     */
    mx_internal var nestedSpriteVisualElement:Boolean;

    /**
     *  @private
     *  Storage for the original size of the graphic. Initialized in the c-tor.
     */
    private var naturalWidth:Number;
    private var naturalHeight:Number;

    /**
     *  @private
     *  Storage for advanced layout and transform properties.
     */
    private var _layoutFeatures:AdvancedLayoutFeatures;

    /**
     *  @private
     *  When true, the transform on this component consists only of translation.
     *  Otherwise, it may be arbitrarily complex.
     */
    private var hasDeltaIdentityTransform:Boolean = true;

    /**
     *  @private
     *  Storage for the modified Transform object that can dispatch
     *  change events correctly.
     */
    private var _transform:flash.geom.Transform;

    /**
     *  @private
     *  Initializes the implementation and storage of some of the less
     *  frequently used advanced layout features of a component.
     *  Call this function before attempting to use any of the
     *  features implemented by the AdvancedLayoutFeatures object.
     */
    private function initAdvancedLayoutFeatures():AdvancedLayoutFeatures
    {
        var features:AdvancedLayoutFeatures = new AdvancedLayoutFeatures();

        hasDeltaIdentityTransform = false;

        features.layoutScaleX = scaleX;
        features.layoutScaleY = scaleY;
        features.layoutScaleZ = scaleZ;
        features.layoutRotationX = rotationX;
        features.layoutRotationY = rotationY;
        features.layoutRotationZ = rotation;
        features.layoutX = x;
        features.layoutY = y;
        features.layoutZ = z;
        features.layoutWidth = _width;  // for the mirror transform     

        // Initialize the internal variable last,
        // since the transform getters depend on it.
        _layoutFeatures = features;

        invalidateTransform();
        return features;
    }

    /**
     *  @private
     *  Makes sure that the computed matrix will be committed.
     */
    private function invalidateTransform():void
    {
        if (_layoutFeatures && _layoutFeatures.updatePending == false)
        {
            _layoutFeatures.updatePending = true;
            applyComputedMatrix();
        }
    }

    /**
     *  @private
     *  Commits the computed matrix built from the combination of the layout
     *  matrix and the transform offsets to the flash displayObject's transform.
     */
    private function applyComputedMatrix():void
    {
        _layoutFeatures.updatePending = false;

        if (_layoutFeatures.is3D)
            super.transform.matrix3D = _layoutFeatures.computedMatrix3D;
        else
            super.transform.matrix = _layoutFeatures.computedMatrix;
    }

    /**
     *  @private
     *  Returns the layout matrix, or null if it only consists of translations.
     */
    protected function nonDeltaLayoutMatrix():Matrix
    {
        if (hasDeltaIdentityTransform)
            return null;
        if (_layoutFeatures != null)
        {
            return _layoutFeatures.layoutMatrix;
        }
        else
        {
            // Lose scale.
            // if scale is actually set (and it's not just our "secret scale"), then
            // layoutFeatures wont' be null and we won't be down here
            return MatrixUtil.composeMatrix(x, y, 1, 1, rotation, 0, 0);
        }
    }

    /**
     *  @private
     *  Resizes the sprite to the specified pre-transform size
     */
    private function setActualSize(width:Number, height:Number):void
    {
        if ((_width != width)  && _layoutFeatures)
        {
            _layoutFeatures.layoutWidth = width;
            invalidateTransform();
        }
            
        _width = width;
        _height = height;

        if (resizeMode == ResizeMode.NO_SCALE)
        {
            // Set the internal scale to 1
            if (_layoutFeatures)
            {
                _layoutFeatures.stretchX = 1;
                _layoutFeatures.stretchY = 1;
                invalidateTransform();
            }
        }
        else
        {
            // Scale from the measured size to the layout size
            var measuredWidth:Number = isNaN(_viewWidth) ? naturalWidth : _viewWidth;
            var measuredHeight:Number = isNaN(_viewHeight) ? naturalHeight : _viewHeight;

            var sx:Number = measuredWidth != 0 ? _width / measuredWidth : 1;
            var sy:Number = measuredHeight != 0 ? _height / measuredHeight : 1;

            if (sx != 1 || sy != 1 || _layoutFeatures)
            {
                if (_layoutFeatures == null)
                    initAdvancedLayoutFeatures();

                _layoutFeatures.stretchX = sx;
                _layoutFeatures.stretchY = sy;
                invalidateTransform();
            }
        }
    }

    /**
     *  @private
     *  Moves the sprite to the specified position, doesn't invalidate parent.
     */
    private function move(x:Number, y:Number):void
    {
        if (_layoutFeatures == null)
        {
            super.x = x;
            super.y = y;
        }
        else
        {
            _layoutFeatures.layoutX = x;
            _layoutFeatures.layoutY = y;
            invalidateTransform();
        }
    }

    /**
     *  @private
     *  Measures the naturalWidth and naturalHeight of the container
     */
    private function measure():void
    {
        var bounds:Rectangle = getBounds(this);
        naturalWidth = Math.max(0, bounds.right);
        naturalHeight = Math.max(0, bounds.bottom);

        // If no explicit size has been set, then update the actual size here.
        // In cases where the FXG is included in a layout, the layout will
        // update the size afterwards because we will invalidate the parent.
        if (isNaN(_explicitWidth))
            _width = naturalWidth;
        
        if (isNaN(_explicitHeight))
            _height = naturalHeight;
    }

    /**
     *  @private
     *  Causes to re-measure the natural width/height
     *  if size changes, parent size is invalidated as well.
     */
    protected function invalidateSize():void
    {
        var curWidth:Number = naturalWidth;
        var curHeight:Number = naturalHeight;

        measure();

        if (curWidth != naturalWidth || curHeight != naturalHeight)
        {
            var parent:DisplayObjectContainer = this.parent;

            // Search for an ancestor SpriteVisualElement to inform them that
            // they need to re-measure as their size has been invalidated.
            while (nestedSpriteVisualElement)
            {
                if (parent is SpriteVisualElement || parent == null || parent.parent == null)
                {
                    break;
                }
                else
                {
                    parent = parent.parent;
                }
            }

            if (parent is SpriteVisualElement)
                SpriteVisualElement(parent).invalidateSize();
            else
                invalidateParentSizeAndDisplayList();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  postLayoutTransformOffsets
    //----------------------------------

    /**
     *  @copy mx.core.IVisualElement#postLayoutTransformOffsets
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get postLayoutTransformOffsets():TransformOffsets
    {
        return (_layoutFeatures == null)?
            null :
            _layoutFeatures.postLayoutTransformOffsets;
    }

    /**
     * @private
     */
    public function set postLayoutTransformOffsets(value:TransformOffsets):void
    {
        if (value != null && _layoutFeatures == null)
            initAdvancedLayoutFeatures();

        if (_layoutFeatures.postLayoutTransformOffsets != null)
            _layoutFeatures.postLayoutTransformOffsets.removeEventListener
                (Event.CHANGE,transformOffsetsChangedHandler);
        _layoutFeatures.postLayoutTransformOffsets = value;
        if (_layoutFeatures.postLayoutTransformOffsets != null)
            _layoutFeatures.postLayoutTransformOffsets.addEventListener
                (Event.CHANGE,transformOffsetsChangedHandler);
    }

    //----------------------------------
    //  alpha
    //----------------------------------

    /**
     *  @private
     *  Storage for the alpha property.
     */
    private var _alpha:Number = 1.0;
    private var _effectiveAlpha:Number = 1.0;

    /**
     *  @private
     */
    override public function get alpha():Number
    {
        // Here we roundtrip alpha in the same manner as the
        // player (purposely introducing a rounding error).
        return int(_alpha * 256.0) / 256.0;
    }

    /**
     *  @private
     */
    override public function set alpha(value:Number):void
    {
        if (_alpha != value)
        {
            _alpha = value;

            if (designLayer)
                value = value * designLayer.effectiveAlpha;

            super.alpha = value;

            if (_blendMode == "auto")
            {
                // If alpha changes from an opaque/transparent (1/0) and
                // translucent (0 < value < 1) then change the default
                // blendMode accordingly
                if ((value > 0 && value < 1) && (_effectiveAlpha == 0 || _effectiveAlpha == 1))
                {
                     super.blendMode = BlendMode.LAYER;
                }
                else if ((value == 0 || value == 1) && (_effectiveAlpha > 0 && _effectiveAlpha < 1))
                {
                    super.blendMode = BlendMode.NORMAL;
                }
            }

            _effectiveAlpha = value;
        }
    }

    //----------------------------------
    //  baseline
    //----------------------------------

    /**
     *  @private
     *  Storage for the baseline property.
     */
    private var _baseline:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get baseline():Object
    {
        return _baseline;
    }

    /**
     *  @private
     */
    public function set baseline(value:Object):void
    {
        if (_baseline == value)
            return;

        _baseline = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  baselinePosition
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get baselinePosition():Number
    {
        return 0;
    }

    //----------------------------------
    //  blendMode
    //----------------------------------

    /**
     *  @private
     *  Storage for the blendMode property.
     */
    private var _blendMode:String = "auto"; 

    [Inspectable(category="General", enumeration="auto,add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity", defaultValue="auto")]
    /**
     *  A value from the BlendMode class that specifies which blend mode to use. 
     * 
     *  @default auto
     * 
     *  @see flash.display.DisplayObject#blendMode
     *  @see flash.display.BlendMode
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function get blendMode():String
    {
        return _blendMode;
    }

    /**
     *  @private
     */
    override public function set blendMode(value:String):void
    {
        if (value == _blendMode)
            return;

        _blendMode = value;

        // Look for AIM blendModes which are not supported by DisplayObject's
        // blendMode natively and require setting a custom blendShader. 
        if (value == "color")
        {
            blendShader = new ColorShader();
        }
        else if (value == "colordodge")
        {
            blendShader = new ColorDodgeShader();
        }
        else if (value == "colorburn")
        {
            blendShader = new ColorBurnShader();
        }
        else if (value == "exclusion")
        {
            blendShader = new ExclusionShader();
        }
        else if (value == "hue")
        {
            blendShader = new HueShader();
        }
        else if (value == "luminosity")
        {
            blendShader = new LuminosityShader();
        }
        else if (value == "saturation")
        {
            blendShader = new SaturationShader();
        }
        else if (value == "softlight")
        {
            blendShader = new SoftLightShader();
        }
        else if (value == "auto")
        {
            if (alpha == 0 || alpha == 1) 
                super.blendMode = BlendMode.NORMAL;
            else
                super.blendMode = BlendMode.LAYER;
        }   
        else
        {
            super.blendMode = value;
        }
    }

    //----------------------------------
    //  bottom
    //----------------------------------

    /**
     *  @private
     *  Storage for the bottom property.
     */
    private var _bottom:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get bottom():Object
    {
        return _bottom;
    }

    /**
     *  @private
     */
    public function set bottom(value:Object):void
    {
        if (_bottom == value)
            return;

        _bottom = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  filters
    //----------------------------------

    /**
     *  @private
     *  Storage for the filters property.
     */
    private var _filters:Array;

    /**
     *  @private
     */
    override public function get filters():Array
    {
        return _filters ? _filters : super.filters;
    }

    /**
     *  @private
     */
    override public function set filters(value:Array):void
    {
        var n:int;
        var i:int;
        var e:IEventDispatcher;

        if (_filters)
        {
            n = _filters.length;
            for (i = 0; i < n; i++)
            {
                e = _filters[i] as IEventDispatcher;
                if (e)
                    e.removeEventListener(BaseFilter.CHANGE, filterChangeHandler);
            }
        }

        _filters = value;

        var clonedFilters:Array = [];
        if (_filters)
        {
            n = _filters.length;
            for (i = 0; i < n; i++)
            {
                if (_filters[i] is IBitmapFilter)
                {
                    e = _filters[i] as IEventDispatcher;
                    if (e)
                        e.addEventListener(BaseFilter.CHANGE, filterChangeHandler);
                    clonedFilters.push(IBitmapFilter(_filters[i]).clone());
                }
                else
                {
                    clonedFilters.push(_filters[i]);
                }
            }
        }

        super.filters = clonedFilters;
    }

    //----------------------------------
    //  height
    //----------------------------------

    private var _explicitHeight:Number = NaN;    // The height explicitly set by the user
    private var _height:Number = 0;                 // The height that's set by the layout

    /**
     *  @private
     */
    [PercentProxy("percentHeight")]
    override public function get height():Number
    {
        return _height;
    }

    /**
     *  @private
     */
    override public function set height(value:Number):void
    {
        // Apply to the current actual size
        _height = value;
        setActualSize(_width, _height);

        // Modify the explicit height
        if (_explicitHeight == value)
            return;

        _explicitHeight = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  minHeight
    //----------------------------------
    
    /**
     *  @private
     *
     *  The minimum height explicitly set by the user.
     */
    private var _explicitMinHeight:Number = NaN;
    
    /**
     *  @private
     */
    public function get minHeight():Number
    {
        if (!isNaN(_explicitMinHeight))
            return _explicitMinHeight;
        return resizeMode == ResizeMode.SCALE ? 0 : preferredHeight;
    }
    
    /**
     *  @private
     */
    public function set minHeight(value:Number):void
    {
        if (_explicitMinHeight == value)
            return;
        _explicitMinHeight = value;
        invalidateParentSizeAndDisplayList();
    }
    
    //----------------------------------
    //  maxHeight
    //----------------------------------
    
    /**
     *  @private
     *
     *  The maximum height explicitly set by the user.
     */
    private var _explicitMaxHeight:Number = NaN;
    
    /**
     *  @private
     */
    public function get maxHeight():Number
    {
        if (!isNaN(_explicitMaxHeight))
            return _explicitMaxHeight;
        return DEFAULT_MAX_HEIGHT;
    }
    
    /**
     *  @private
     */
    public function set maxHeight(value:Number):void
    {
        if (_explicitMaxHeight == value)
            return;
        _explicitMaxHeight = value;
        invalidateParentSizeAndDisplayList();
    }
    
    //----------------------------------
    //  horizontalCenter
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalCenter property.
     */
    private var _horizontalCenter:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get horizontalCenter():Object
    {
        return _horizontalCenter;
    }

    /**
     *  @private
     */
    public function set horizontalCenter(value:Object):void
    {
        if (_horizontalCenter == value)
            return;

        _horizontalCenter = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  includeInLayout
    //----------------------------------

    /**
     *  @private
     *  Storage for the includeInLayout property.
     */
    private var _includeInLayout:Boolean = true;

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  @copy mx.core.UIComponent#includeInLayout
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get includeInLayout():Boolean
    {
        return _includeInLayout;
    }

    /**
     *  @private
     */
    public function set includeInLayout(value:Boolean):void
    {
        if (_includeInLayout == value)
            return;

        _includeInLayout = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  depth
    //----------------------------------

    /**
     *  @private
     *  Storage for the depth property.
     */
    private var _depth:Number = 0;

    /**
     *  @copy spark.primitives.supportClasses.GraphicElement#depth
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get depth():Number
    {
        return _depth;
    }

    /**
     *  @private
     */
    public function set depth(value:Number):void
    {
        if (value == _depth)
            return;

        _depth = value;
        if (parent != null && "invalidateLayering" in parent && parent["invalidateLayering"] is Function)
            parent["invalidateLayering"]();
    }

    //----------------------------------
    //  left
    //----------------------------------

    /**
     *  @private
     *  Storage for the left property.
     */
    private var _left:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get left():Object
    {
        return _left;
    }

    /**
     *  @private
     */
    public function set left(value:Object):void
    {
        if (_left == value)
            return;

        _left = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  id
    //----------------------------------

    /**
     *  @private
     *  Storage for the id property.
     */
    private var _id:String;

    /**
     *  The identity of the component. 
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
    //  luminosityInvert
    //----------------------------------

    /**
     *  @private
     *  Storage for the luminosityInvert property.
     */
    private var _luminosityInvert:Boolean = false; 

    [Inspectable(category="General", enumeration="true,false", defaultValue="false")]
    /**
     *  @copy spark.primitives.supportClasses.GraphicElement#luminosityInvert
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get luminosityInvert():Boolean
    {
        return _luminosityInvert;
    }

    /**
     *  @private
     */
    public function set luminosityInvert(value:Boolean):void
    {
        _luminosityInvert = value;
    }

    //----------------------------------
    //  luminosityClip
    //----------------------------------

    /**
     *  @private
     *  Storage for the luminosityClip property.
     */
    private var _luminosityClip:Boolean = false; 

    [Inspectable(category="General", enumeration="true,false", defaultValue="false")]
    /**
     *  @copy spark.primitives.supportClasses.GraphicElement#luminosityClip
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get luminosityClip():Boolean
    {
        return _luminosityClip;
    }

    /**
     *  @private
     */
    public function set luminosityClip(value:Boolean):void
    {
        _luminosityClip = value;
    }

 

    //----------------------------------
    //  moduleFactory
    //----------------------------------

    /**
     *  @private
     *  Storage for the moduleFactory property.
     */
    private var _moduleFactory:IFlexModuleFactory;

    [Inspectable(environment="none")]

    /**
     *  A module factory is used as context for using embeded fonts and for
     *  finding the style manager that controls the styles for this
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    public function get moduleFactory():IFlexModuleFactory
    {
        return _moduleFactory;
    }

    /**
     *  @private
     */
    public function set moduleFactory(factory:IFlexModuleFactory):void
    {
        // Update childrens' moduleFactory before updating _moduleFactory,
        // as we compare childrens' old moduleFactory with _moduleFactory.
        setModuleFactoryInChildrenOf(this, factory);

        // Finally update the _moduleFactory
        _moduleFactory = factory;
    }
    
    /**
     *  @private
     *  Set the module factory of DisplayObjects in the specified container. 
     *  The children of container will be iterated over an those that implement
     *  IFlexModule will be set to the value in the factory parameter. Children
     *  that are themselves containers will call this function recursively to
     *  set their children.
     * 
     *  @param container The container whose children to process.
     *  @param factory The module factory to set in a child that implements IFlexModule.
     */
    private function setModuleFactoryInChildrenOf(container:DisplayObjectContainer, factory:IFlexModuleFactory):void
    {
        var n:int = container.numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:DisplayObject = container.getChildAt(i);
            
            if (child is IFlexModule)
            {
                var fmChild:IFlexModule = IFlexModule(child);
                if (fmChild.moduleFactory == null || fmChild.moduleFactory == _moduleFactory)
                {
                    fmChild.moduleFactory = factory;
                }
            }
            else if (child is DisplayObjectContainer)
            {
                // look at this object's children
                setModuleFactoryInChildrenOf(DisplayObjectContainer(child), factory);                       
            }
        }
    }

    //----------------------------------
    //  owner
    //----------------------------------

    /**
     *  @private
     */
    private var _owner:DisplayObjectContainer;

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get owner():DisplayObjectContainer
    {
        return _owner ? _owner : parent;
    }

    public function set owner(value:DisplayObjectContainer):void
    {
        _owner = value;
    }

    //----------------------------------
    //  layer
    //----------------------------------

    /**
     *  @private
     *  Storage for the layer property.
     */
    private var _designLayer:DesignLayer;

    [Inspectable (environment='none')]

    /**
     *  @copy mx.core.IVisualElement#designLayer
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get designLayer():DesignLayer
    {
        return _designLayer;
    }

    /**
     *  @private
     */
    public function set designLayer(value:DesignLayer):void
    {
        if (_designLayer)
            _designLayer.removeEventListener("layerPropertyChange", layer_PropertyChange, false);

        _designLayer = value;

        if (_designLayer)
            _designLayer.addEventListener("layerPropertyChange", layer_PropertyChange, false, 0, true);

        super.alpha = _designLayer ? _alpha * _designLayer.effectiveAlpha : _alpha;
        super.visible = _designLayer ? _visible && _designLayer.effectiveVisibility : _visible;
    }

    //----------------------------------
    //  mask
    //----------------------------------
    private var _mask:DisplayObject;
    mx_internal var maskChanged:Boolean;
    
    [Inspectable(category="General")]
    /**
     *  @copy spark.components.supportClasses.GroupBase#mask
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    override public function get mask():DisplayObject
    {
        return _mask;
    }
    
    /**
     *  @private
     */ 
    override public function set mask(value:DisplayObject):void
    {
        if (_mask !== value)
        {
            if (_mask && _mask.parent === this)
            {
                removeChild(_mask);
            }     
            
            _mask = value;
            maskChanged = true;
            applyMask();           
        }
        super.mask = value;         
    } 
    
    //----------------------------------
    //  maskType
    //----------------------------------
    
    private var _maskType:String = MaskType.CLIP;
    private var maskTypeChanged:Boolean;
    private var originalMaskFilters:Array;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General", enumeration="clip,alpha,luminosity", defaultValue="clip")]
    
    /**
     * @copy spark.components.supportClasses.GroupBase#maskType
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get maskType():String
    {
        return _maskType;
    }
    
    /**
     *  @private
     */
    public function set maskType(value:String):void
    {
        if (_maskType != value)
        {
            _maskType = value;
            maskTypeChanged = true;
            applyMask(); 
        }
    } 
    
    //----------------------------------
    //  percentHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the percentHeight property.
     */
    mx_internal var _percentHeight:Number;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get percentHeight():Number
    {
        return _percentHeight;
    }

    /**
     *  @private
     */
    public function set percentHeight(value:Number):void
    {
        if (_percentHeight == value)
            return;

        _percentHeight = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  percentWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the percentWidth property.
     */
    mx_internal var _percentWidth:Number;

    [Inspectable(category="General")]

    /**
     *  @copy mx.core.UIComponent#percentWidth
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get percentWidth():Number
    {
        return _percentWidth;
    }

    /**
     *  @private
     */
    public function set percentWidth(value:Number):void
    {
        if (_percentWidth == value)
            return;

        _percentWidth = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  right
    //----------------------------------

    /**
     *  @private
     *  Storage for the right property.
     */
    private var _right:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get right():Object
    {
        return _right;
    }

    /**
     *  @private
     */
    public function set right(value:Object):void
    {
        if (_right == value)
            return;

        _right = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  x
    //----------------------------------

    /**
     *  @private
     */
    override public function get x():Number
    {
        return (_layoutFeatures == null) ? super.x : _layoutFeatures.layoutX;
    }

    /**
     *  @private
     */
    override public function set x(value:Number):void
    {
        if (x == value)
            return;

        move(value, y);
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  y
    //----------------------------------

    /**
     *  @private
     */
    override public function get y():Number
    {
        return (_layoutFeatures == null) ? super.y : _layoutFeatures.layoutY;
    }

    /**
     *  @private
     */
    override public function set y(value:Number):void
    {
        if (y == value)
            return;

        move(x, value);
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  z
    //----------------------------------

    /**
     *  @private
     */
    override public function get z():Number
    {
        return (_layoutFeatures == null) ? super.z : _layoutFeatures.layoutZ;
    }

    /**
     *  @private
     */
    override public function set z(value:Number):void
    {
        if (z == value)
            return;

        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();

        hasDeltaIdentityTransform = false;
        _layoutFeatures.layoutZ = value;

        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  rotation
    //----------------------------------

    /**
     *  @private
     */
    override public function get rotation():Number
    {
        return (_layoutFeatures == null) ? super.rotation : _layoutFeatures.layoutRotationZ;
    }

    /**
     *  @private
     */
    override public function set rotation(value:Number):void
    {
        if (rotation == value)
            return;

        hasDeltaIdentityTransform = false;
        if (_layoutFeatures == null)
            super.rotation = MatrixUtil.clampRotation(value);
        else
            _layoutFeatures.layoutRotationZ = value;

        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  rotationX
    //----------------------------------

    /**
     *  Indicates the x-axis rotation of the DisplayObject instance, in degrees,
     *  from its original orientation relative to the 3D parent container.
     *  Values from 0 to 180 represent clockwise rotation; values from 0 to -180
     *  represent counterclockwise rotation. Values outside this range are added
     *  to or subtracted from 360 to obtain a value within the range.
     *
     *  This property is ignored during calculation by any of Flex's 2D layouts.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function get rotationX():Number
    {
        return (_layoutFeatures == null) ? super.rotationX : _layoutFeatures.layoutRotationX;
    }

    /**
     *  @private
     */
    override public function set rotationX(value:Number):void
    {
        if (rotationX == value)
            return;

        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();
        _layoutFeatures.layoutRotationX = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  rotationY
    //----------------------------------

    /**
     *  Indicates the y-axis rotation of the DisplayObject instance, in degrees,
     *  from its original orientation relative to the 3D parent container.
     *  Values from 0 to 180 represent clockwise rotation; values from 0 to -180
     *  represent counterclockwise rotation. Values outside this range are added
     *  to or subtracted from 360 to obtain a value within the range.
     *
     *  This property is ignored during calculation by any of Flex's 2D layouts.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function get rotationY():Number
    {
        return (_layoutFeatures == null) ? super.rotationY : _layoutFeatures.layoutRotationY;
    }

    /**
     *  @private
     */
    override public function set rotationY(value:Number):void
    {
        if (rotationY == value)
            return;

        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();
        _layoutFeatures.layoutRotationY = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  rotationZ
    //----------------------------------

    /**
     *  @private
     */
    override public function get rotationZ():Number
    {
        return rotation;
    }

    /**
     *  @private
     */
    override public function set rotationZ(value:Number):void
    {
        rotation = value;
    }

    //----------------------------------
    //  scaleX
    //----------------------------------

    /**
     *  @private
     */
    override public function get scaleX():Number
    {
        // if it's been set, layoutFeatures won't be null.  Otherwise, return 1 as
        // super.scaleX might be some other value since we change the width/height
        // through scaling
        return (_layoutFeatures == null) ? 1 : _layoutFeatures.layoutScaleX;
    }

    /**
     *  @private
     */
    override public function set scaleX(value:Number):void
    {
        if (value == scaleX)
            return;

        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();

        hasDeltaIdentityTransform = false;
        _layoutFeatures.layoutScaleX = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  scaleY
    //----------------------------------

    /**
     *  @private
     */
    override public function get scaleY():Number
    {
        // if it's been set, layoutFeatures won't be null.  Otherwise, return 1 as
        // super.scaleX might be some other value since we change the width/height
        // through scaling
        return (_layoutFeatures == null) ? 1 : _layoutFeatures.layoutScaleY;
    }

    /**
     *  @private
     */
    override public function set scaleY(value:Number):void
    {
        if (value == scaleY)
            return;

        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();

        hasDeltaIdentityTransform = false;
        _layoutFeatures.layoutScaleY = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  scaleZ
    //----------------------------------

    /**
     *  @private
     */
    override public function get scaleZ():Number
    {
        return (_layoutFeatures == null) ? super.scaleZ : _layoutFeatures.layoutScaleZ;
    }

    /**
     * @private
     */
    override public function set scaleZ(value:Number):void
    {
        if (scaleZ == value)
            return;

        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();

        hasDeltaIdentityTransform = false;
        _layoutFeatures.layoutScaleZ = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  top
    //----------------------------------

    /**
     *  @private
     *  Storage for the top property.
     */
    private var _top:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get top():Object
    {
        return _top;
    }

    /**
     *  @private
     */
    public function set top(value:Object):void
    {
        if (_top == value)
            return;

        _top = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  verticalCenter
    //----------------------------------

    /**
     *  @private
     *  Storage for the verticalCenter property.
     */
    private var _verticalCenter:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get verticalCenter():Object
    {
        return _verticalCenter;
    }

    /**
     *  @private
     */
    public function set verticalCenter(value:Object):void
    {
        if (_verticalCenter == value)
            return;

        _verticalCenter = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  visible
    //----------------------------------

    /**
     *  @private
     *  Storage for the visible property.
     */
    private var _visible:Boolean = true;

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    override public function get visible():Boolean
    {
        return _visible;
    }

    /**
     *  @private
     */
    override public function set visible(value:Boolean):void
    {
        _visible = value;

        if (designLayer && !designLayer.effectiveVisibility)
            value = false;

        if (super.visible == value)
            return;

        super.visible = value;
    }

    //----------------------------------
    //  width
    //----------------------------------

    private var _explicitWidth:Number = NaN;    // The width explicitly set by the user
    private var _width:Number = 0;                // The width that's set by the layout

    /**
     *  @private
     */
    [PercentProxy("percentWidth")]
    override public function get width():Number
    {
        return _width;
    }

    /**
     *  @private
     */
    override public function set width(value:Number):void
    {
        // Apply to the current actual size
        _width = value;
        setActualSize(_width, _height);

        // Modify the explicit width
        if (_explicitWidth == value)
            return;

        _explicitWidth = value;
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  minWidth
    //----------------------------------
    
    /**
     *  @private
     *
     *  The minimum width explicitly set by the user.
     */
    private var _explicitMinWidth:Number = NaN;
    
    /**
     *  @private
     */
    public function get minWidth():Number
    {
        if (!isNaN(_explicitMinWidth))
            return _explicitMinWidth;
        return resizeMode == ResizeMode.SCALE ? 0 : preferredWidth;
    }
    
    /**
     *  @private
     */
    public function set minWidth(value:Number):void
    {
        if (_explicitMinWidth == value)
            return;
        _explicitMinWidth = value;
        invalidateParentSizeAndDisplayList();
    }
    
    //----------------------------------
    //  maxWidth
    //----------------------------------
    
    /**
     *  @private
     *
     *  The maximum width explicitly set by the user.
     */
    private var _explicitMaxWidth:Number = NaN;
    
    /**
     *  @private
     */
    public function get maxWidth():Number
    {
        if (!isNaN(_explicitMaxWidth))
            return _explicitMaxWidth;
        return DEFAULT_MAX_WIDTH;
    }

    /**
     *  @private
     */
    public function set maxWidth(value:Number):void
    {
        if (_explicitMaxWidth == value)
            return;
        _explicitMaxWidth = value;
        invalidateParentSizeAndDisplayList();
    }
    
    //----------------------------------
    //  viewWidth
    //----------------------------------

    private var _viewWidth:Number = NaN;

    /**
     *  @copy spark.primitives.Graphic#viewWidth
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function set viewWidth(value:Number):void
    {
        _viewWidth = value;
    }

    //----------------------------------
    //  viewHeight
    //----------------------------------

    private var _viewHeight:Number = NaN;

    /**
     *  @copy spark.primitives.Graphic#viewHeight
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function set viewHeight(value:Number):void
    {
        _viewHeight = value;
    }

    //----------------------------------
    //  resizeMode
    //----------------------------------

    private var _resizeMode:String = ResizeMode.SCALE;

    /**
     *  @private
     */
    public function get resizeMode():String
    {
        return _resizeMode;
    }

    /**
     *  @private
     */
    public function set resizeMode(value:String):void
    {
        if (_resizeMode == value)
            return;

        _resizeMode = value;

        // When resize mode changes, reapply the current size,
        // so that the correct scale can be calcualted and applied correctly.
        setActualSize(_width, _height);
    }

    //----------------------------------
    //  transform
    //----------------------------------

    /**
     *  @private
     */
    override public function get transform():flash.geom.Transform
    {
        if (_transform == null)
        {
            setTransform(new mx.geom.Transform(this));
        }
        return _transform;
    }

    /**
     * @private
     */
    override public function set transform(value:flash.geom.Transform):void
    {
        var m:Matrix = value.matrix;
        var m3:Matrix3D =  value.matrix3D;
        var ct:ColorTransform = value.colorTransform;
        var pp:PerspectiveProjection = value.perspectiveProjection;

        var mxTransform:mx.geom.Transform = value as mx.geom.Transform;
        if (mxTransform)
        {
            if (!mxTransform.applyMatrix)
                m = null;

            if (!mxTransform.applyMatrix3D)
                m3 = null;
        }

        setTransform(value);

        if (m != null)
            setLayoutMatrix(m.clone(), true /*triggerLayoutPass*/);
        else if (m3 != null)
            setLayoutMatrix3D(m3.clone(), true /*triggerLayoutPass*/);

        super.transform.colorTransform = ct;
        super.transform.perspectiveProjection = pp;
    }

    /**
     *  @private
     */
    private function setTransform(value:flash.geom.Transform):void
    {
        // Clean up the old transform
        var oldTransform:mx.geom.Transform = _transform as mx.geom.Transform;
        if (oldTransform)
            oldTransform.target = null;

        var newTransform:mx.geom.Transform = value as mx.geom.Transform;

        if (newTransform)
            newTransform.target = this;

        _transform = value;
    }

    /**
     *  @private
     */
    mx_internal function get $transform():flash.geom.Transform
    {
        return super.transform;
    }

    /**
     *  Sets the x coordinate for the transform center of the component.
     *
     *  <p>When this object is the target of a Spark transform effect,
     *  you can override this property by setting
     *  the <code>AnimateTransform.autoCenterTransform</code> property.
     *  If <code>autoCenterTransform</code> is <code>false</code>, the transform
     *  center is determined by the <code>transformX</code>,
     *  <code>transformY</code>, and <code>transformZ</code> properties
     *  of the effect target.
     *  If <code>autoCenterTransform</code> is <code>true</code>,
     *  the effect occurs around the center of the target,
     *  <code>(width/2, height/2)</code>.</p>
     *
     *  <p>Setting this property on the Spark effect class
     *  overrides the setting on the target object.</p>
     *
     *  @see spark.effects.AnimateTransform#autoCenterTransform
     *  @see spark.effects.AnimateTransform#transformX
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get transformX():Number
    {
        return (_layoutFeatures == null)? 0 : _layoutFeatures.transformX;
    }

    /**
     *  @private
     */
    public function set transformX(value:Number):void
    {
        if (transformX == value)
            return;
        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();
        _layoutFeatures.transformX = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    /**
     *  Sets the y coordinate for the transform center of the component.
     *
     *  <p>When this object is the target of a Spark transform effect,
     *  you can override this property by setting
     *  the <code>AnimateTransform.autoCenterTransform</code> property.
     *  If <code>autoCenterTransform</code> is <code>false</code>, the transform
     *  center is determined by the <code>transformY</code>,
     *  <code>transformY</code>, and <code>transformZ</code> properties
     *  of the effect target.
     *  If <code>autoCenterTransform</code> is <code>true</code>,
     *  the effect occurs around the center of the target,
     *  <code>(width/2, height/2)</code>.</p>
     *
     *  <p>Setting this property on the Spark effect class
     *  overrides the setting on the target object.</p>
     *
     *  @see spark.effects.AnimateTransform#autoCenterTransform
     *  @see spark.effects.AnimateTransform#transformY
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get transformY():Number
    {
        return (_layoutFeatures == null)? 0 : _layoutFeatures.transformY;
    }

    /**
     *  @private
     */
    public function set transformY(value:Number):void
    {
        if (transformY == value)
            return;
        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();
        _layoutFeatures.transformY = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    /**
     *  Sets the z coordinate for the transform center of the component.
     *
     *  <p>When this object is the target of a Spark transform effect,
     *  you can override this property by setting
     *  the <code>AnimateTransform.autoCenterTransform</code> property.
     *  If <code>autoCenterTransform</code> is <code>false</code>, the transform
     *  center is determined by the <code>transformZ</code>,
     *  <code>transformY</code>, and <code>transformZ</code> properties
     *  of the effect target.
     *  If <code>autoCenterTransform</code> is <code>true</code>,
     *  the effect occurs around the center of the target,
     *  <code>(width/2, height/2)</code>.</p>
     *
     *  <p>Setting this property on the Spark effect class
     *  overrides the setting on the target object.</p>
     *
     *  @see spark.effects.AnimateTransform#autoCenterTransform
     *  @see spark.effects.AnimateTransform#transformZ
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get transformZ():Number
    {
        return (_layoutFeatures == null)? 0 : _layoutFeatures.transformZ;
    }

    /**
     *  @private
     */
    public function set transformZ(value:Number):void
    {
        if (transformZ == value)
            return;
        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();
        _layoutFeatures.transformZ = value;
        invalidateTransform();
        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  layoutDirection
    //----------------------------------
    
    private var _layoutDirection:String = null;
    
    [Inspectable(category="General", enumeration="ltr,rtl")]
    
    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get layoutDirection():String
    {
        if (_layoutDirection != null)
            return _layoutDirection;
        
        const parentElt:ILayoutDirectionElement = parent as ILayoutDirectionElement;
        return (parentElt) ? parentElt.layoutDirection : LayoutDirection.LTR;   
    }
    
    /**
     *  @private
     */
    public function set layoutDirection(value:String):void
    {
        if (_layoutDirection == value)
            return;
        
        _layoutDirection = value;
        invalidateLayoutDirection();
    }
    
    /**
     * @inheritDoc 
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function invalidateLayoutDirection():void
    {
        const parentElt:ILayoutDirectionElement = parent as ILayoutDirectionElement;
        if (!parentElt)
            return;
        
        // If this element's layoutDirection doesn't match its parent's, then
        // set the _layoutFeatures.mirror flag.  Similarly, if mirroring isn't 
        // required, then clear the _layoutFeatures.mirror flag.
        
        const mirror:Boolean = (parentElt.layoutDirection != null && _layoutDirection != null) 
            && (_layoutDirection != parentElt.layoutDirection);
        
        if ((_layoutFeatures) ? (mirror != _layoutFeatures.mirror) : mirror)
        {
            if (_layoutFeatures == null)
                initAdvancedLayoutFeatures();
            _layoutFeatures.mirror = mirror;
            invalidateTransform();
            invalidateParentSizeAndDisplayList();            
        }
    }        
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function addChild(child:DisplayObject):DisplayObject
    {
        // Do anything that needs to be done before the child is added.
        // In the case of SVE..we just need to deal with text UIComponents
        // and setting them up because this is a "static" object
        addingChild(child);

        super.addChild(child);

        childAdded(child);

        return child;
    }

    /**
     *  @private
     */
    override public function addChildAt(child:DisplayObject,
                                        index:int):DisplayObject
    {
        addingChild(child);

        super.addChildAt(child, index);

        childAdded(child);

        return child;
    }

    /**
     *  @private
     */
    mx_internal function addingChild(child:DisplayObject):void
    {
        // for SVE, we just need to set up the parent and the nestLevel
        if (child is IUIComponent)
            IUIComponent(child).parentChanged(this);

        // Set the nestLevel to "2" since we don't really have a
        // concept of nestLevel for SVE
        if (child is ILayoutManagerClient)
            ILayoutManagerClient(child).nestLevel = 2;
        else if (child is IUITextField)
            IUITextField(child).nestLevel = 2;
    }

    /**
     *  @private
     */
    mx_internal function childAdded(child:DisplayObject):void
    {
        // for SVE, we just need call initialize()
        if (child is IUIComponent)
        {
            IUIComponent(child).initialize();
        }
    }
    
    /**
     *  @private 
     */ 
    override public function globalToLocal(point:Point):Point
    {
        if (resizeMode == ResizeMode.SCALE && _layoutFeatures != null)
        {
            // If resize mode is scale, then globalToLocal shouldn't account for 
            // stretchX/Y
            var sX:Number = _layoutFeatures.stretchX;
            var sY:Number = _layoutFeatures.stretchY;
            _layoutFeatures.stretchX = 1;
            _layoutFeatures.stretchY = 1;
            applyComputedMatrix();
            
            var p:Point = super.globalToLocal(point);
            
            // Restore stretch
            _layoutFeatures.stretchX = sX;
            _layoutFeatures.stretchY = sY;
            applyComputedMatrix();
            
            return p;
        }
        else
        {
            return super.globalToLocal(point);    
        }
    }
    
    /**
     *  @private 
     */ 
    override public function localToGlobal(point:Point):Point
    {
        if (resizeMode == ResizeMode.SCALE && _layoutFeatures != null)
        {
            // If resize mode is scale, then localToGlobal shouldn't account for 
            // stretchX/Y
            var sX:Number = _layoutFeatures.stretchX;
            var sY:Number = _layoutFeatures.stretchY;
            _layoutFeatures.stretchX = 1;
            _layoutFeatures.stretchY = 1;
            applyComputedMatrix();
            
            var p:Point = super.localToGlobal(point);
            
            // Restore stretch
            _layoutFeatures.stretchX = sX;
            _layoutFeatures.stretchY = sY;
            applyComputedMatrix();
            
            return p;
        }
        else
        {
            return super.localToGlobal(point);    
        }
    }
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Called automatically by the MXML compiler when the SpriteVisualElement
     *  is created using an MXML tag.
     *  If you create the SpriteVisualElement through ActionScript you 
     *  must set the <code>id</code> property manually.
     *
     *  @param document The MXML document containing this SpriteVisualElement (not used).
     *  @param id The MXML id for this SpriteVisualElement.
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
     * @private
     */
    private function transformOffsetsChangedHandler(e:Event):void
    {
        invalidateTransform();
    }

    private function get preferredWidth():Number
    {
        if (!isNaN(_explicitWidth))
            return _explicitWidth;
        if (!isNaN(_viewWidth))
            return _viewWidth;
        return naturalWidth;
    }

    private function get preferredHeight():Number
    {
        if (!isNaN(_explicitHeight))
            return _explicitHeight;
        if (!isNaN(_viewHeight))
            return _viewHeight;
        return naturalHeight;
    }

    /**
     *  @private
     */
    protected function layer_PropertyChange(event:PropertyChangeEvent):void
    {
        switch (event.property)
        {
            case "effectiveVisibility":
            {
                var newValue:Boolean = (event.newValue && _visible);
                if (newValue != super.visible)
                    super.visible = newValue;
                break;
            }
            case "effectiveAlpha":
            {
                var newAlpha:Number = Number(event.newValue) * _alpha;
                if (newAlpha != super.alpha)
                    super.alpha = newAlpha;
                break;
            }
        }
    }

    /**
     *  @private
     */
    private function filterChangeHandler(event:Event):void
    {
        filters = _filters;
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsX(postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = postLayoutTransform ? nonDeltaLayoutMatrix() : null;
        if (!m)
            return x;

        var topLeft:Point = new Point(0, 0);
        MatrixUtil.transformBounds(width, height, m, topLeft);
        return topLeft.x;
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsY(postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = postLayoutTransform ? nonDeltaLayoutMatrix() : null;
        if (!m)
            return y;

        var topLeft:Point = new Point(0, 0);
        MatrixUtil.transformBounds(width, height, m, topLeft);
        return topLeft.y;
    }

    /**
     *  @copy mx.core.ILayoutElement#getLayoutBoundsWidth()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsWidth(postLayoutTransform:Boolean = true):Number
    {
        return transformWidthForLayout(width, height, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsHeight(postLayoutTransform:Boolean = true):Number
    {
        return transformHeightForLayout(width, height, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMaxBoundsWidth(postLayoutTransform:Boolean = true):Number
    {
        return transformWidthForLayout(maxWidth, maxHeight, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMaxBoundsHeight(postLayoutTransform:Boolean = true):Number
    {
        return transformHeightForLayout(maxWidth, maxHeight, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMinBoundsWidth(postLayoutTransform:Boolean = true):Number
    {
        return transformWidthForLayout(minWidth, minHeight, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMinBoundsHeight(postLayoutTransform:Boolean = true):Number
    {
        return transformHeightForLayout(minWidth, minHeight, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getPreferredBoundsWidth(postLayoutTransform:Boolean = true):Number
    {
        return transformWidthForLayout(preferredWidth, preferredHeight, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getPreferredBoundsHeight(postLayoutTransform:Boolean = true):Number
    {
        return transformHeightForLayout(preferredWidth, preferredHeight, postLayoutTransform);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = postLayoutTransform ? nonDeltaLayoutMatrix() : null;
        if (!m)
            return x;

        var topLeft:Point = new Point(0, 0);
        MatrixUtil.transformBounds(preferredWidth, preferredHeight, m, topLeft);
        return topLeft.x;
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = postLayoutTransform ? nonDeltaLayoutMatrix() : null;
        if (!m)
            return y;

        var topLeft:Point = new Point(0, 0);
        MatrixUtil.transformBounds(preferredWidth, preferredHeight, m, topLeft);
        return topLeft.y;
    }

    /**
     *  Invalidates parent size and display list if
     *  this object affects its layout (includeInLayout is true).
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function invalidateParentSizeAndDisplayList():void
    {
        if (!includeInLayout)
            return;

        var p:IInvalidating = parent as IInvalidating;
        if (!p)
            return;

        p.invalidateSize();
        p.invalidateDisplayList();
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setLayoutBoundsPosition(newBoundsX:Number, newBoundsY:Number, postLayoutTransform:Boolean = true):void
    {
        var currentBoundsX:Number = getLayoutBoundsX(postLayoutTransform);
        var currentBoundsY:Number = getLayoutBoundsY(postLayoutTransform);

        var xOffset:Number = newBoundsX - currentBoundsX;
        var yOffset:Number = newBoundsY - currentBoundsY;

        if (xOffset != 0 || yOffset != 0)
            move(x + xOffset, y + yOffset);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setLayoutBoundsSize(width:Number,
                                        height:Number,
                                        postLayoutTransform:Boolean = true):void
    {
        var m:Matrix = postLayoutTransform ? nonDeltaLayoutMatrix() : null;

        if (!m)
        {
            if (isNaN(width))
                width = preferredWidth;
            if (isNaN(height))
                height = preferredHeight;

            setActualSize(width, height);
            return;
        }

        var fitSize:Point = MatrixUtil.fitBounds(width, height, m,
            _explicitWidth,
            _explicitHeight,
            preferredWidth,
            preferredHeight,
            minWidth,
            minHeight,
            maxWidth,
            maxHeight);

        // If we couldn't fit at all, default to the minimum size
        if (!fitSize)
            setActualSize(preferredWidth, preferredHeight);
        else
            setActualSize(fitSize.x, fitSize.y);
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutMatrix():Matrix
    {
        if (_layoutFeatures != null || super.transform.matrix == null)
        {
            // TODO: this is a workaround for a situation in which the
            // object is in 2D, but used to be in 3D and the player has not
            // yet cleaned up the matrices. So the matrix property is null, but
            // the matrix3D property is non-null. layoutFeatures can deal with
            // that situation, so we allocate it here and let it handle it for
            // us. The downside is that we have now allocated layoutFeatures
            // forever and will continue to use it for future situations that
            // might not have required it. Eventually, we should recognize
            // situations when we can de-allocate layoutFeatures and back off
            // to letting the player handle transforms for us.
            if (_layoutFeatures == null)
                initAdvancedLayoutFeatures();

            // esg: _layoutFeatures keeps a single internal copy of the layoutMatrix.
            // since this is an internal class, we don't need to worry about developers
            // accidentally messing with this matrix, _unless_ we hand it out. Instead,
            // we hand out a clone.
            return _layoutFeatures.layoutMatrix.clone();
        }
        else
        {
            // flash also returns copies.
            return super.transform.matrix;
        }
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setLayoutMatrix(value:Matrix, invalidateLayout:Boolean):void
    {
        hasDeltaIdentityTransform = false;
        
        var previousMatrix:Matrix = _layoutFeatures ? 
            _layoutFeatures.layoutMatrix : super.transform.matrix;
        
        if (_layoutFeatures == null)
        {
            // flash will make a copy of this on assignment.
            super.transform.matrix = value;
        }
        else
        {
            // layout features will internally make a copy of this matrix rather than
            // holding onto a reference to it.
            _layoutFeatures.layoutMatrix = value;
            invalidateTransform();
        }
        
        // Early exit if possible. We don't want to invalidate unnecessarily.
        // We need to do the check here, after our new value has been applied
        // because our matrix components are rounded upon being applied to a
        // DisplayObject.
        if (MatrixUtil.isEqual(previousMatrix, _layoutFeatures ? 
            _layoutFeatures.layoutMatrix : super.transform.matrix))
        {    
            return;
        }
        
        if (invalidateLayout)
            invalidateParentSizeAndDisplayList();
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get hasLayoutMatrix3D():Boolean
    {
        return _layoutFeatures ? _layoutFeatures.layoutIs3D : false;
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get is3D():Boolean
    {
        return _layoutFeatures ? _layoutFeatures.is3D : false;
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutMatrix3D():Matrix3D
    {
        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();
        // esg: _layoutFeatures keeps a single internal copy of the layoutMatrix.
        // since this is an internal class, we don't need to worry about developers
        // accidentally messing with this matrix, _unless_ we hand it out. Instead,
        // we hand out a clone.
        return _layoutFeatures.layoutMatrix3D.clone();
    }

    /**
     *  @inheritDoc
     *  
     *  Similar to the <code>layoutMatrix3D</code> property. This property, however, 
     *  does not trigger a layout pass.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setLayoutMatrix3D(value:Matrix3D, invalidateLayout:Boolean):void
    {
        // Early exit if possible. We don't want to invalidate unnecessarily.
        if (_layoutFeatures && MatrixUtil.isEqual3D(_layoutFeatures.layoutMatrix3D, value))
            return;
        
        if (_layoutFeatures == null)
            initAdvancedLayoutFeatures();
        // layout features will internally make a copy of this matrix rather than
        // holding onto a reference to it.
        _layoutFeatures.layoutMatrix3D = value;
        invalidateTransform();

        if (invalidateLayout)
            invalidateParentSizeAndDisplayList();
    }

    /**
     *  @copy mx.core.ILayoutElement#transformAround()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function transformAround(transformCenter:Vector3D,
                                    scale:Vector3D = null,
                                    rotation:Vector3D = null,
                                    translation:Vector3D = null,
                                    postLayoutScale:Vector3D = null,
                                    postLayoutRotation:Vector3D = null,
                                    postLayoutTranslation:Vector3D = null,
                                    invalidateLayout:Boolean = true):void
    {
        // Make sure that no transform setters will trigger parent invalidation.
        // Reset the flag at the end of the method.
        var oldIncludeInLayout:Boolean;
        if (!invalidateLayout)
        {
            oldIncludeInLayout = _includeInLayout;
            _includeInLayout = false;
        }
        
        TransformUtil.transformAround(this,
                                      transformCenter,
                                      scale,
                                      rotation,
                                      translation,
                                      postLayoutScale,
                                      postLayoutRotation,
                                      postLayoutTranslation,
                                      _layoutFeatures,
                                      initAdvancedLayoutFeatures);
        
        if (_layoutFeatures != null)
        {
            invalidateTransform();

            // Will not invalidate parent if we have set _includeInLayout to false
            // in the beginning of the method
            invalidateParentSizeAndDisplayList();
        }
        
        if (!invalidateLayout)
            _includeInLayout = oldIncludeInLayout;
    }

    /**
     *  A utility method to transform a point specified in the local
     *  coordinates of this object to its location in the object's parent's
     *  coordinates. The pre-layout and post-layout result will be set on
     *  the <code>position</code> and <code>postLayoutPosition</code>
     *  parameters, if they are non-null.
     *  
     *  @param localPosition The point to be transformed, specified in the
     *  local coordinates of the object.
     *  @param position A Vector3D point that will hold the pre-layout
     *  result. If null, the parameter is ignored.
     *  @param postLayoutPosition A Vector3D point that will hold the post-layout
     *  result. If null, the parameter is ignored.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function transformPointToParent(localPosition:Vector3D,
                                           position:Vector3D,
                                           postLayoutPosition:Vector3D):void
    {
        TransformUtil.transformPointToParent(this,
                                             localPosition,
                                             position,
                                             postLayoutPosition,
                                             _layoutFeatures);
    }

    /**
     *  Transform the element's size.
     *
     *  <p>This method calculates the bounding box of the graphic element as if the element’s width/height properties were set to the passed in values.
     *  The method returns the width of the bounding box.</p>
     * 
     *  <p>In general, this method is not for use by developers. Instead, you should implement or override the methods defined by the ILayoutElement interface.</p>
     * 
     *  @param width The target pre-transform width.
     *
     *  @param height The target pre-transform height.
     *
     *  @param postLayoutTransform When <code>true</code>, the returned bounding box is around the transformed element in its parent space (the element's transform is applied first).  
     *  
     *  @return Returns the transformed width. Transformation is this element's
     *  layout transformation matrix.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function transformWidthForLayout(width:Number,
                                               height:Number,
                                               postLayoutTransform:Boolean = true):Number
    {
        if (postLayoutTransform)
        {
            var m:Matrix = nonDeltaLayoutMatrix();
            if (m)
                width = MatrixUtil.transformSize(width, height, m).x;
        }

        return width;
    }

    /**
     *  Transform the element's size.
     *
     *  <p>This method calculates the bounding box of the graphic element as if the element’s width/height properties were set to the passed in values.
     *  The method returns the height of the bounding box.</p>
     * 
     *  <p>In general, this method is not for use by developers. Instead, you should implement or override the methods defined by the ILayoutElement interface.</p>
     *  
     *  @param width The target pre-transform width.
     *
     *  @param height The target pre-transform height.
     *
     *  @param postLayoutTransform When <code>true</code>, the returned bounding box is around the transformed element in its parent space (the element's transform is applied first).  
     *  
     *  @return Returns the transformed height. Transformation is this element's
     *  layout transformation matrix.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function transformHeightForLayout(width:Number,
                                                height:Number,
                                                postLayoutTransform:Boolean = true):Number
    {
        if (postLayoutTransform)
        {
            var m:Matrix = nonDeltaLayoutMatrix();
            if (m)
                height = MatrixUtil.transformSize(width, height, m).y;
        }

        return height;
    }
    
    /**
     *  @private 
     */
    private function applyMask():void
    {
        if (maskChanged)
        {
            maskChanged = false;
            if (_mask)
            {
                maskTypeChanged = true;
                
                if (!_mask.parent)
                {
                    // TODO (jszeto): Does this need to be attached to a sibling?
                    addChild(_mask);
                    
                    MaskUtil.applyMask(_mask, null);
                }
            }
        } 
        
        if (maskTypeChanged)    
        {
            maskTypeChanged = false;
            
            if (_mask)
                MaskUtil.applyMaskType(_mask, _maskType, luminosityInvert, luminosityClip, this);
        }     
    }
}
}

