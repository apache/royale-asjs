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


package spark.layouts.supportClasses
{
import org.apache.royale.geom.Rectangle;

import mx.core.ILayoutElement;
//import mx.resources.IResourceManager;
//import mx.resources.ResourceManager;

//--------------------------------------
//  Other metadata
//--------------------------------------

//[ResourceBundle("layout")]

[ExcludeClass]
    
/**
 *  @private
 *  A sparse array of "major dimension" sizes that represent 
 *  VerticalLayout item heights or HorizontalLayout item widths, 
 *  and the current "minor dimension" maximum size.
 * 
 *  Provides efficient support for finding the cumulative distance to 
 *  the start/end of an item along the major axis, and similarly for
 *  finding the index of the item at a particular distance.
 * 
 *  Default major/minor sizes is used for items whose size hasn't 
 *  been specified.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
public final class LinearLayoutVector
{
    /**
     *  Specifies that the <code>majorAxis</code> is vertical.
     * 
     *  @see majorAxis
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const VERTICAL:uint = 0;
    
    
    /**
     *  Specifies that the <code>majorAxis</code> is horizontal.
     * 
     *  @see majorAxis
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const HORIZONTAL:uint = 1;

    // Assumption: vector elements (sizes) will typically be set in
    // small ranges that reflect localized scrolling.  Allocate vector
    // elements in blocks of BLOCK_SIZE, which must be a power of 2.
    // BLOCK_SHIFT is the power of 2 and BLOCK_MASK masks off as many 
    // low order bits.  The blockTable contains all of the allocated 
    // blocks and has length/BLOCK_SIZE elements which are allocated lazily.
    internal static const BLOCK_SIZE:uint = 128;
    internal static const BLOCK_SHIFT:uint = 7;
    internal static const BLOCK_MASK:uint = 0x7F;
    private const blockTable:Vector.<Block> = new Vector.<Block>(0, false);

    // Sorted Vector of intervals for the pending removes, in descending order, 
    // for example [7, 5, 3, 1] for the removes at 7, 6, 5, 3, 2, 1
    private var pendingRemoves:Vector.<int> = null;

    // Sorted Vector of intervals for the pending inserts, in ascending order, 
    // for example [1, 3, 5, 7] for the inserts at 1, 2, 3, 5, 6, 7
    private var pendingInserts:Vector.<int> = null;

    // What the length will be after any pending changes are flushed.
    private var pendingLength:int = -1;

    public function LinearLayoutVector(majorAxis:uint = VERTICAL)
    {
        super();
        this.majorAxis = majorAxis;
    }

    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  resourceManager
    //----------------------------------

    /**
     *  @private
     *  Used for accessing localized Error messages.
    private function get resourceManager():IResourceManager
    {
        return ResourceManager.getInstance();
    }
     */
    
    
    //----------------------------------
    //  length
    //----------------------------------

    private var _length:uint = 0;
    
    /**
     *  The number of item size valued elements.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get length():uint
    {
        return pendingLength == -1 ? _length : pendingLength;
    }
    
    /**
     *  @private
     */
    public function set length(value:uint):void
    {
        flushPendingChanges();
        setLength(value);
    }
    
    /**
     *  @private
     *  Grows or truncates the vector to be the specified newLength.
     *  When truncating, releases empty blocks and sets to NaN any values 
     *  in the last block beyond the newLength.
     */
    private function setLength(newLength:uint):void
    {
        if (newLength < _length)
        {
            // Clear any remaining non-NaN values in the last block
            var blockIndex:uint = newLength >> BLOCK_SHIFT;
            var endIndex:int = Math.min(blockIndex * BLOCK_SIZE + BLOCK_SIZE, _length) - 1;
            clearInterval(newLength, endIndex);
        }
        
        _length = newLength;  
        
        // update the table
        var partialBlock:uint = ((_length & BLOCK_MASK) == 0) ? 0 : 1;
        blockTable.length = (_length >> BLOCK_SHIFT) + partialBlock;       
    }

    //----------------------------------
    //  defaultMajorSize
    //----------------------------------
    
    private var _defaultMajorSize:Number = 0;
    
    /**
     *  The size of items whose majorSize was not specified with setMajorSize.
     * 
     *  @default 0
     *  @see #cacheDimensions
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get defaultMajorSize():Number
    {
        return _defaultMajorSize;
    }
    
    /**
     * @private
     */
    public function set defaultMajorSize(value:Number):void
    {
        _defaultMajorSize = value;
    }
    
    //----------------------------------
    //  defaultMinorSize
    //----------------------------------
    
    private var _defaultMinorSize:Number = 0;
    
    /**
     *  The default minimum value for the minorSize property.
     *
     *  @default 0
     *  @see #cacheDimensions
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get defaultMinorSize():Number
    {
        return _defaultMinorSize;
    }
    
    /**
     * @private
     */
    public function set defaultMinorSize(value:Number):void
    {
        _defaultMinorSize = value;
    }

    //----------------------------------
    //  minorSize
    //----------------------------------
    
    private var _minorSize:Number = 0;

    /**
     *  The maximum size of items along the axis opposite the majorAxis and the defaultMinorSize.
     * 
     *  This property is updated by the <code>cacheDimensions()</code> method.
     * 
     *  @default 0
     *  @see #cacheDimensions
     *  @see majorAxis
     *  @see #defaultMinorSize
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get minorSize():Number
    {
        return Math.max(defaultMinorSize, _minorSize);
    }
    
    /**
     * @private
     */
    public function set minorSize(value:Number):void
    {
        _minorSize = value;
    }
    
    //----------------------------------
    //  minMinorSize
    //----------------------------------
    
    private var _minMinorSize:Number = 0;
    
    /**
     *  The maximum of the minimum size of items relative to the minor axis.
     * 
     *  If majorAxis is VERTICAL then this is the maximum of items' minWidths,
     *  and if majorAxis is HORIZONTAL, then this is the maximum of the
     *  items' minHeights. 
     * 
     *  This property is updated by the <code>cacheDimensions()</code> method.
     * 
     *  @default 0
     *  @see #cacheDimensions
     *  @see majorAxis
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get minMinorSize():Number
    {
        return _minMinorSize;
    }
    
    /**
     * @private
     */
    public function set minMinorSize(value:Number):void
    {
        _minMinorSize = value;
    }
    
    //----------------------------------
    //  majorAxis
    //----------------------------------
    
    private var _majorAxis:uint = VERTICAL;
    
    /**
     *  Defines how the <code>getBounds()</code> method maps from 
     *  majorSize, minorSize to width and height.
     * 
     *  @default VERTICAL
     *  @see #cacheDimensions
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get majorAxis():uint
    {
        return _majorAxis;
    }
    
    /**
     * @private
     */
    public function set majorAxis(value:uint):void
    {
        _majorAxis = value;
    }

    //----------------------------------
    //  majorAxisOffset
    //----------------------------------
    
    private var _majorAxisOffset:Number = 0;
    
    /**
     *  The offset of the first item from the origin in the majorAxis
     *  direction. This is useful when implementing padding,
     *  in addition to gaps, for virtual layouts.
     *  
     *  @see #gap
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get majorAxisOffset():Number
    {
        return _majorAxisOffset;
    }

    /**
     * @private
     */
    public function set majorAxisOffset(value:Number):void
    {
        _majorAxisOffset = value;
    }

    //----------------------------------
    //  gap
    //----------------------------------
    
    private var _gap:Number = 6;

    /**
     *  The distance between items.
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
     * @private
     */
    public function set gap(value:Number):void
    {
        _gap = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
     
    /**
     *  Return the size of the item at index.  If no size was ever
     *  specified then then the defaultMajorSize is returned.
     * 
     *  @param index The item's index.
     *  @see defaultMajorSize
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */      
    public function getMajorSize(index:uint):Number
    {
        flushPendingChanges();
        
        var block:Block = blockTable[index >> BLOCK_SHIFT];
        if (block)
        {
            var value:Number = block.sizes[index & BLOCK_MASK];
            return (isNaN(value)) ? _defaultMajorSize : value;
        }
        else
            return _defaultMajorSize;
    }
    
    /**
     *  Set the size of the item at index.   If an index is 
     *  set to <code>NaN</code> then subsequent calls to get
     *  will return the defaultMajorSize.
     * 
     *  @param index The item's index.
     *  @param value The item's size.
     *  @see defaultMajorSize
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */      
    public function setMajorSize(index:uint, value:Number):void
    {
        flushPendingChanges();
        
        if (index >= length)
            throw new Error(/*resourceManager.getString("layout", */"invalidIndex"/*)*/);
            
        var blockIndex:uint = index >> BLOCK_SHIFT;
        var block:Block = blockTable[blockIndex];
        if (!block)
            block = blockTable[blockIndex] = new Block();
        var sizesIndex:uint = index & BLOCK_MASK;
        var sizes:Vector.<Number> = block.sizes;
        var oldValue:Number = sizes[sizesIndex];
        if (oldValue == value)
            return;
        if (isNaN(oldValue)) 
        { 
            block.defaultCount -= 1;
            block.sizesSum += value;
        }   
        else if (isNaN(value))
        {
            block.defaultCount += 1;
            block.sizesSum -= oldValue;
        }
        else
            block.sizesSum += value - oldValue;
        block.sizes[sizesIndex] = value;
    }
    
    /**
     *  Make room for a new item at index by shifting all of the sizes 
     *  one position to the right, beginning with startIndex.  
     * 
     *  The value at index will be NaN. 
     * 
     *  This is similar to array.splice(index, 0, NaN).
     * 
     *  @param index The position of the new NaN size item.
     */
    public function insert(index:uint):void
    {
        // We don't support interleaved pending inserts and removes
        if (pendingRemoves)
            flushPendingChanges();
        
        if (pendingInserts)
        {
            // Update the last interval or add a new one?
            var lastIndex:int = pendingInserts.length - 1;
            var intervalEnd:int = pendingInserts[lastIndex];
            
            if (index == intervalEnd + 1)
            {
                // Extend the end of the interval
                pendingInserts[lastIndex] = index;
            }
            else if (index > intervalEnd)
            {
                // New interval
                pendingInserts.push(index);
                pendingInserts.push(index);
            }
            else
            {
                // We can't support pending inserts that are not ascending
                flushPendingChanges();
            }
        }

        pendingLength = Math.max(length + 1, index + 1);
        
        if (!pendingInserts)
        {
            pendingInserts = new Vector.<int>();
            pendingInserts.push(index);
            pendingInserts.push(index);
        }
    }

    /**
     *  Remove index by shifting all of the sizes one position to the left, 
     *  begining with index+1.  
     * 
     *  This is similar to array.splice(index, 1).
     * 
     *  @param index The position to be removed.
     */
    public function remove(index:uint):void
    {
        // We don't support interleaved pending inserts and removes
        if (pendingInserts)
            flushPendingChanges();

        // length getter takes into account pending inserts/removes but doesn't flush
        if (index >= length)
            throw new Error(/*resourceManager.getString("layout", */"invalidIndex"/*)*/);

        if (pendingRemoves)
        {
            // Update the last interval or add a new one?
            var lastIndex:int = pendingRemoves.length - 1;
            var intervalStart:int = pendingRemoves[lastIndex];
            
            if (index == intervalStart - 1)
            {
                // Extend the start of the interval
                pendingRemoves[lastIndex] = index;
            }
            else if (index < intervalStart)
            {
                // New interval
                pendingRemoves.push(index);
                pendingRemoves.push(index);
            }
            else
            {
                // We can't support pending removes that are not descending
                flushPendingChanges();
            }
        }

        pendingLength = (pendingLength == -1) ? length - 1 : pendingLength - 1;

        if (!pendingRemoves)
        {
            pendingRemoves = new Vector.<int>();
            pendingRemoves.push(index);
            pendingRemoves.push(index);
        }
    }
    
    /**
     *  @private
     *  Returns true when all sizes in the specified interval for the block are NaN
     */
    private function isIntervalClear(block:Block, index:int, count:int):Boolean
    {
        var sizesSrc:Vector.<Number> = block.sizes;
        for (var i:int = 0; i < count; i++)
        {
            if (!isNaN(sizesSrc[index + i]))
                return true;
        }
        return false;
    }
    
    /**
     *  @private 
     *  Copies elements between blocks. Indices relative to the blocks.
     *  If srcBlock is null, then it fills the destination with NaNs.
     *  The case of srcBlock == dstBlock is also supported.
     *  The caller must ensure that count is within range.
     */
    private function inBlockCopy(dstBlock:Block, dstIndexStart:int, srcBlock:Block, srcIndexStart:int, count:int):void
    {
        var ascending:Boolean = dstIndexStart < srcIndexStart;

        var srcIndex:int = ascending ? srcIndexStart : srcIndexStart + count - 1;
        var dstIndex:int = ascending ? dstIndexStart : dstIndexStart + count - 1;
        var increment:int = ascending ? +1 : -1;
        
        var dstSizes:Vector.<Number> = dstBlock.sizes;
        var srcSizes:Vector.<Number> = srcBlock ? srcBlock.sizes : null;
        var dstValue:Number = NaN;
        var srcValue:Number = NaN;
        var sizesSumDelta:Number = 0;   // How much the destination sizesSum will change 
        var defaultCountDelta:int = 0;  // How much the destination defaultCount will change
        
        while (count > 0)
        {
            if (srcSizes)
                srcValue = srcSizes[srcIndex];
            dstValue = dstSizes[dstIndex];
            
            // Are the values different?
            if (!(srcValue === dstValue)) // Triple '=' to handle NaN comparison
            {
                // Are we removing a default size or a chached size?
                if (isNaN(dstValue))
                    defaultCountDelta--;
                else
                    sizesSumDelta -= dstValue;
                
                // Are we adding a default size or a cached size?
                if (isNaN(srcValue))
                    defaultCountDelta++;
                else
                    sizesSumDelta += srcValue;
                
                dstSizes[dstIndex] = srcValue;
            }
            
            srcIndex += increment;
            dstIndex += increment;
            count--;
        }
        
        dstBlock.sizesSum += sizesSumDelta;
        dstBlock.defaultCount += defaultCountDelta;
    }
    
    /**
     *  @private
     *  Copies 'count' elements from dstIndex to srcIndex.
     *  Safe for overlapping source and destination intervals.
     *  If any blocks are left full of NaNs, they will be deallcated.
     */
    private function copyInterval(dstIndex:int, srcIndex:int, count:int):void
    {
        var ascending:Boolean =  dstIndex < srcIndex;
        if (!ascending)
        {
            dstIndex += count -1;
            srcIndex += count -1;
        }
        
        while (count > 0)
        {
            // Figure out destination block
            var dstBlockIndex:uint = dstIndex >> BLOCK_SHIFT;
            var dstSizesIndex:uint = dstIndex & BLOCK_MASK;
            var dstBlock:Block = blockTable[dstBlockIndex];
            
            // Figure out source block
            var srcBlockIndex:uint = srcIndex >> BLOCK_SHIFT;
            var srcSizesIndex:uint = srcIndex & BLOCK_MASK;
            var srcBlock:Block = blockTable[srcBlockIndex];

            // Figure out number of elements to copy
            var copyCount:int;
            if (ascending)
                copyCount = Math.min(BLOCK_SIZE - dstSizesIndex, BLOCK_SIZE - srcSizesIndex);
            else
                copyCount = 1 + Math.min(dstSizesIndex, srcSizesIndex);
            copyCount = Math.min(copyCount, count);
            
            // Figure out the start index for each block
            var dstStartIndex:int = ascending ? dstSizesIndex : dstSizesIndex - copyCount + 1;
            var srcStartIndex:int = ascending ? srcSizesIndex : srcSizesIndex - copyCount + 1;
            
            // Check whether a destination block needs to be allocated.
            // Allocate only if there are non-default values to be copied from the source. 
            if (srcBlock && !dstBlock &&
                isIntervalClear(srcBlock, srcStartIndex, copyCount))
            {
                dstBlock = new Block();
                blockTable[dstBlockIndex] = dstBlock;
            }

            // Copy to non-null dstBlock, srcBlock can be null
            if (dstBlock)
            {
                inBlockCopy(dstBlock, dstStartIndex, srcBlock, srcStartIndex, copyCount);
                
                // If this is the last time we're visiting this block, and it contains
                // only NaNs, then remove it
                if (dstBlock.defaultCount == BLOCK_SIZE)
                {
                    var blockEndReached:Boolean = ascending ? (dstStartIndex + copyCount == BLOCK_SIZE) :
                                                              (dstStartIndex == 0);
                    if (blockEndReached || count == copyCount)
                        blockTable[dstBlockIndex] = null;
                }
            }

            dstIndex += ascending ? copyCount : -copyCount;
            srcIndex += ascending ? copyCount : -copyCount;
            count -= copyCount;
        }
    }
    
    /**
     *  @private
     *  Sets all elements within the specified interval to NaN (both ends inclusive). 
     *  Releases empty blocks.
     */
    private function clearInterval(start:int, end:int):void
    {
        while (start <= end)
        {
            // Figure our destination block
            var blockIndex:uint = start >> BLOCK_SHIFT;
            var sizesIndex:uint = start & BLOCK_MASK;
            var block:Block = blockTable[blockIndex];
            
            // Figure out number of elements to clear in this iteration
            // Make sure we don't clear more items than requested
            var clearCount:int = BLOCK_SIZE - sizesIndex;
            clearCount = Math.min(clearCount, end - start + 1);
            
            if (block)
            {
                if (clearCount == BLOCK_SIZE)
                    blockTable[blockIndex] = null;
                else
                {
                    // Copying from null source block is equivalent of clearing the destination block
                    inBlockCopy(block, sizesIndex, null /*srcBlock*/, 0, clearCount);
                    
                    // If the blockDst contains only default sizes, then remove the block
                    if (block.defaultCount == BLOCK_SIZE)
                        blockTable[blockIndex] = null;                    
                }
            }

            start += clearCount;
        }
    }

    /**
     *  @private
     *  Removes the elements designated by the intervals and truncates
     *  the LinearLayoutVector to the new length.
     *  'intervals' is a Vector of descending intervals [7, 5, 3, 1]
     */
    private function removeIntervals(intervals:Vector.<int>):void
    {
        var intervalsCount:int = intervals.length;
        if (intervalsCount == 0)
            return;
        
        // Adding final nextIntervalStart value (see below).
        intervals.reverse(); // turn into ascending, for example [7, 5, 3, 1] --> [1, 3, 5, 7]
        intervals.push(length);

        // Move the elements
        var dstStart:int = intervals[0];
        var srcStart:int; 
        var count:int;
        var i:int = 0;
        do
        {
            var intervalEnd:int       = intervals[i + 1];
            var nextIntervalStart:int = intervals[i + 2]
            i += 2;
            
            // Start copy from after the end of current interval
            srcStart = intervalEnd + 1;

            // copy all elements up to the start of the next interval.
            count = nextIntervalStart - srcStart;

            copyInterval(dstStart, srcStart, count);
            dstStart += count;
        } 
        while (i < intervalsCount)

        // Truncate the excess elements.
        setLength(dstStart);
    }
    
    /**
     *  @private
     *  Increases the length and inserts NaN values for the elements designated by the intervals.
     *  'intervals' is a Vector of ascending intervals [1, 3, 5, 7]
     */
    private function insertIntervals(intervals:Vector.<int>, newLength:int):void
    {
        var intervalsCount:int = intervals.length;
        if (intervalsCount == 0)
            return;
        
        // Allocate enough space for the insertions, all the elements
        // allocated are NaN by default.
        var oldLength:int = length;
        setLength(newLength);
        
        var srcEnd:int = oldLength - 1;
        var dstEnd:int = newLength - 1;
        var i:int = intervalsCount - 2;
        while (i >= 0)
        {
            // Find current interval
            var intervalStart:int = intervals[i];
            var intervalEnd:int = intervals[i + 1];
            i -= 2;
            
            // Start after the current interval 
            var dstStart:int = intervalEnd + 1;
            var copyCount:int = dstEnd - dstStart + 1;
            var srcStart:int = srcEnd - copyCount + 1;
            
            copyInterval(dstStart, srcStart, copyCount);
            srcEnd -= copyCount;
            dstEnd = intervalStart - 1;
            
            // Fill in with default NaN values after the copy
            clearInterval(intervalStart, intervalEnd);
        }
    }
    
    /**
     *  @private
     *  Processes any pending removes or pending inserts.
     */
    private function flushPendingChanges():void
    {
        var intervals:Vector.<int>;
        if (pendingRemoves)
        {
            intervals = pendingRemoves;
            pendingRemoves = null;
            pendingLength = -1;
            removeIntervals(intervals);
        }
        else if (pendingInserts)
        {
            intervals = pendingInserts;
            var newLength:int = pendingLength;
            pendingInserts = null;
            pendingLength = -1;
            insertIntervals(intervals, newLength);
        }
    }
    
    /**
     *  The cumulative distance to the start of the item at index, including
     *  the gaps between items and the majorAxisOffset. 
     * 
     *  The value of start(0) is majorAxisOffset.  
     * 
     *  Equivalent to:
     *  <pre>
     *  var distance:Number = majorAxisOffset;
     *  for (var i:int = 0; i &lt; index; i++)
     *      distance += get(i);
     *  return distance + (gap * index);
     *  </pre>
     * 
     *  The actual implementation is relatively efficient.
     * 
     *  @param index The item's index.
     *  @see #end
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function start(index:uint):Number
    {
        flushPendingChanges();

        if ((_length == 0) || (index == 0))
            return majorAxisOffset;
            
        if (index >= _length)
            throw new Error(/*resourceManager.getString("layout", */"invalidIndex"/*)*/);            

        var distance:Number = majorAxisOffset;
        var blockIndex:uint = index >> BLOCK_SHIFT;
        for (var i:int = 0; i < blockIndex; i++)
        {
            var block:Block = blockTable[i];
            if (block)
                distance += block.sizesSum + (block.defaultCount * _defaultMajorSize);
            else
                distance += BLOCK_SIZE * _defaultMajorSize;
        }
        var lastBlock:Block = blockTable[blockIndex];
        var lastBlockOffset:uint = index & ~BLOCK_MASK;
        var lastBlockLength:uint = index - lastBlockOffset;
        if (lastBlock)
        {
            var sizes:Vector.<Number> = lastBlock.sizes;
            for (i = 0; i < lastBlockLength; i++)
            {
                var size:Number = sizes[i];
                distance += (isNaN(size)) ? _defaultMajorSize : size;
            }
        }
        else 
            distance += _defaultMajorSize * lastBlockLength;
        distance += index * gap;
        return distance;
    }

    /**
     *  The cumulative distance to the end of the item at index, including
     *  the gaps between items.
     * 
     *  If <code>index &lt;(length-1)</code> then the value of this 
     *  function is defined as: 
     *  <code>start(index) + get(index)</code>.
     * 
     *  @param index The item's index.
     *  @see #start
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function end(index:uint):Number
    {
        flushPendingChanges();
        return start(index) + getMajorSize(index);
    }

    /**
     *  Returns the index of the item that overlaps the specified distance.
     * 
     *  The item at index <code>i</code> overlaps a distance value 
     *  if <code>start(i) &lt;= distance &lt; end(i)</code>.
     * 
     *  If no such item exists, -1 is returned.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function indexOf(distance:Number):int
    {
        flushPendingChanges();
        var index:int = indexOfInternal(distance);
        return (index >= _length) ? -1 : index;
    }

    private function indexOfInternal(distance:Number):int
    {
        if ((_length == 0) || (distance < 0))
            return -1;

        // The area of the first item includes the majorAxisOffset            
        var curDistance:Number = majorAxisOffset;
        if (distance < curDistance)
            return 0;
        
        var index:int = -1;
        var block:Block = null;
        var blockGap:Number = _gap * BLOCK_SIZE;
        
        // Find the block that contains distance and the index of its
        // first element
        for (var blockIndex:uint = 0; blockIndex < blockTable.length; blockIndex++)
        {
            block = blockTable[blockIndex];
            var blockDistance:Number = blockGap;
            if (block)
                blockDistance += block.sizesSum + (block.defaultCount * _defaultMajorSize);
            else
                blockDistance += BLOCK_SIZE * _defaultMajorSize;
            if ((distance == curDistance) ||
                ((distance >= curDistance) && (distance < (curDistance + blockDistance))))
            {
                index = blockIndex << BLOCK_SHIFT;
                break;
            }
            curDistance += blockDistance;
        }
        
        if ((index == -1) || (distance == curDistance))
            return index;

        // At this point index corresponds to the first item in this block
        if (block)
        {
            // Find the item that contains distance and return its index
            var sizes:Vector.<Number> = block.sizes;
            for (var i:int = 0; i < BLOCK_SIZE - 1; i++)
            {
                var size:Number = sizes[i];
                curDistance += _gap + (isNaN(size) ? _defaultMajorSize : size);
                if (curDistance > distance)
                    return index + i;
            }
            // TBD special-case for the very last index
            return index + BLOCK_SIZE - 1;
        }
        else
        {
            return index + Math.floor(Number(distance - curDistance) / Number(_defaultMajorSize + _gap));
        }
    }

    /**
     *  Stores the <code>majorSize</code> for the specified ILayoutElement at index, 
     *  and updates the <code>minorSize</code> and <code>minMinorSize</code> properties.
     * 
     *  If <code>majorAxis</code> is <code>VERTICAL</code> then <code>majorSize</code> corresponds to the 
     *  height of this ILayoutElement, and the minor sizes to the 
     *  <code>preferredBoundsWidth</code> and <code>minWidth</code>.
     * 
     *  If <code>majorAxis</code> is <code>HORIZONTAL</code>, then the roles of the dimensions
     *  are reversed.
     * 
     *  The <code>minMinorSize</code> is intended to be used at the time that the <code>LinearLayout::measure()</code> method is called.
     * 
     *  It accumulates the maximum of the <code>minWidth</code>, <code>Height</code> for all items.
     * 
     *  @param index The item's index.
     *  @param elt The layout element at index.
     * 
     *  @see #getMajorSize
     *  @see minorSize
     *  @see minMinorSize
     *  @see majorAxis
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function cacheDimensions(index:uint, elt:ILayoutElement):void
    {
        flushPendingChanges();
        if (!elt || (index >= _length))
            return;
            
        // The minorSize is the min of the acutal width and the preferred width
        // because we do not want the contentWidth to track the target's width, 
        // per horizontalAlign="contentJustify" or "justify".  
        // The majorAxis=HORIZONTAL case is similar.
        
        if (majorAxis == VERTICAL)
        {
            setMajorSize(index, elt.getLayoutBoundsHeight());
            var w:Number = Math.min(elt.getPreferredBoundsWidth(), elt.getLayoutBoundsWidth());
            
            // Use the _minorSize instead of the getter, since the getter returns maximum
            // of _minorSize and _defaultMinorSize.
            _minorSize = Math.max(_minorSize, w);
            minMinorSize = Math.max(minMinorSize, elt.getMinBoundsWidth());
        }
        else
        {
            setMajorSize(index, elt.getLayoutBoundsWidth());            
            var h:Number = Math.min(elt.getPreferredBoundsHeight(), elt.getLayoutBoundsHeight());

            // Use the _minorSize instead of the getter, since the getter returns maximum
            // of _minorSize and _defaultMinorSize.
            _minorSize = Math.max(_minorSize, h);
            minMinorSize = Math.max(minMinorSize, elt.getMinBoundsHeight());
        }
    }
    
    /** 
     *  Returns the implict bounds of the item at index.
     * 
     *  The bounds do not include the gap that follows the item.
     * 
     *  If majorAxis is VERTICAL then the returned value is equivalent to:
     *  <pre>
     *    new Rectangle(0, start(index), major, minor)
     *  </pre>
     * 
     *  If majorAxis is HORIZONTAL then the returned value is equivalent to:
     *  <pre>
     *    new Rectangle(start(index), 0, minor, major)
     *  </pre>
     * 
     *  @param index The item's index.
     *  @param bounds The Rectangle to return or null for a new Rectangle
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getBounds(index:uint, bounds:Rectangle = null):Rectangle
    {
        flushPendingChanges();
        if (!bounds)
            bounds = new Rectangle();

        var major:Number = getMajorSize(index); 
        var minor:Number = minorSize;
        if (majorAxis == VERTICAL)
        {
            bounds.x = 0;
            bounds.y = start(index);
            bounds.height = major;
            bounds.width = minor;
        }
        else  // HORIZONTAL
        {
            bounds.x = start(index);
            bounds.y = 0;
            bounds.height = minor;
            bounds.width = major;
        }
        return bounds;
    }
    
    /**
     *  Clear all cached state, reset length to zero.
     */
    public function clear():void
    {
        // Discard any pending changes, before setting the length
        // otherwise the length setter will commit the changes.
        pendingRemoves = null;
        pendingInserts = null;
        pendingLength = -1;

        length = 0; // clears the BlockTable as well
        minorSize = 0;
        minMinorSize = 0;
    }
    
    public function toString():String
    {
        return "LinearLayoutVector{" + 
            "length=" + _length +
            " [blocks=" + blockTable.length + "]" + 
            " " + ((majorAxis == VERTICAL) ? "VERTICAL" : "HORIZONTAL") + 
            " gap=" + _gap + 
            " defaultMajorSize=" + _defaultMajorSize + 
            " pendingRemoves=" + (pendingRemoves ? pendingRemoves.length : 0) +
            " pendingInserts=" + (pendingInserts ? pendingInserts.length : 0) +
            "}";
    }
}

}
