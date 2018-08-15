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
    
    import org.apache.royale.text.engine.FontLookup;
    import org.apache.royale.text.engine.Kerning;
    import org.apache.royale.textLayout.formats.TextLayoutFormat;
    import org.apache.royale.textLayout.property.Property;
    //import org.apache.royale.textLayout.tlf_internal;
    import mx.core.mx_internal;
    import mx.styles.IStyleClient;
    
    [ExcludeClass]
    
    /**
     *  @private
     *  This class is used by components such as RichText
     *  and RichEditableText which use TLF to display their text.
     *  The default formatting for their text is determined
     *  by the component's CSS styles.
     *
     *  TLF recognizes the copy that is done in this constructor and does not
     *  do another one. If TLF adds formats to TextLayoutFormats this should
     *  continue to work as long as Flex doesn't want some alterate behavior.
     *
     *  The only extra functionality supported here, beyond what TLF has,
     *  is the ability for the fontLookup style to have the value "auto";
     *  in this case, the client object's embeddedFontContext is used
     *  to determine whether the the fontLookup format in TLF should be
     *  "embeddedCFF" or "device".
     */
    public class CSSTextLayoutFormat extends TextLayoutFormat
    {
//        include "../core/Version.as";
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  Constructor
         */
        public function CSSTextLayoutFormat(client:IStyleClient)
        {
            super();
            
            for each (var prop:Property in TextLayoutFormat.description)
            {
                const propName:String = prop.name;
                if (propName == "fontLookup")
                {
                    this[propName] = convertedFontLookup(client);
                }
                else if (propName == "kerning")
                {
                    this[propName] = convertedKerning(client);
                }
                else
                {
                    const value:* = client.getStyle(propName);
                    if (value !== undefined)
                        this[propName] = value;
                }
            }		
        }
        
        
        /**
         *  @private
         */
        private static function convertedFontLookup(client:IStyleClient):*
        {
            var value:String = client.getStyle("fontLookup");
            
            // Special processing of the "auto" value is required,
            // because this value has meaning only in Flex, not in TLF.
            // It tells Flex to use its EmbeddedFontRegistry to determine
            // whether the font is embedded or not.
            if (value == "auto")
            {
                if (client.mx_internal::embeddedFontContext)
                    value = FontLookup.EMBEDDED_CFF;
                else
                    value = FontLookup.DEVICE;
            }
            
            return value;
        }
        
        
        /**
         *  @private
         */
        private static function convertedKerning(client:IStyleClient):*
        {
            var kerning:Object = client.getStyle("kerning");
            
            // In Halo components based on TextField,
            // kerning is supposed to be true or false.
            // The default in TextField and Flex 3 is false
            // because kerning doesn't work for device fonts
            // and is slow for embedded fonts.
            // In Spark components based on TLF and FTE,
            // kerning is "auto", "on", or, "off".
            // The default in TLF and FTE is "auto"
            // (which means kern non-Asian characters)
            // because kerning works even on device fonts
            // and has miminal performance impact.
            // Since a CSS selector or parent container
            // can affect both Halo and Spark components,
            // we need to map true to "on" and false to "off"
            // here and in Label.
            // For Halo components, UITextField and UIFTETextField
            // do the opposite mapping
            // of "auto" and "on" to true and "off" to false.
            // We also support a value of "default"
            // (which we set in the global selector)
            // to mean "auto" for Spark and false for Halo
            // to get the recommended behavior in both sets of components.
            if (kerning === "default")
                kerning = Kerning.AUTO;
            else if (kerning === true)
                kerning = Kerning.ON;
            else if (kerning === false)
                kerning = Kerning.OFF;
            
            return kerning;
        }
    }
    
}

