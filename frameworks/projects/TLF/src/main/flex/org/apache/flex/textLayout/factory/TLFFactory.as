package org.apache.flex.textLayout.factory
{
	public class TLFFactory
	{
		/**
		 * Default ITLFFactory if one is not specified.
		 */
		public static var defaultTLFFactory:ITLFFactory = new StandardTLFFactory();
	}
}