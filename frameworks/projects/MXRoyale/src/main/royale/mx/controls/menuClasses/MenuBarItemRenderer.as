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

package mx.controls.menuClasses
{
import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.core.layout.EdgeData;
import org.apache.royale.html.supportClasses.StringItemRenderer;

/**
 *  The ListItemRenderer is the default renderer for mx.controls.List
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */

public class MenuBarItemRenderer extends StringItemRenderer
{

	public function MenuBarItemRenderer()
	{
		super();
		typeNames += " MenuBarItemRenderer";
	}
	
    override public function set text(value:String):void
    {
        super.text = value;
        COMPILE::SWF
        {
            var edge:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(this);
            var h:Number = textField.textHeight + edge.top + edge.bottom;
            textField.autoSize = "none";
            textField.height = h;
        }
    }
    
    override protected function dataToString(value:Object):String
    {
        if (value is XML)
        {
            var xml:XML = value as XML;
            return xml.attribute(labelField).toString();
        }
        return super.dataToString(value);
    }

}

}
