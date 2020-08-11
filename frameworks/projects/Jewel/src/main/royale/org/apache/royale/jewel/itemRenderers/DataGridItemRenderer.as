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
package org.apache.royale.jewel.itemRenderers
{
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.ILabelFunction;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.util.getLabelFromData;

    /**
	 *  The DataGridItemRenderer defines the basic Item Renderer for a Jewel DataGrid Component.
     *  For now is just a ListItemRenderer that populates some values from Jewel DataGridColumn.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class DataGridItemRenderer extends ListItemRenderer
	{
        public function DataGridItemRenderer()
		{
			super();

			typeNames = "jewel item datagrid";
        }

		/**
		 * Proxy the ILabelFunction bead if provided in the DataGrid to the DataGridListColumn
		 */
		override public function get labelFunctionBead():ILabelFunction {
			if(!_labelFunctionBead) {
				//itemRendererOwnerView.host is DataGridColumnList -> parent is DataGridListArea -> parent is DataGrid
				
				// first try to retrieve from the DataGridColumnList
				_labelFunctionBead = itemRendererOwnerView.host.getBeadByType(ILabelFunction) as ILabelFunction;

				// if not exists try to retrieve from the DataGrid root
				if(!_labelFunctionBead)
					_labelFunctionBead = ((itemRendererOwnerView.host.parent as IChild).parent as IStrand).getBeadByType(ILabelFunction) as ILabelFunction;
			}
			return _labelFunctionBead;
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *  If the user provided a LabelFunction bead and set a custom labelFunction, then use it instead
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        override public function set data(value:Object):void
        {
			if(labelFunctionBead && labelFunctionBead.labelFunction)
				text = labelFunctionBead.labelFunction(value, itemRendererOwnerView.host);
			else
            	text = getLabelFromData(this, value);
            
			if (value != data)
            {
                _data = value;
                dispatchEvent(new Event("dataChange"));
            }
        }
    }
}