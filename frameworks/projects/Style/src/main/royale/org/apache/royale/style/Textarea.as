// //////////////////////////////////////////////////////////////////////////////
// 
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// //////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style
{
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }
    import org.apache.royale.style.elements.Textarea;

    public class Textarea extends org.apache.royale.style.elements.Textarea
    {
        public function Textarea()
        {
            super();
        }


        public function get minlength():String
        {
            COMPILE::JS
            {
                return element["minLength"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set minlength(value:String):void
        {
            COMPILE::JS
            {
                element["minLength"] = parseInt(value);
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get maxlength():String
        {
            COMPILE::JS
            {
                return element["maxLength"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set maxlength(value:String):void
        {
            COMPILE::JS
            {
                element["maxLength"] = parseInt(value);
            }
            COMPILE::SWF
            {
                return;

            }
        }

        COMPILE::JS

        public function get spellcheck():String
        {
            COMPILE::JS
            {
                return element["spellcheck"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set spellcheck(value:String):void
        {
            COMPILE::JS
            {
                element["spellcheck"] = (value == "true");
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get wrap():String
        {
            COMPILE::JS
            {
                return element["wrap"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set wrap(value:String):void
        {
            COMPILE::JS
            {
                element["wrap"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get form():String
        {
            COMPILE::JS
            {
                return element["form"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set form(value:String):void
        {
            COMPILE::JS
            {
                element["form"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get dirname():String
        {
            COMPILE::JS
            {
                return element["dirName"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set dirname(value:String):void
        {
            COMPILE::JS
            {
                element["dirName"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get autocorrect():String
        {
            COMPILE::JS
            {
                return element["autocorrect"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set autocorrect(value:String):void
        {
            COMPILE::JS
            {
                element["autocorrect"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get autocomplete():String
        {
            COMPILE::JS
            {
                return element["autocomplete"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set autocomplete(value:String):void
        {
            COMPILE::JS
            {
                element["autocomplete"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get autocapitalize():String
        {
            COMPILE::JS
            {
                return element["autocapitalize"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set autocapitalize(value:String):void
        {
            COMPILE::JS
            {
                element["autocapitalize"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

    }
}
