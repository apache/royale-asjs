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

package spark.components
{
/* 
import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle; */

import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
//import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.mx_internal;
//import mx.managers.PopUpManager;
import mx.styles.ISimpleStyleClient;
//import mx.utils.MatrixUtil;
//import mx.utils.PopUpUtil;
import org.apache.royale.events.Event;

use namespace mx_internal;

[DefaultProperty("popUp")]

/**
 *  The PopUpAnchor component is used to position a control that pops up
 *  or drops down, such as a DropDownList component, in layout. Because a popup or drop-down 
 *  control is added to the display list by the PopUpManager, it doesn't normally 
 *  participate in layout. The PopUpAnchor component is a UIComponent that is added to a 
 *  container and is laid out. It is then responsible for sizing and 
 *  positioning the popup or drop-down control relative to itself. 
 *  It has no visual appearance.
 *
 *  <p>The PopUpAnchor control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>0</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *     </table>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:PopUpAnchor&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:PopUpAnchor
 * 
 *    <strong>Properties</strong>
 *    displayPopUp="false"
 *    popUp=""
 *    popUpHeightMatchesAnchorHeight="false"
 *    popUpPosition="topLeft"
 *    popUpWidthMatchesAnchorWidth="false"
 *  /&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 *
 *  @includeExample examples/PopUpAnchorExample.mxml
 */ 
public class PopUpAnchor extends UIComponent
{
    
    /**
     *  Constructor
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
      *  @playerversion AIR 1.5
      *  @productversion Royale 0.9.4
      */
    public function PopUpAnchor()
    {
      //  addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
      //  addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }
    
    /* private var popUpWidth:Number = 0;
    private var popUpHeight:Number = 0;
    
    private var popUpIsDisplayed:Boolean = false;
    private var addedToStage:Boolean = false;
    
    private var popUpSizeCaptured:Boolean = false;
    
    private static var decomposition:Vector.<Number> = new <Number>[0,0,0,0,0]; */
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  popUpHeightMatchesAnchorHeight
    //----------------------------------
    
  //  private var _popUpHeightMatchesAnchorHeight:Boolean = false;
    
    /**
     *  If <code>true</code>, the height of the <code>popUp</code> control is set 
     *  to the value of the PopUpAnchor's height.
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    /* public function set popUpHeightMatchesAnchorHeight(value:Boolean):void
    {
        if (_popUpHeightMatchesAnchorHeight == value)
            return;
            
        _popUpHeightMatchesAnchorHeight = value;
        
        invalidateDisplayList();
    } */
    
    /**
     *  @private
     */
   /*  public function get popUpHeightMatchesAnchorHeight():Boolean
    {
        return _popUpHeightMatchesAnchorHeight;
    } */
    
    //----------------------------------
    //  popUpWidthMatchesAnchorWidth
    //----------------------------------
    
    private var _popUpWidthMatchesAnchorWidth:Boolean = false;
    
    /**
     *  If <code>true</code>, the width of the <code>popUp</code> control 
     *  is set to the value of the PopUpAnchor's width.
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    public function set popUpWidthMatchesAnchorWidth(value:Boolean):void
    {
        if (_popUpWidthMatchesAnchorWidth == value)
            return;
            
        _popUpWidthMatchesAnchorWidth = value;
        
        invalidateDisplayList();
    }
    
    /**
     *  @private
     */
    public function get popUpWidthMatchesAnchorWidth():Boolean
    {
        return _popUpWidthMatchesAnchorWidth;
    }

    //----------------------------------
    //  displayPopUp
    //----------------------------------
    
    private var _displayPopUp:Boolean = false;
    
    
    /**
     *  If <code>true</code>, adds the <code>popUp</code> control to the PopUpManager. 
     *  If <code>false</code>, it removes the control.  
     *  
     *  @default false
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function set displayPopUp(value:Boolean):void
    {
        if (_displayPopUp == value)
            return;
            
        _displayPopUp = value;
        //addOrRemovePopUp();
    }
    
    /**
     *  @private
     */
    public function get displayPopUp():Boolean
    {
        return _displayPopUp;
    }


    
    //----------------------------------
    //  popUp
    //----------------------------------
    
    private var _popUp:IFlexDisplayObject;
    
    [Bindable ("popUpChanged")]
    
    /**
     *  The IFlexDisplayObject to add to the PopUpManager when the PopUpAnchor is opened. 
     *  If the <code>popUp</code> control implements IFocusManagerContainer, the 
     *  <code>popUp</code> control will have its
     *  own FocusManager. If the user uses the Tab key to navigate between
     *  controls, only the controls in the <code>popUp</code> control are accessed. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    public function set popUp(value:IFlexDisplayObject):void
    {
        if (_popUp == value)
            return;
            
        _popUp = value;
                
       /*  if (_popUp is ISimpleStyleClient)
            ISimpleStyleClient(_popUp).styleName = this;
             */
        dispatchEvent(new Event("popUpChanged"));
    }
    
    /**
     *  @private
     */
    public function get popUp():IFlexDisplayObject 
    { 
        return _popUp 
    }
    
    //----------------------------------
    //  popUpPosition
    //----------------------------------
    
    private var _popUpPosition:String = "topLeft" //PopUpPosition.TOP_LEFT;
    
   // [Inspectable(category="General", enumeration="left,right,above,below,center,topLeft", defaultValue="topLeft")]
    
    /**
     *  Position of the <code>popUp</code> control when it is opened, relative
     *  to the PopUpAnchor component.
     *  Possible values are <code>"left", "right", "above", "below", "center",</code>
     *  and <code>"topLeft"</code>.
     * 
     *   
     *  @default PopUpPosition.TOP_LEFT
     * 
     *  @see spark.components.PopUpPosition
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    
    public function set popUpPosition(value:String):void
    {
        if (_popUpPosition == value)
            return;
            
        _popUpPosition = value;
        invalidateDisplayList();    
    }
    
    public function get popUpPosition():String
    {
        return _popUpPosition;
    }
        
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private 
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);                
      //  applyPopUpTransform(unscaledWidth, unscaledHeight);            
    }
    
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------   

    /* private var _isModal:Boolean = false;

    [Inspectable(category="General", defaultValue="false")] */
    /**
     *  Flag indicating whether the popup should be modal.
     *  A modal container takes all keyboard and mouse input until it is closed.
     *  A non-modal container allows other components to accept input while the pop-up window is open.
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4.12
     */
    /* public function get isModal():Boolean
    {
        return _isModal;
    }

    public function set isModal(value:Boolean):void
    {
        _isModal = value;
    } */

    /**
     *  Updates the <code>popUp</code> control's transform matrix. Typically, 
     *  you would call this function while performing an effect on the PopUpAnchor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function updatePopUpTransform():void
    {
        applyPopUpTransform(width, height);
    } */
    
    /**
     *  Called when the <code>popUp</code> control is positioned, when it is displayed,
     *  or when <code>updatePopUpTransform()</code> is called. Override this function to 
     *  alter the position of the <code>popUp</code> control.  
     * 
     *  @return The absolute position of the <code>popUp</code> control in the global coordinate system.  
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* protected function calculatePopUpPosition():Point
    {
        // This implementation doesn't handle rotation
        var sandboxRoot:DisplayObject = systemManager.getSandboxRoot();
        var matrix:Matrix = MatrixUtil.getConcatenatedMatrix(this, sandboxRoot);
             
        var regPoint:Point = new Point();
        
        if (!matrix)
            return regPoint;
        
        var popUpBounds:Rectangle = new Rectangle(); 
        var popUpAsDisplayObject:DisplayObject = popUp as DisplayObject;
        
        determinePosition(popUpPosition, popUpAsDisplayObject.width, popUpAsDisplayObject.height,
                          matrix, regPoint, popUpBounds);
        
        var adjustedPosition:String;
        
        // Position the popUp in the opposite direction if it 
        // does not fit on the screen. 
        if (screen)
        {
            switch(popUpPosition)
            {
                case PopUpPosition.BELOW :
                    if (popUpBounds.bottom > screen.bottom)
                        adjustedPosition = PopUpPosition.ABOVE; 
                    break;
                case PopUpPosition.ABOVE :
                    if (popUpBounds.top < screen.top)
                        adjustedPosition = PopUpPosition.BELOW; 
                    break;
                case PopUpPosition.LEFT :
                    if (popUpBounds.left < screen.left)
                        adjustedPosition = PopUpPosition.RIGHT; 
                    break;
                case PopUpPosition.RIGHT :
                    if (popUpBounds.right > screen.right)
                        adjustedPosition = PopUpPosition.LEFT; 
                    break;
            }
        }
        
        // Get the new registration point based on the adjusted position
        if (adjustedPosition != null)
        {
            var adjustedRegPoint:Point = new Point();
            var adjustedBounds:Rectangle = new Rectangle(); 
            determinePosition(adjustedPosition, popUpAsDisplayObject.width, 
                              popUpAsDisplayObject.height,
                              matrix, adjustedRegPoint, adjustedBounds);
         
            if (screen)
            {
                // If we adjusted the position but the popUp still doesn't fit, 
                // then revert to the original position. 
                switch(adjustedPosition)
                {
                   case PopUpPosition.BELOW :
                        if (adjustedBounds.bottom > screen.bottom)
                            adjustedPosition = null; 
                        break;
                    case PopUpPosition.ABOVE :
                        if (adjustedBounds.top < screen.top)
                            adjustedPosition = null; 
                        break;
                    case PopUpPosition.LEFT :
                        if (adjustedBounds.left < screen.left)
                            adjustedPosition = null; 
                        break;
                    case PopUpPosition.RIGHT :
                        if (adjustedBounds.right > screen.right)
                            adjustedPosition = null;  
                        break;
                }    
            }
            
            if (adjustedPosition != null)
            {
                regPoint = adjustedRegPoint;
                popUpBounds = adjustedBounds;
            }
        }
        
        MatrixUtil.decomposeMatrix(decomposition, matrix, 0, 0);
        var concatScaleX:Number = decomposition[3];
        var concatScaleY:Number = decomposition[4]; 
        
        // If the popUp still doesn't fit, then nudge it
        // so it is completely on the screen. Make sure to include scale.

        if (popUpBounds.top < screen.top)
            regPoint.y += (screen.top - popUpBounds.top) / concatScaleY;
        else if (popUpBounds.bottom > screen.bottom)
            regPoint.y -= (popUpBounds.bottom - screen.bottom) / concatScaleY;
        
        if (popUpBounds.left < screen.left)
            regPoint.x += (screen.left - popUpBounds.left) / concatScaleX;    
        else if (popUpBounds.right > screen.right)
            regPoint.x -= (popUpBounds.right - screen.right) / concatScaleX;
        
        // Compute the stage coordinates of the upper,left corner of the PopUp, taking
        // the postTransformOffsets - which include mirroring - into account.
        // If we're mirroring, then the implicit assumption that x=left will fail,
        // so we compensate here.
        
        if (layoutDirection == LayoutDirection.RTL)
            regPoint.x += popUpBounds.width;
        return MatrixUtil.getConcatenatedComputedMatrix(this, sandboxRoot).transformPoint(regPoint);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Private and protected methods
    //
    //-------------------------------------------------------------------------- 

    /**
     *  @private
     */
    /* protected function addOrRemovePopUp():void
    {
        if (!addedToStage)
            return;
        
        if (popUp == null)
            return;
                        
        if (DisplayObject(popUp).parent == null && displayPopUp)
        {
            PopUpManager.addPopUp(popUp,this,_isModal);
			if (popUp is IUIComponent)
				IUIComponent(popUp).owner = this;
            popUpIsDisplayed = true;
            if (popUp is UIComponent && !popUpSizeCaptured)
            {
                popUpWidth = UIComponent(popUp).explicitWidth;
                popUpHeight = UIComponent(popUp).explicitHeight;
                UIComponent(popUp).validateNow();
                popUpSizeCaptured = true;
            }   
            
            applyPopUpTransform(width, height);
        }
        else if (DisplayObject(popUp).parent != null && displayPopUp == false)
        {
            removeAndResetPopUp();
        }
    } */
    
    /**
     *  @private
     */
   /*  private function removeAndResetPopUp():void
    {
        PopUpManager.removePopUp(popUp);
        popUpIsDisplayed = false;
    } */

    /**
     *  @private
     */
    /* protected function determinePosition(placement:String, popUpWidth:Number, popUpHeight:Number,
                                           matrix:Matrix, registrationPoint:Point, bounds:Rectangle):void
    {
        switch(placement)
        {
            case PopUpPosition.BELOW:
                registrationPoint.x = 0;
                registrationPoint.y = unscaledHeight;
                break;
            case PopUpPosition.ABOVE:
                registrationPoint.x = 0;
                registrationPoint.y = -popUpHeight;
                break;
            case PopUpPosition.LEFT:
                registrationPoint.x = -popUpWidth;
                registrationPoint.y = 0;
                break;
            case PopUpPosition.RIGHT:
                registrationPoint.x = unscaledWidth;
                registrationPoint.y = 0;
                break;            
            case PopUpPosition.CENTER:
                registrationPoint.x = (unscaledWidth - popUpWidth) / 2;
                registrationPoint.y = (unscaledHeight - popUpHeight) / 2;
                break;            
            case PopUpPosition.TOP_LEFT:
                // already 0,0
                break;
        }
        
        var popUpAsDisplayObject:DisplayObject = popUp as DisplayObject;
        
        var topLeft:Point = registrationPoint.clone();
        var size:Point = MatrixUtil.transformBounds(popUpAsDisplayObject.width, popUpAsDisplayObject.height, matrix, topLeft);
        bounds.left = topLeft.x;
        bounds.top = topLeft.y;
        bounds.width = size.x;
        bounds.height = size.y;
    }
 */
    /**
     *  @private
     */
    /* protected function applyPopUpTransform(unscaledWidth:Number, unscaledHeight:Number):void
    {
        if (!popUpIsDisplayed)
            return;
        
        // Set the dimensions explicitly because UIComponents always set themselves to their
        // measured / explicit dimensions if they are parented by the SystemManager. 
        if (popUp is UIComponent)
        {
            if (popUpWidthMatchesAnchorWidth)
                UIComponent(popUp).width = unscaledWidth;
            else
                UIComponent(popUp).explicitWidth = popUpWidth;
            
            if (popUpHeightMatchesAnchorHeight)
                UIComponent(popUp).height = unscaledHeight;
            else
                UIComponent(popUp).explicitHeight = popUpHeight;
        }
        else
        {
            var w:Number = popUpWidthMatchesAnchorWidth ? unscaledWidth : popUp.measuredWidth;
            var h:Number = popUpHeightMatchesAnchorHeight ? unscaledHeight : popUp.measuredHeight;
            popUp.setActualSize(w, h);
        }
        
        var popUpPoint:Point = calculatePopUpPosition();
        PopUpUtil.applyPopUpTransform(this, $transform.concatenatedColorTransform, systemManager, popUp, popUpPoint);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //-------------------------------------------------------------------------- 
    
    /**
     *  @private 
     */ 
    /* private function addedToStageHandler(event:Event):void
    {
        addedToStage = true;
        addOrRemovePopUp();    
    } */
    
    /**
     *  @private 
     */ 
    /* private function removedFromStageHandler(event:Event):void
    {
        if (popUp != null && DisplayObject(popUp).parent != null)
            removeAndResetPopUp();
        
        addedToStage = false;
    } */
    
}
}
