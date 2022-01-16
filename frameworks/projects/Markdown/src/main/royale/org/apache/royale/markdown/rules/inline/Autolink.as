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
package org.apache.royale.markdown
{
	import org.apache.royale.utils.string.sanitizeUrl;

	/**
	 * Process autolinks '<protocol:...>'
	 */
	public class Autolink extends Rule
	{
		private function Autolink()
		{
			
		}

		private static var _instance:Autolink;
		public static function get():Autolink
		{
			if(!_instance)
				_instance = new Autolink();
			
			return _instance;
		}
		private const EMAIL_RE:RegExp    = /^<([a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)>/;
		private const AUTOLINK_RE:RegExp = /^<([a-zA-Z.\-]{1,25}):([^<>\x00-\x20]*)>/;

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9		 * 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			// var tail, linkMatch, emailMatch, url, fullUrl, 
			var state:InlineState = istate as InlineState;
			var pos:int = state.position;

			if (state.src.charCodeAt(pos) !== 0x3C/* < */) { return false; }

			var tail:String = state.src.slice(pos);

			if (tail.indexOf('>') < 0) { return false; }

			var linkMatch:Array = tail.match(AUTOLINK_RE);

			if (linkMatch) {
				if (urlSchema.indexOf(linkMatch[1].toLowerCase()) < 0) { return false; }

				var url:String = linkMatch[0].slice(1, -1);
				var fullUrl:String = sanitizeUrl(url);
				// if (!state.parser.validateLink(url)) { return false; }

				if (!silent) {
					var token:LinkToken = new LinkToken('link_open',state.level);
					token.href = fullUrl;
					state.push(token);
					// state.push({
					// 	type: 'link_open',
					// 	href: fullUrl,
					// 	level: state.level
					// });
					state.push(new ContentToken('text',url,state.level + 1));
					// state.push({
					// 	type: 'text',
					// 	content: url,
					// 	level: state.level + 1
					// });
					state.push(new TagToken('link_close',state.level));
					// state.push({ type: 'link_close', level: state.level });
				}

				state.position += linkMatch[0].length;
				return true;
			}

			var emailMatch:Array = tail.match(EMAIL_RE);

			if (emailMatch) {

				url = emailMatch[0].slice(1, -1);

				fullUrl = sanitizeUrl('mailto:' + url);
				//TODO validate?
				// if (!state.parser.validateLink(fullUrl)) { return false; }

				if (!silent) {
					token = new LinkToken('link_open',state.level);
					token.href = fullUrl;
					state.push(token);
					// state.push({
					// 	type: 'link_open',
					// 	href: fullUrl,
					// 	level: state.level
					// });
					state.push(new ContentToken('text',url,state.level + 1));
					// state.push({
					// 	type: 'text',
					// 	content: url,
					// 	level: state.level + 1
					// });
					state.push(new TagToken('link_close',state.level));
					// state.push({ type: 'link_close', level: state.level });
				}

				state.position += emailMatch[0].length;
				return true;
			}

			return false;

		}

		private var urlSchema:Array = ['coap','doi','javascript','aaa','aaas','about','acap','cap','cid','crid','data','dav','dict','dns',
			'file','ftp','geo','go','gopher','h323','http','https','iax','icap','im','imap','info','ipp','iris','iris.beep','iris.xpc',
			'iris.xpcs','iris.lwz','ldap','mailto','mid','msrp','msrps','mtqp','mupdate','news','nfs','ni','nih','nntp','opaquelocktoken','pop',
			'pres','rtsp','service','session','shttp','sieve','sip','sips','sms','snmp','soap.beep','soap.beeps','tag','tel','telnet','tftp',
			'thismessage','tn3270','tip','tv','urn','vemmi','ws','wss','xcon','xcon-userid','xmlrpc.beep','xmlrpc.beeps','xmpp','z39.50r',
			'z39.50s','adiumxtra','afp','afs','aim','apt','attachment','aw','beshare','bitcoin','bolo','callto','chrome','chrome-extension',
			'com-eventbrite-attendee','content','cvs','dlna-playsingle','dlna-playcontainer','dtn','dvb','ed2k','facetime','feed','finger',
			'fish','gg','git','gizmoproject','gtalk','hcp','icon','ipn','irc','irc6','ircs','itms','jar','jms','keyparc','lastfm','ldaps',
			'magnet','maps','market','message','mms','ms-help','msnim','mumble','mvn','notes','oid','palm','paparazzi','platform','proxy',
			'psyc','query','res','resource','rmi','rsync','rtmp','secondlife','sftp','sgn','skype','smb','soldat','spotify','ssh','steam',
			'svn','teamspeak','things','udp','unreal','ut2004','ventrilo','view-source','webcal','wtai','xfire','wyciwyg','xri','ymsgr'];

	}
}