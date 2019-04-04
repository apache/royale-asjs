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

package mx.charts.chartClasses
{

//import flash.display.BitmapData;
import mx.core.IUIComponent;
import org.apache.royale.geom.Matrix;
    

 /*
  *  private - This interface has been made public for documentation requirements to not to show broken links 
  *             for classes which implement this interface.
  */
        
/**
 *  This interface is for internal use only. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IDataCanvas
{
   /**
    *  @private
    *  The function parameter names used by the implementing classes are 
    *  different in order to make the names more suggestive.
    * 
    *  <p>For example, <code>lineTo(x:*, y:*)</code> in CartesianDataCanvas is
    *  <code>lineTo(angle:*, radial :*)</code> in PolarDataCanvas.</p>
    */
    function set dataChildren(value:Array /* of DisplayObject */):void
        
   /**
    *  @private
    */
    function get dataChildren():Array /* of DisplayObject */
        
   /**
    *  @private
    */
    function addDataChild(child:IUIComponent,left:* = undefined, top:* = undefined, right:* = undefined, 
                             bottom:* = undefined , hCenter:* = undefined, vCenter:* = undefined):void
                                 
   /**
    *  @private
    */
    function removeAllChildren():void
        
   /**
    *  @private
    */
    function updateDataChild(child:IUIComponent,left:* = undefined, top:* = undefined, right:* = undefined,
                                bottom:* = undefined, hCenter:* = undefined, vCenter:* = undefined):void
        
   /**
    *  @private
    */
    function clear():void
        
   /**
    *  @private
    */
    function beginFill(color:uint , alpha:Number = 1):void
        
   /**
    *  @private
    function beginBitmapFill(bitmap:BitmapData, x:* = undefined,
                                y:* = undefined, matrix:Matrix = null,
                                repeat:Boolean = true, smooth:Boolean = true):void
    */
                                    
   /**
    *  @private
    */
    function curveTo(controlX:*, controlY:*, anchorX:*, anchorY:*):void
        
   /**
    *  @private
    */
    function drawCircle(x:*, y:*, radius:Number):void
        
   /**
    *  @private
    */
    function drawEllipse(left:*, top:*, right:*, bottom:*):void
        
   /**
    *  @private
    */
    function drawRect(left:*, top:*, right:*, bottom:*):void
        
   /**
    *  @private
    */
    function drawRoundedRect(left:*, top:*, right:*, bottom:*, cornerRadius:Number):void
        
   /**
    *  @private
    */
    function endFill():void
        
   /**
    *  @private
    */
    function lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1.0,
                          pixelHinting:Boolean = false, scaleMode:String = "normal",
                          caps:String = null, joints:String = null, miterLimit:Number = 3):void
                              
   /**
    *  @private
    */
    function lineTo(x:*, y:*):void
        
   /**
    *  @private
    */
    function moveTo(x:*, y:*):void        
}

}