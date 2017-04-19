package org.apache.flex.textLayout.factory
{
	public class TLFFactory
	{
		/**
		 * Default ITLFFactory if one is not specified.
		 */
		private static var _defaultTLFFactory:ITLFFactory;
		public static function get defaultTLFFactory():ITLFFactory{
			if(_defaultTLFFactory == null)
				_defaultTLFFactory = new StandardTLFFactory();
			
			return _defaultTLFFactory;
		}
	}
}