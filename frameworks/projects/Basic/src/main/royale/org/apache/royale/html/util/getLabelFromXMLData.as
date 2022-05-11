////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.html.util
{

    import org.apache.royale.core.IHasLabelField;
    import org.apache.royale.core.IHasDataField;

    /**
     *  Utility function to get a label string from an XML value object
     *  It will use the following logic flow:
     *  First it tries a `labelField`
     *  Then the `dataField`
     *  If both of those fail, it tries a `label` attribute
     *  if that fails, it tries a <label>labelHere</label> child
     *  If all else fails, it just converts the object to a string
     * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
     *  @royaleignorecoercion org.apache.royale.core.IHasLabelField
     *  @royaleignorecoercion org.apache.royale.core.IHasDataField
     *  @royaleignorecoercion XML
     */
    public function getLabelFromXMLData(obj:Object, data:Object):String
    {
        var result:String;

        if (obj is IHasLabelField && (obj as IHasLabelField).labelField)
        {
            //if the result is null in this case, we should return "";
            result = getLabelFromLabelField((obj as IHasLabelField).labelField, data as XML, "");
            return result;
        } 
            
        if (obj is IHasDataField && (obj as IHasDataField).dataField)
        {
            //if the result is null in this case, we should return "";
            result = getLabelFromLabelField((obj as IHasDataField).dataField, data as XML, "");
            return result;
        }

        result = getLabelFromLabelField("@label", data as XML);
        if(result != null)
        {
            return result;
        }

        result = getLabelFromLabelField("label", data as XML);
        if(result != null)
        {
            return result;
        }
        return "" + data;
    }

}

/**
 *
 * @private
 * @royaleignorecoercion XMLList
 */
function getLabelFromLabelField(labelField:String, data:XML, defaultVal:String = null):String
{
    var xmlList:XMLList ;
    if (labelField.charAt(0) == '@')
    {
        xmlList =  data.attribute(labelField.substr(1));
    }
    else {
        xmlList = data.child(labelField);
    }
    return xmlList.length() ? xmlList.toString() : defaultVal;
}