package net.sfmultimedia.argonaut
{
	import flash.utils.getQualifiedClassName;

	/**
	 * <p>Takes any AS instance and convert its public, non-static properties to JSON.</p>
	 * 
	 * <p>Essentially, this is just a souped up version of <code>JSON.stringify()</code>, adding two features:</p>
	 * 
	 * <ul>
	 * <li>Classes may specify a <code>[DontSerialize]</code> metatag so that you can suppress properties you don't wish to serialize.
	 * NB: use of the [DontSerialize] metatag requires <code>-keep-as3-metadata+=“DontSerialize”</code> to be marked in the compiler</li>
	 * <li>Complex classes are tagged with an alias (this can be turned off)</li>
	 * </ul>
	 * 
	 * Options:
	 * <ul>
	 * <li>If you set <code>ArgonautConfig.nativeEncodeMode</code> to true, encoding will go directly to the native <code>JSON.stringify()</code> method,
	 * which encodes faster, but doesn't respect <code>DontSerialize</code>, and won't auto-tag.</li>
	 * <li>You can change the name of the auto-tag from default "__jsonclass__" by setting <code>ArgonautConfig.aliasId="SomethingElse"</code></li>
	 * <li>You can suppress tagging by setting <code>ArgonautConfig.tagClassesWhenEncoding=false</code></li>
	 * </ul>
	 * 
	 * @see ArgonautConfig
	 * 
	 * @author mtanenbaum
	 * 
	 * @internal
	 * Argonaut is released under the MIT License
	 * Copyright (C) 2012, Marc Tanenbaum
	 *
	 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
	 * files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	 * modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
	 * Software is furnished to do so, subject to the following conditions:
	 *
	 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	 *
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
	 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
	 * OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
	 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	 */
	public class JSONEncoder
	{
		/** The configuration of the current Argonaut instance */
		private static var config:ArgonautConfig = new ArgonautConfig();
		/** Stores instance identifiers to prevent cyclic encoding */
		private static var instanceRegistrar:Array;

		/**
		 * Serialize the class's public instance properties into JSON
		 * 
		 * @param instance	The instance we want to process
		 * @param config	The configuration of the Argonaut instance we're currently using
		 * 
		 * @return	The instance expressed as a JSON string
		 */
		public static function stringify(instance:*, config:ArgonautConfig = null):String
		{
			if (config != null)
			{
				JSONEncoder.config = config;
			}
			
			if (JSONEncoder.config.nativeEncodeMode)
			{
				return JSON.stringify(instance);
			}

			instanceRegistrar = [];
			var retv:String = parseElement(instance);
			instanceRegistrar = null;

			return retv;
		}

		/**
		 * Recursively parse the nodes of the instance and assign the public values to the JSON output
		 * 
		 * @param instance	The instance we're deconstructing
		 * @param type		The associated datatype (can be null whenever we're at the top of an Object or Array)
		 * 
		 * @return Some JSON-formatted text
		 */
		private static function parseElement(instance:*, type:String = null):String
		{
			var retv:String = "";
			if (instance == null)
			{
				return retv;
			}

			var classObject:Class = ClassRegister.registerClassByInstance(instance);
			if (type == null)
			{
				type = getQualifiedClassName(classObject);
			}

			if (type.indexOf(ArgonautConstants.VECTOR) > -1)
			{
				type = ArgonautConstants.VECTOR;
			}

			// Recursive reference protection.
			var index:int = instanceRegistrar.indexOf(instance);
			if (index > -1 && instance === instanceRegistrar[index])
			{
				// Primitives are safe
				if (instance is Number || instance is Boolean || instance is String)
				{
					// No-op
				}
				else
				{
					throw new Error("ERROR: Cyclic reference found. ArgonautJSONEncoder does not permit recursive references.");
				}
			}
			instanceRegistrar[instanceRegistrar.length] = instance;

			switch(type)
			{
				case ArgonautConstants.STRING:
					retv += "\"" + escape(instance) + "\"";
					break;
				case ArgonautConstants.BOOLEAN:
				case ArgonautConstants.INT:
				case ArgonautConstants.NUMBER:
				case ArgonautConstants.UINT:
					retv += instance;
					break;
				case ArgonautConstants.OBJECT:
				case ArgonautConstants.STAR:
					var elementCount:uint = 0;
					for (var instanceProp:String in instance)
					{
						retv += "\"" + instanceProp + "\"" + ":" + parseElement(instance[instanceProp]) + ",";
						elementCount++;
					}
					retv = (elementCount > 0) ? "{" + retv.substr(0, retv.length - 1) + "}" : instance;
					// Sometimes an Object is just an object
					break;
				case ArgonautConstants.ARRAY:
					retv += "[";
					var len:uint = (instance as Array).length;
					if (len == 0)
					{
						retv += "]";
					}
					else
					{
						for (var a:uint = 0; a < len; a++)
						{
							retv += parseElement(instance[a], null) + ",";
						}
						retv = retv.substr(0, retv.length - 1) + "]";
					}
					break;
				case ArgonautConstants.VECTOR:
					retv += "[";
					len = instance.length;
					if (len == 0)
					{
						retv += "]";
					}
					else
					{
						for (var b:uint = 0; b < len; b++)
						{
							retv += parseElement(instance[b], null) + ",";
						}
						retv = retv.substr(0, retv.length - 1) + "]";
					}
					break;
				default:
					// For everything else, we use the ArgonautClassRegister
					retv += "{";
					var description:Object = ClassRegister.getClassMap(classObject);
					if (JSONEncoder.config.tagClassesWhenEncoding)
					{
						retv += "\"" + JSONEncoder.config.aliasId + "\":\"" + getQualifiedClassName(classObject) + "\",";
					}
					for (var node:String in description)
					{
						var result:String = parseElement(instance[node], PropertyTypeMapping(description[node]).type);
						retv += result ? "\"" + node + "\":" + result + "," : "";
					}
					if (retv.lastIndexOf(",") == retv.length - 1)
					{
						retv = retv.substr(0, retv.length - 1) + "}";
					}
					else
					{
						retv += "}";
					}
					break;
			}
			return retv;
		}
	}
}
