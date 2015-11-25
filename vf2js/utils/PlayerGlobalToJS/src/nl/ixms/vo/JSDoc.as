package nl.ixms.vo
{

import nl.ixms.Utils;

import org.as3commons.reflect.Parameter;

public final class JSDoc
{
	public static const CONSTRUCTOR:String = 'constructor';
	public static const INTERFACE:String = 'interface';
	public static const METADATA:String = 'metadata';
	public static const METHOD:String = 'method';
	public static const FIELD:String = 'field';
	
	private static const JSDOC_END:String = ' */\n';
	private static const JSDOC_LINE:String = ' *';
	private static const JSDOC_START:String = '/**\n';
	
	public static function emitJSDoc(which:String, ...parameters):String {
		var i:int, n:int, parameter:Parameter, result:String;
		
		result = JSDOC_START;
		
		switch (which) {
			case CONSTRUCTOR :
			case INTERFACE :
				if (which === INTERFACE) {
					result += JSDOC_LINE + ' @interface\n';
				} else {
					result += JSDOC_LINE + ' @constructor\n';
					result += JSDOC_LINE + ' @struct\n';
				}
				if (parameters[0] && parameters[0] !== '' && parameters[0] !== 'Object') {
					result += JSDOC_LINE + ' @extends {' + parameters[0] + '}\n';
				}
				if (parameters[1] && parameters[1] !== '') {
					for (i = 0, n = parameters[1].length; i < n; i++) {
						result += JSDOC_LINE + ' @implements {' + parameters[1][i] + '}\n';
					}
				}
				if (parameters[2]) {
					for (i = 0, n = parameters[2].length; i < n; i++) {
						parameter = Parameter(parameters[2][i]);
						result += JSDOC_LINE + ' @param {' + 
							Utils.parseType(parameter.type.name) + 
							((parameter.isOptional) ? '=' : '') + 
							'} ' +
							((parameter.isOptional) ? 'opt_' : '') + 
							'arg' + i +
							' Argument ' + i +
							((parameter.isOptional) ? ' (optional)' : '') + 
							'\n';
					}
				}
				
				break;
			
			case METADATA :
				result += JSDOC_LINE + ' Metadata\n';
				result += JSDOC_LINE + '\n';
				result += JSDOC_LINE + ' @type {Object.<string, Array.<Object>>}\n';
				
				break;
			
			
			case METHOD :
				result += JSDOC_LINE + ' ' + parameters[0] + '\n';
				
				if (parameters[1] && parameters[1].length > 0) {
					result += JSDOC_LINE + '\n';
					for (i = 0, n = parameters[1].length; i < n; i++) {
						parameter = Parameter(parameters[1][i]);
						result += JSDOC_LINE + ' @param {' + 
							Utils.parseType(parameter.type.name) + 
							((parameter.isOptional) ? '=' : '') + 
							'} ' +
							((parameter.isOptional) ? 'opt_' : '') + 
							'arg' + i +
							' Argument ' + i +
							((parameter.isOptional) ? ' (optional)' : '') + 
							'\n';
					}
				}
				if (parameters[2]) {
					result += JSDOC_LINE + '\n';
					result += JSDOC_LINE + ' @return {' + parameters[2] + '}\n';
				}
				
				break;
			
			case FIELD :
				result += JSDOC_LINE + ' ' + parameters[0] + '\n';
				result += JSDOC_LINE + '\n';
				result += JSDOC_LINE + ' @type {' + parameters[1] + '}\n';
				
				break;
			
			default :
				break;
		}
		
		result += JSDOC_END;
		
		return result;
	};
	
	public function JSDoc() {}
	
}
}