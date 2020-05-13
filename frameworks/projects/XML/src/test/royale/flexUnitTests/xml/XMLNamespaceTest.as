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
package flexUnitTests.xml
{
    
    
    import flexUnitTests.xml.support.NamespaceTest;
    
    import org.apache.royale.test.asserts.*;

    COMPILE::SWF{
        import flash.system.Capabilities;
    }
    
   // import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLNamespaceTest
    {
    
        private namespace atom = "http://www.w3.org/2005/Atom";
        public static var ATOM_NS:Namespace = new Namespace("http://www.w3.org/2005/Atom");

        
        public static var isJS:Boolean = COMPILE::JS;
    
        private static var settings:Object;
        
        private static var source:String;
        
        [Before]
        public function setUp():void
        {

        }
        
        [After]
        public function tearDown():void
        {

        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            settings = XML.settings();
            source = '<xml><?xml-stylesheet type="text/xsl" media="screen" href="/~d/styles/rss2full.xsl"?>\n' +
                    '<?xml-stylesheet type="text/css" media="screen" href="http://feeds.feedburner.com/~d/styles/itemcontent.css"?>\n' +
                    '<rss xmlns:atom="http://www.w3.org/2005/Atom" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0" version="2.0"> \n' +
                    '\t<channel> \n' +
                    '\t\t<title>anonymized name</title> \n' +
                    '\t\t<link>http://www.anonymizedname.com</link> \n' +
                    '\t\t<description>code is beautiful</description> \n' +
                    '\t\t<language>en-us</language> \n' +
                    '\t\t<pubDate>Thu, 27 Sep 2018 12:27:44 -0700</pubDate> \n' +
                    '\t\t<lastBuildDate>Thu, 27 Sep 2018 12:27:44 -0700</lastBuildDate> \n' +
                    '\t\t<atom10:link xmlns:atom10="http://www.w3.org/2005/Atom" rel="self" type="application/rss+xml" href="http://feeds.feedburner.com/AnonymizedName" />\n' +
                    '\t\t<feedburner:info uri="anonymizedname" />\n' +
                    '\t\t<atom10:link xmlns:atom10="http://www.w3.org/2005/Atom" rel="hub" href="http://pubsubhubbub.appspot.com/" />\n' +
                    '\t\t<link random="this is a random link with default namespace" xmlns:atom10="http://www.w3.org/2005/Atom" rel="hub" href="http://pubsubhubbub.appspot.com/" />\n' +
                    '\t\t<item> \n' +
                    '\t\t\t<title>Twitch Live Firefox Extension</title> \n' +
                    '\t\t\t<link>http://feedproxy.google.com/~r/AnonymizedName/~3/bgP9j-roaZQ/</link> \n' +
                    '\t\t\t<pubDate>Thu, 27 Sep 2018 09:00:00 -0700</pubDate> \n' +
                    '\t\t\t<author>anonymizedname@gmail.com (Anonymized Name)</author> \n' +
                    '\t\t\t<guid isPermaLink="false">http://www.anonymizedname.com/blog/2018/09/27/twitch-live-firefox-extension/</guid> \n' +
                    '\t\t\t<description>&lt;p&gt;I have ported my Twitch Live browser extension for Google Chrome to Firefox. Twitch Live is a toolbar extension that makes it easy to see when your favoritie streamers on Twitch are live.&lt;/p&gt; &lt;p&gt;&lt;img src="/blog/images/posts/twitchlivefirefox/screenshot.png" alt="Drawing" style="width: 798px;"/&gt;&lt;/p&gt; &lt;p&gt;There are options to open streams in a new window or tab, to enable notifications, as well as filter out vod casts / reruns.&lt;/p&gt; &lt;p&gt;You can install the extension from the Firefox Add-Ons site. If you have sany issues, just leave a comment below.&lt;/p&gt;&lt;img src="http://feeds.feedburner.com/~r/AnonymizedName/~4/bgP9j-roaZQ" height="1" width="1" alt=""/&gt;</description> \n' +
                    '\t\t\t<feedburner:origLink>http://www.anonymizedname.com/blog/2018/09/27/twitch-live-firefox-extension/</feedburner:origLink>\n' +
                    '\t\t</item> \n' +
                    '\t</channel> \n' +
                    '</rss></xml>';
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
            source=null;
            XML.setSettings(settings);
        }
    
        public function getPlayerVersion():Number{
            COMPILE::SWF{
                import flash.system.Capabilities;
                var parts:Array = Capabilities.version.split(' ')[1].split(',');
                return Number( parts[0]+'.'+parts[1])
            }
            //something for js, indicating javascript 'playerversion' is consistent with more recent flash player versions:
            return 30;
        }

        public function getPlayerType():String{
            COMPILE::SWF{
                return Capabilities.playerType;
            }
            COMPILE::JS{
                return 'Browser';
            }
        }
        
    
        [Test]
        [TestVariance(variance="SWF",description="Standalone players on Windows between 11.2 and 20.0 were verified to have incorrect results with 'default xml namespace' in certain cases")]
        public function testMinimalDefault():void{
            default xml namespace = 'test';
            var xml:XML = <root/>;
            
            var ns:Namespace = xml.namespace();
            var playerVersion:Number = getPlayerVersion();
            //account for what appears to be a player bug in a range of player versions (not verified on Mac)
            // Javascript conforms to the latest swf behavior
            
            var permitEmptyString:Boolean  = /*playerVersion >= 11.2 &&*/ playerVersion <= 20.0 || getPlayerType() == 'StandAlone';
            var prefix:* = ns.prefix;
            var testIsOK:Boolean = permitEmptyString ? prefix === '' || prefix === undefined : prefix === undefined;
            
            //assertStrictlyEquals(ns.prefix, undefined, 'unexpected prefix value ');
            assertTrue(testIsOK, playerVersion+' unexpected prefix value :'+prefix);
            
            var uri:String = ns.uri;
            testIsOK = permitEmptyString ? uri == '' || uri == 'test' : uri == 'test';
            //assertEquals(ns.uri, 'test', 'unexpected uri value from specific default namespace');
            assertTrue(testIsOK, 'unexpected uri value from specific default namespace');
            
            //try top level function
            xml = XML('<root/>');
            ns= xml.namespace();
            prefix = ns.prefix;
            testIsOK = permitEmptyString ? prefix === '' || prefix === undefined : prefix === undefined;
            //assertStrictlyEquals(ns.prefix, undefined, 'unexpected prefix value');
            assertTrue(testIsOK, 'unexpected prefix value ');
            uri = ns.uri;
            testIsOK = permitEmptyString ? uri == '' || uri == 'test' : uri == 'test';
            //assertEquals(ns.uri, 'test', 'unexpected uri value from specific default namespace');
            assertTrue(testIsOK, 'unexpected uri value from specific default namespace');
        }
        
    
        [Test]
        public function basicNamespaceChecks():void{
            var ns:Namespace = new Namespace();
            
            assertStrictlyEquals(ns.uri,'', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,'', 'unexpected namespace prefix value');
            ns = new Namespace('');
            assertStrictlyEquals(ns.uri,'', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,'', 'unexpected namespace prefix value');
            ns = new Namespace("http://royale/");
            assertStrictlyEquals(ns.uri,"http://royale/", 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
            ns = new Namespace("royale", "http://royale/");
            assertStrictlyEquals(ns.uri,"http://royale/", 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,"royale", 'unexpected namespace prefix value');
            
            var ns2:Namespace = new Namespace(ns);
            assertStrictlyEquals(ns.uri,ns2.uri, 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,ns2.prefix, 'unexpected namespace prefix value');
            var err:Boolean = false;
            try{
                ns =  new Namespace("ns", "");
            } catch(e:Error){
                err = true;
            }
            assertTrue(err, 'expected an error')
        }
        
        
        
        
        
        [Test]
        public function testChildQueryWithNamespace():void{
            
            var xml:XML = new XML(source);
            
            var atomLinks:XMLList = xml.rss.channel.atom::link;
            assertEquals(atomLinks.length(),2, 'unexpected results from namespace based child query');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            
            assertEquals(atomLinks.toString().length, 459, 'unexpected list content length');
            

        }
    
    
        [Test]
        public function testDescendantsQueryWithNamespace():void{
            var xml:XML = new XML(source);
        
            var atomLinks:XMLList = xml..atom::link;
            assertEquals(atomLinks.length(),2, 'unexpected results from namespace based child query');
            //account for browser DOMParser variation to order of 'attributes' - use length comparison

            assertEquals(atomLinks.toString().length, 459, 'unexpected list content length');
      

        }
    
        [Test]
        public function testInscopeNamespaces():void{
            //needs a local var in the output
            namespace atom = "http://www.w3.org/2005/Atom"
    
            var feed:XML = new XML(
                    '<feed xmlns="http://www.w3.org/2005/Atom" xmlns:m="nothing">\n' +
                    '  <link rel="self" type="application/atom+xml" href="config/blahblah/user/123123" xmlns:blah="blah"/>'+
                    '  <link rel="customer" href="customer/999973324764966"/>\n' +
                    '  <link rel="domain" href="customer/443512501473324764966/domain/"/>\n' +
                    '  <link rel="tags" href="config/45545/domain/"/>\n' +
                    '  <m:link rel="nothing" href="config/45545/domain/"/>\n' +
                    '</feed>\n');
    
    
            var inscopes:Array = feed.inScopeNamespaces();
            
            assertEquals(inscopes.length, 2, 'unexpected namespace count');
            //account for browser DOMParser variation to order of 'attributes' - use length comparison
            assertEquals(inscopes.toString().length, 'http://www.w3.org/2005/Atom,nothing'.length, 'unexpected namespace content');

            
            var links:XMLList = feed.atom::link;
            var link1:XML = links[0];
    
            inscopes = link1.inScopeNamespaces();
    
            assertEquals(inscopes.length, 3, 'unexpected namespace count');
            //account for browser DOMParser variation to order of 'attributes' - use length comparison
            assertEquals(inscopes.toString().length, 'blah,http://www.w3.org/2005/Atom,nothing'.length, 'unexpected namespace content');

        }
    
        [Test]
        public function testNamespaceDeclarations():void{
            namespace atom = "http://www.w3.org/2005/Atom"
        
            var feed:XML = new XML(
                    '<feed xmlns="http://www.w3.org/2005/Atom" xmlns:m="nothing">\n' +
                    '  <link rel="self" type="application/atom+xml" href="config/blahblah/user/123123" xmlns:blah="blah"/>'+
                    '  <link rel="customer" href="customer/999973324764966"/>\n' +
                    '  <link rel="domain" href="customer/443512501473324764966/domain/"/>\n' +
                    '  <link rel="tags" href="config/45545/domain/"/>\n' +
                    '  <m:link rel="nothing" href="config/45545/domain/"/>\n' +
                    '</feed>\n');
        
        
            var declarations:Array = feed.namespaceDeclarations();
        
            assertEquals(declarations.length, 2, 'unexpected namespace count');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(declarations.toString().length, 'http://www.w3.org/2005/Atom,nothing'.length, 'unexpected namespace content');
    
        
            var links:XMLList = feed.atom::link;
            var link1:XML = links[0];
    
            declarations = link1.namespaceDeclarations();
        
            assertEquals(declarations.length, 1, 'unexpected namespace count');
            assertEquals(declarations.toString(), 'blah', 'unexpected namespace content');

        }
        
        [Test]
        public function testAddNamespace():void{
    
            var test1:Namespace = new Namespace('what',"what");
            var test2:Namespace = new Namespace('what',"what1");
            var feed:XML = new XML(
                    '<feed xmlns:delim="delimiter" xmlns="http://www.w3.org/2005/Atom" xmlns:what="what" xmlns:m="nothing" >\n' +
                    '  <link rel="self" type="application/atom+xml" href="config/blahblah/user/123123" xmlns:blah="blah"/>'+
                    '</feed>\n');
            
            var originalDeclarations:Array = feed.namespaceDeclarations();
    
            assertEquals(originalDeclarations.length, 4, 'unexpected namespace count');
    
            feed.addNamespace(test1);
            
            assertEquals(feed.inScopeNamespaces().indexOf(test1), -1, 'unexpected inScopeNamespaces presence');
            var latest:Array = feed.namespaceDeclarations();
            assertEquals(latest.indexOf(test1), 4, 'unexpected namespaceDeclarations location');
            assertEquals(latest.length, 5, 'unexpected namespaceDeclarations location');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(latest.toString().length, 'delimiter,http://www.w3.org/2005/Atom,what,nothing,what'.length, 'unexpected namespaceDeclarations location');
            
            feed.addNamespace(test2);
            latest = feed.namespaceDeclarations();
            assertEquals(latest.indexOf(test1), -1, 'unexpected namespaceDeclarations presence');
            assertEquals(latest.indexOf(test2), 4, 'unexpected namespaceDeclarations location');
            assertEquals(latest.length, 5, 'unexpected namespaceDeclarations location');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(latest.toString().length, 'delimiter,http://www.w3.org/2005/Atom,what,nothing,what1'.length, 'unexpected namespaceDeclarations location');
    
    
        }
        
    
        [Test]
        public function testUseNamespaceVariationsInsideClass():void{
           var testInstance:NamespaceTest = new NamespaceTest();
            
            var list:XMLList = testInstance.test1();
            
            assertEquals(list.length(), 4, 'unexpected list length');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(list.toXMLString().length, 466, 'unexpected list content');
            

            list = testInstance.test2();

            assertEquals(list.length(), 5, 'unexpected list length');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(list.toXMLString().length, 572, 'unexpected list content');
            
            
            list = testInstance.test3();

            assertEquals(list.length(), 4, 'unexpected list length');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(list.toXMLString().length, 466, 'unexpected list content');
    
    
          
            list = testInstance.test4();

            assertEquals(list.length(), 4, 'unexpected list length');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(list.toXMLString().length, 466, 'unexpected list content');
            
     
            list = testInstance.test11();
            assertEquals(list.length(), 5, 'unexpected list length');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(list.toXMLString().length, 618, 'unexpected list content');
            

            list = testInstance.test12();
            assertEquals(list.length(), 6, 'unexpected list length');
            //account for browser DOMParser variation to order of 'attrributes' - use length comparison
            assertEquals(list.toXMLString().length, 729, 'unexpected list content');

            
            list = testInstance.test13();
            assertEquals(list.length(), 4, 'unexpected list length');
            assertEquals(list.toXMLString().length, 506, 'unexpected list content');

            list = testInstance.test14();
            assertEquals(list.length(), 5, 'unexpected list length');
            assertEquals(list.toXMLString().length, 618, 'unexpected list content');
            

        
        }
    
    
        [Test]
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testUseNamespace():void{
            use namespace atom;
            namespace royale = "https://royale.apache.org"
            use namespace royale;
            var feed:XML = new XML(
                    '<feed xmlns="http://www.w3.org/2005/Atom" xmlns:royale="https://royale.apache.org">\n' +
                    '  <link rel="self" type="application/atom+xml" href="config/blahblah/user/123123"/>'+
                    '  <link rel="customer" href="customer/999973324764966"/>\n' +
                    '  <royale:link rel="self" href="customer/443512501473324764966/domain/"/>\n' +
                    '  <link rel="tags" royale:rel="self" href="config/45545/domain/"/>\n' +
                    '</feed>\n');
        
        
            //try filtered content;
        
            var url:String = feed.link.(@rel=="self").@href;
        

            assertEquals(url, 'config/blahblah/user/123123customer/443512501473324764966/domain/', 'unexpected query result');
        
            var links:XMLList = feed.link;
            assertEquals(links.toString().length, 581, 'unexpected query result');
            
            //IE11/Edge failure because of order
            /*assertEquals(links.toString(), '<link rel="self" type="application/atom+xml" href="config/blahblah/user/123123" xmlns="http://www.w3.org/2005/Atom" xmlns:royale="https://royale.apache.org"/>\n' +
                    '<link rel="customer" href="customer/999973324764966" xmlns="http://www.w3.org/2005/Atom" xmlns:royale="https://royale.apache.org"/>\n' +
                    '<royale:link rel="self" href="customer/443512501473324764966/domain/" xmlns="http://www.w3.org/2005/Atom" xmlns:royale="https://royale.apache.org"/>\n' +
                    '<link rel="tags" royale:rel="self" href="config/45545/domain/" xmlns="http://www.w3.org/2005/Atom" xmlns:royale="https://royale.apache.org"/>', 'unexpected query result');*/
        
        }
    
        [Test]
        public function testQueryWithAnyNamespace():void{
            var xml:XML = new XML(source);
        
            var anyLinks:XMLList = xml..*::link;
            assertEquals(anyLinks.length(),5, 'unexpected results from *any* namespace based descendants query');

        }
    
    
        [Test]
        public function testUnusualLanguageNamespaces():void{
            var xml:XML = new XML(source);
            
            //public: (seems to behave like 'default')
            var unusualLinks:XMLList = xml..public::link;
            assertEquals(unusualLinks.length(),3, 'unexpected results from public namespace based descendants query');

        
            //protected: (seems to behave like 'default')
            unusualLinks = xml..protected::link;
        
            assertEquals(unusualLinks.length(),3, 'unexpected results from protected namespace based descendants query');

            unusualLinks = xml..internal::link;
        
            assertEquals(unusualLinks.length(),0, 'unexpected results from internal namespace based descendants query');

        
            unusualLinks = xml..private::link;
        
            assertEquals(unusualLinks.length(),0, 'unexpected results from private namespace based descendants query');

            
        }
        
        [Test]
        public function testAddingWithNamespace():void{
            var data:XML =<xml/>;
            var NS_DEF:Namespace = new Namespace("myNS");

            var param:XML = <param>something</param>;

            var parameters:XML = data.NS_DEF::parameters[0];
            if (parameters == null) //which it should be
            {
                data.NS_DEF::parameters = ""; //<- bad codegen fix
                parameters = data.NS_DEF::parameters[0];
            }
            parameters.appendChild(param);

            assertEquals(data.toXMLString(), '<xml>\n' +
                    '  <parameters xmlns="myNS">\n' +
                    '    <param>something</param>\n' +
                    '  </parameters>\n' +
                    '</xml>', 'unexpected xml content');



            var somethingElse:String = 'anything';

            var properties:XML = data.NS_DEF::parameters[0];
            properties[new QName(NS_DEF.uri, somethingElse)] = 'anythingValue';
            
            assertEquals(data.toXMLString(), '<xml>\n' +
                    '  <parameters xmlns="myNS">\n' +
                    '    <param>something</param>\n' +
                    '    <anything>anythingValue</anything>\n' +
                    '  </parameters>\n' +
                    '</xml>', 'unexpected xml content');
        }
    }


}
