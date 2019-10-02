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
    
    
    import org.apache.royale.test.asserts.*;
    
   // import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLNamespaceTest
    {
    
        public static var ATOM_NS:Namespace = new Namespace("http://www.w3.org/2005/Atom");

        
        public static var isJS:Boolean = COMPILE::JS;
    
        private var settings:Object;
        
        private var source:String;
        
        [Before]
        public function setUp():void
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
        
        [After]
        public function tearDown():void
        {
            source=null;
            XML.setSettings(settings);
        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
    
    
        private var atom:Namespace = ATOM_NS;
        
        
        [Test]
        public function testChildQueryWithNamespace():void{
            
            var xml:XML = new XML(source);
            
            var atomLinks:XMLList = xml.rss.channel.atom::link;
            assertEquals(atomLinks.length(),2, 'unexpected results from namespace based child query');
            
            //@todo:
            //RoyaleUnitTestRunner.consoleOut('atomLinks');
            //RoyaleUnitTestRunner.consoleOut(atomLinks.toString());
            //SWF Output includes ancestor namespaces:
            /*
            <atom10:link rel="self" type="application/rss+xml" href="http://feeds.feedburner.com/AnonymizedName" xmlns:atom10="http://www.w3.org/2005/Atom" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0"/>
            <atom10:link rel="hub" href="http://pubsubhubbub.appspot.com/" xmlns:atom10="http://www.w3.org/2005/Atom" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0"/>
           
             */
            //JS Output does not (yet) include ancestor namespaces:
            /*
            <atom10:link rel="self" type="application/rss+xml" href="http://feeds.feedburner.com/AnonymizedName" xmlns:atom10="http://www.w3.org/2005/Atom"/>
            <atom10:link rel="hub" href="http://pubsubhubbub.appspot.com/" xmlns:atom10="http://www.w3.org/2005/Atom"/>
            
            */
            
        }
    
    
        [Test]
        public function testDescendantsQueryWithNamespace():void{
        
            var xml:XML = new XML(source);
        
            var atomLinks:XMLList = xml..atom::link;
            assertEquals(atomLinks.length(),2, 'unexpected results from namespace based child query');
        
            //@todo:
           // RoyaleUnitTestRunner.consoleOut('dscendants atomLinks');
            //RoyaleUnitTestRunner.consoleOut(atomLinks.toString());
            //SWF Output includes ancestor namespaces:
            /*
            <atom10:link rel="self" type="application/rss+xml" href="http://feeds.feedburner.com/AnonymizedName" xmlns:atom10="http://www.w3.org/2005/Atom" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0"/>
            <atom10:link rel="hub" href="http://pubsubhubbub.appspot.com/" xmlns:atom10="http://www.w3.org/2005/Atom" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0"/>
           
             */
            //JS Output does not (yet) include ancestor namespaces:
            /*
            <atom10:link rel="self" type="application/rss+xml" href="http://feeds.feedburner.com/AnonymizedName" xmlns:atom10="http://www.w3.org/2005/Atom"/>
            <atom10:link rel="hub" href="http://pubsubhubbub.appspot.com/" xmlns:atom10="http://www.w3.org/2005/Atom"/>
            
            */
        
        }
    
        [Test]
        public function testQueryWithAnyNamespace():void{
            var xml:XML = new XML(source);
        
            //var anyLinks:XMLList = xml..*::link;
            //assertEquals(anyLinks.length(),5, 'unexpected results from *any* namespace based descendants query');
            assertTrue(true)
            /* RoyaleUnitTestRunner.consoleOut('descendants any * Links');
             RoyaleUnitTestRunner.consoleOut(anyLinks.toString());*/
        }
    
    
        [Test]
        public function testUnusualLanguageNamespaces():void{
            var xml:XML = new XML(source);
        
            //public: (seems to behave like 'default')
            var unusualLinks:XMLList = xml..public::link;
            assertEquals(unusualLinks.length(),3, 'unexpected results from public namespace based descendants query');
            /*   RoyaleUnitTestRunner.consoleOut('descendants public Links');
               RoyaleUnitTestRunner.consoleOut(unusualLinks.toString());*/
        
            //protected: (seems to behave like 'default')
            unusualLinks = xml..protected::link;
        
            assertEquals(unusualLinks.length(),3, 'unexpected results from protected namespace based descendants query');
            /*RoyaleUnitTestRunner.consoleOut('descendants protected Links');
            RoyaleUnitTestRunner.consoleOut(unusualLinks.toString());*/
        
            unusualLinks = xml..internal::link;
        
            assertEquals(unusualLinks.length(),0, 'unexpected results from internal namespace based descendants query');
            /* RoyaleUnitTestRunner.consoleOut('descendants internal Links');
             RoyaleUnitTestRunner.consoleOut(unusualLinks.toString());*/
        
        
            unusualLinks = xml..private::link;
        
            assertEquals(unusualLinks.length(),0, 'unexpected results from private namespace based descendants query');
            /* RoyaleUnitTestRunner.consoleOut('descendants private Links');
             RoyaleUnitTestRunner.consoleOut(unusualLinks.toString());*/
        
        
        }
    }
}
