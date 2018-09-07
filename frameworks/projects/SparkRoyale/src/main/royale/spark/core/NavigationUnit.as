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
import org.apache.royale.events.KeyboardEvent;

/**
 *  The NavigationUnit class defines the possible values for the 
 *  <code>getVerticalScrollPositionDelta()</code> and 
 *  <code>getHorizontalScrollPositionDelta()</code> 
 *  methods of the IViewport class.
 * 
 *  <p>All of these constants have the same values as their flash.ui.Keyboard
 *  counterparts, except PAGE_LEFT and PAGE_RIGHT, for which no keyboard
 *  key equivalents exist.</p>
 * 
 *  @see flash.ui.Keyboard
 *  @see IViewport#getVerticalScrollPositionDelta
 *  @see IViewport#getHorizontalScrollPositionDelta
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public final class NavigationUnit
{
    /**
     *  Navigate to the origin of the document.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const HOME:uint = KeyboardEvent.KEYCODE_HOME;
    
    /**
     *  Navigate to the end of the document.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const END:uint = KeyboardEvent.KEYCODE_END;
    
    /**
     *  Navigate one line or "step" upwards.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const UP:uint = KeyboardEvent.KEYCODE_UP;
    
    /**
     *  Navigate one line or "step" downwards.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const DOWN:uint = KeyboardEvent.KEYCODE_DOWN;
    
    /**
     *  Navigate one line or "step" to the left.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const LEFT:uint = KeyboardEvent.KEYCODE_LEFT;
    
    /**
     *  Navigate one line or "step" to the right.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const RIGHT:uint = KeyboardEvent.KEYCODE_RIGHT;
    
    /**
     *  Navigate one page upwards.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const PAGE_UP:uint = KeyboardEvent.KEYCODE_PAGEUP;
    
    /**
     *  Navigate one page downwards.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const PAGE_DOWN:uint = KeyboardEvent.KEYCODE_PAGEDOWN;
    
    /**
     *  Navigate one page to the left.
     * 
     *  The value of this constant, 0x2397, is the same as the Unicode
     *  "previous page" character. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const PAGE_LEFT:uint = 0x2397;
    
    /**
     *  Navigate one page to the right.
     * 
     *  The value of this constant, 0x2398, is the same as the Unicode
     *  "next page" character. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const PAGE_RIGHT:uint = 0x2398;
    
    /**
     *  Returns <code>true</code> if the <code>keyCode</code> maps directly 
     *  to a NavigationUnit enum value.
     *
     *  @param keyCode A key code value. 
     *
     *  @return <code>true</code> if the <code>keyCode</code> maps directly 
     *  to a NavigationUnit enum value.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function isNavigationUnit(keyCode:uint):Boolean
    {
        switch (keyCode)
        {
            case KeyboardEvent.KEYCODE_LEFT:         return true;
            case KeyboardEvent.KEYCODE_RIGHT:        return true;
            case KeyboardEvent.KEYCODE_UP:           return true;
            case KeyboardEvent.KEYCODE_DOWN:         return true;
            case KeyboardEvent.KEYCODE_PAGEUP:      return true;
            case KeyboardEvent.KEYCODE_PAGEDOWN:    return true;
            case KeyboardEvent.KEYCODE_HOME:         return true;
            case KeyboardEvent.KEYCODE_END:          return true;
            default:                    return false;
        }
    }
}
}
