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

package mx.containers.beads
{
	
	import mx.containers.BoxDirection;
	import mx.containers.DividedBox;
	import mx.containers.utilityClasses.Flex;
	import mx.controls.Image;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;

	//import mx.core.mx_internal;
	//import mx.core.ScrollPolicy;
	
	//use namespace mx_internal;
	
	[ExcludeClass]
	
	/**
	 *  @private
	 *  The BoxLayout class is for internal use only.
	 */
	public class DividedBoxLayout extends BoxLayout
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
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function DividedBoxLayout()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _strand:IStrand;
        private var dividedBox:DividedBox;
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
            dividedBox = _strand as DividedBox;
			super.strand = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		override public function layout():Boolean
		{
            preLayoutAdjustment();
            return super.layout();
            postLayoutAdjustment();
		}
        
        /**
         *  @private
         *  Algorithm employed pre-layout to ensure that 
         *  we don't leave any dangling space and to ensure
         *  that only explicit min/max values are honored.
         * 
         *  We first compute the sum of %'s across all 
         *  children to ensure that we have at least 100%.
         *  If so, we are done.  If not, then we attempt 
         *  to attach the remaining amount to the last 
         *  component, if not, then we distribute the 
         *  percentages evenly across all % components.
         * 
         */
        private function preLayoutAdjustment():void
        {
            // Calculate the total %
            var vertical:Boolean = dividedBox.direction == BoxDirection.VERTICAL;
            
            var totalPerc:Number = 0;
            var percCount:Number = 0;
            
            var n:int = dividedBox.numChildren;
            var i:int;
            var child:IUIComponent;
            var perc:Number;
            
            for (i = 0; i < n; i++)
            {
                child = dividedBox.getLayoutChildAt(i);
                
                if (!child.includeInLayout)
                    continue;
                
                // Clear out measured min/max
                // so super.layout() doesn't use them.
                child.measuredMinWidth = 0; 
                child.measuredMinHeight = 0;
                
                perc = vertical ? child.percentHeight : child.percentWidth;
                
                if (!isNaN(perc))
                {
                    totalPerc += perc;
                    percCount++;
                }
            }
            
            // during preLayoutAdjustment, we make some changes to the children's
            // widths and heights.  We keep track of the original values in postLayoutChanges
            // so we can later go back and reset them so another layout pass is working 
            // with the correct values rather than these modified values.
            postLayoutChanges = [];
            var changeObject:Object;
            
            // No flexible children, so we make the last one 100%.
            if (totalPerc == 0 && percCount == 0)
            {
                // Everyone is fixed and we can give 100% to the last
                // included in layout one without concern.
                for (i = n-1; i >= 0; i--)
                {
                    child = UIComponent(dividedBox.getChildAt(i));
                    if (child.includeInLayout)
                    {
                        // create a changeObject to keep track of the original values 
                        // that this child had for width and height
                        changeObject = {child: child};
                        if (vertical)
                        {
                            // we know there's no percentHeight originally
                            if (child.explicitHeight)
                                changeObject.explicitHeight = child.explicitHeight;
                            else 
                                changeObject.percentHeight = NaN;
                            
                            child.percentHeight = 100;
                        }
                        else
                        {
                            // we know there's no percentWidth originally
                            if (child.explicitWidth)
                                changeObject.explicitWidth = child.explicitWidth;
                            else if (child.percentWidth)
                                changeObject.percentWidth = NaN;
                            
                            child.percentWidth = 100;
                        }
                        postLayoutChanges.push(changeObject);
                        break;
                    }
                }
            }
            else if (totalPerc < 100)
            {
                // We have some %s but they don't total to 100, so lets
                // distribute the delta across all of them and in the
                // meantime normalize all %s to unscaledHeight/Width.
                // The normalization takes care of the case where any one
                // of the components hits a min/max limit on their size,
                // which could result in the others filling less than 100%.
                var delta:Number = Math.ceil((100 - totalPerc) / percCount);
                for (i = 0; i < n; i++)
                {
                    child = dividedBox.getLayoutChildAt(i);
                    
                    if (!child.includeInLayout)
                        continue;
                    
                    changeObject = {child: child};
                    
                    if (vertical)
                    {
                        perc = child.percentHeight;
                        if (!isNaN(perc))
                        {
                            changeObject.percentHeight = child.percentHeight;
                            postLayoutChanges.push(changeObject);
                            
                            child.percentHeight = (perc + delta) * target.height;
                        }
                    }
                    else
                    {
                        perc = child.percentWidth;
                        if (!isNaN(perc))
                        {
                            changeObject.percentWidth = child.percentWidth;
                            postLayoutChanges.push(changeObject);
                            
                            child.percentWidth = (perc + delta) * target.width;
                        }
                    }
                }
            }
            
            // OK after all this magic we still can't guarantee that the space is
            // entirely filled. For example, all percent components hit their max
            // values. In this case, the layout will include empty space at the end,
            // and once the divider is touched, the non-percent based components
            // will be converted into percent based ones and fill the remaining
            // space. It seems to me that this scenario is highly unlikely.
            // Thus I've choosen the route of stretching the percent based
            // components and not touching the explicitly sized or default
            // sized ones.
            //
            // Another option would be to stretch the default sized components
            // either in addition to the percent based ones or instead of.
            // This seemed a  little odd to me as the user never indicated
            // that these components are to be stretched initially, so in the end
            // I choose to tweak the components that the user has indicated
            // as being stretchable. 
        }
        
        /**
         *  @private
         *  During preLayoutAdjustment, we make some changes to the children's
         *  widths and heights.  We keep track of the original values in postLayoutChanges
         *  so we can later go back and reset them so another layout pass is working 
         *  with the correct values rather than these modified values.
         */ 
        private var postLayoutChanges:Array;
        
        /**
         *  @private
         *  Post layout work.  In preLayoutAdjustment() 
         *  sometimes we set a child's percentWidth/percentHeight.  
         *  postLayoutAdjustment() will reset the child's width or height
         *  back to what it was.
         */
        private function postLayoutAdjustment():void
        {
            // each object has a child property and may have a set of width/height 
            // properties that it would like to be set
            var len:int = postLayoutChanges.length;
            for (var i:int = 0; i < len; i++)
            {
                var changeObject:Object = postLayoutChanges[i];
                
                if (changeObject.percentWidth !== undefined)
                    changeObject.child.percentWidth = changeObject.percentWidth;
                
                if (changeObject.percentHeight !== undefined)
                    changeObject.child.percentHeight = changeObject.percentHeight;
                
                if (changeObject.explicitWidth !== undefined)
                    changeObject.child.explicitWidth = changeObject.explicitWidth;
                
                if (changeObject.explicitHeight !== undefined)
                    changeObject.child.explicitHeight = changeObject.explicitHeight;
            }
            postLayoutChanges = null;
        }
		
	}
	
}
