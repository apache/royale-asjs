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
package  flexUnitTests.xml.support
{
    
    public class NamespaceTest {
        
        private namespace atom = "http://www.w3.org/2005/Atom";
        private namespace nothing = "nothing";
        
        public function NamespaceTest() {
            // constructor code
            
        }
    
        private  var feed:XML = new XML(
                '<feed xmlns="http://www.w3.org/2005/Atom" xmlns:m="nothing">\n' +
                '  <link rel="self" type="application/atom+xml" href="config/blahblah/user/123123"/>'+
                '  <link rel="customer" href="customer/999973324764966"/>\n' +
                '  <link rel="domain" href="customer/443512501473324764966/domain/"/>\n' +
                '  <link rel="tags" href="config/45545/domain/"/>\n' +
                '  <m:link rel="nothing" href="config/45545/domain/"/>\n' +
                '</feed>\n');
    
    
        private  var feed2:XML = new XML(
                '<feed xmlns:atom="http://www.w3.org/2005/Atom" xmlns:m="nothing">\n' +
                '  <atom:link rel="self" type="application/atom+xml" href="config/blahblah/user/123123"/>'+
                '  <atom:link rel="customer" href="customer/999973324764966"/>\n' +
                '  <atom:link rel="domain" href="customer/443512501473324764966/domain/"/>\n' +
                '  <atom:link rel="tags" href="config/45545/domain/"/>\n' +
                '  <m:link rel="nothing" href="config/45545/domain/"/>\n' +
                '  <link rel="no_namespace" href="blah/12321/domain/"/>\n' +
                '</feed>\n');
    
        public function test1():XMLList{
            use namespace atom;
            //no conflict with namespace name and local var name:
            var atom1:XMLList = feed.link;
            return atom1;
        }
    
        public function test1a():XMLList{
            use namespace atom;
            //conflict between namespace name and local var name:
            var atom:XMLList = feed.link;
            return atom;
        }
    
        public function test2():XMLList{
            use namespace atom;
            use namespace nothing;
            //no conflict with namespace name and local var name, multiple use directives
            var atom1:XMLList = feed.link;
            return atom1
        }
    
        public function test2a():XMLList{
            use namespace atom;
            use namespace nothing;
            //conflict with namespace name and local var name, multiple use directives
            var atom:XMLList = feed.link;
            return atom
        }
    
        public function test3():XMLList{
            //explicit namespace usage
            var atomSpace:Namespace = new Namespace('http://www.w3.org/2005/Atom');
        
            var atom:XMLList = feed.atomSpace::link;
            return atom;
        }
    
    
        public function test4():XMLList{
            //explicit QName
        
            var atom:XMLList = feed.child(new QName('http://www.w3.org/2005/Atom','link'));
            return atom;
        }
    
        public function test5():XMLList{
            //explicit QName children filter
            const atomLink:QName = new QName('http://www.w3.org/2005/Atom','link');
            var atom:XMLList = feed.children().(name()==atomLink);
            return atom;
        }
    
        /*public function test6():XMLList{
            //explicit QNames children filter
            const atomLink:QName = new QName('http://www.w3.org/2005/Atom','link');
            const nothingLink:QName = new QName('nothing','link');
            var atom:XMLList = feed.children().(atomLink || nothingLink);
            return atom;
        }*/
        
        
        public function test7():XMLList{
            var atomSpace:Namespace = new Namespace('http://www.w3.org/2005/Atom');
    
            var atom:XMLList = feed.atomSpace::link;
            atom = atom.@rel;
            return atom;
        }
    
    
        public function test11():XMLList{
            use namespace atom;
            //no conflict with namespace name and local var name:
            var atom1:XMLList = feed2.link;
            return atom1;
        }
    
        public function test11a():XMLList{
            use namespace atom;
            //conflict between namespace name and local var name:
            var atom:XMLList = feed2.link;
            return atom;
        }
    
        public function test12():XMLList{
            use namespace atom;
            use namespace nothing;
            //no conflict with namespace name and local var name, multiple use directives
            var atom1:XMLList = feed2.link;
            return atom1
        }
    
        public function test12a():XMLList{
            use namespace atom;
            use namespace nothing;
            //conflict with namespace name and local var name, multiple use directives
            var atom:XMLList = feed2.link;
            return atom
        }
    
        public function test13():XMLList{
            //explicit namespace usage
            var atomSpace:Namespace = new Namespace('http://www.w3.org/2005/Atom');
        
            var atom:XMLList = feed2.atomSpace::link;
            return atom;
        }
    
    
        public function test14():XMLList{
            //explicit QName
        
            var atom:XMLList = feed2.child(new QName('http://www.w3.org/2005/Atom','link'));
            return atom;
        }
    
    
        public function test16():XMLList{
            //explicit QName children filter
            const atomLink:QName = new QName('http://www.w3.org/2005/Atom','link');
            var atom:XMLList = feed2.children().('link' == name());
            return atom;
        }
    
        public function test16a():XMLList{
            //explicit QName children filter
            const atomLink:QName = new QName('http://www.w3.org/2005/Atom','link');
            var atom:XMLList = feed2.children().(name() == atomLink);
            return atom;
        }
    
        //@todo process generated filter function for namespaces
        public function test15():XMLList{
            //explicit QName children filter
            const atomLink:QName = new QName('http://www.w3.org/2005/Atom','link');
            var atom:XMLList = feed2.children().(atomLink == name());
            return atom;
        }
    }
    
}
