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

package mx.collections
{

/**
 *  Encapsulates the positional aspects of a cursor in an 
 *  <code>ICollectionView</code>.  Bookmarks are used to return a cursor to 
 *  an absolute position within the <code>ICollectionView</code>.
 *
 *  @see mx.collections.IViewCursor#bookmark
 *  @see mx.collections.IViewCursor#seek()
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class CursorBookmark
{
/*     include "../core/Version.as";
 */
    private static var _first:CursorBookmark;
    private static var _last:CursorBookmark;
    private static var _current:CursorBookmark;
    
    /**
     *  A bookmark for the first item in an <code>ICollectionView</code>.
     *
     *  @return The bookmark to the first item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function get FIRST():CursorBookmark
    {
        if (!_first)
            _first = new CursorBookmark("${F}");
        return _first;
    }
    
    /**
     *  A bookmark for the last item in an <code>ICollectionView</code>.
     * If the view has no items, the cursor is at this bookmark.
     *
     *  @return The bookmark to the last item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function get LAST():CursorBookmark
    {
        if (!_last)
            _last = new CursorBookmark("${L}");
        return _last;
    }
    
    /**
     *  A bookmark representing the current item for the <code>IViewCursor</code> in
     *  an <code>ICollectionView</code>.
     *
     *  @return The bookmark to the current item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function get CURRENT():CursorBookmark
    {
        if (!_current)
            _current = new CursorBookmark("${C}");
        return _current;
    }
    
    /**
     *  Creates a new instance of a bookmark with the specified value.
     *
     *  @param value The value of this bookmark.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function CursorBookmark(value:Object)
    {
        super();
        _value = value;
    }
    
    //--------------------------------------------------------------------------
    // 
    // Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    // value
    //----------------------------------

    private var _value:Object;
    
    /**
     *  The underlying marker representation of the bookmark.
     *  This value is generally understood only by the <code>IViewCursor</code>
     *  or <code>ICollectionView</code> implementation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get value():Object
    {
        return _value;
    }
    
    //--------------------------------------------------------------------------
    // 
    // Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Classes that extend CursorBookmark override this method to
     *  return the approximate index of the item represented by this
     *  bookmark in its view.
     *
     *  @return -1
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function getViewIndex():int
    {
        return -1;
    }
}

}
