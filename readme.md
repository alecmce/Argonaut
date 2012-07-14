# Argonaut Readme

Argonaut provides AMF-style class serialization/deserialization between AS3 and JSON objects. It leverages
the built-in JSON class in Flex SDK 4.6.

This is an experimental version based on Marc's original. 

Use it for:

• mapping JSON objects into first-class AS3 Classes
• mirroring JSON objects server-client side the same way you would with AMF through AMFPHP or Red5
• Serializing AS instances to JSON (only public, non-static properties with be serialized)

## License

All code in this repository is licensed under the MIT License. For full details see the [official license](https://github.com/alecmce/Argonaut/blob/fleece/license.md).

## Example

In the following code, we imagine a case where a Test class has been constructed and populated with data. We stringify the class via Argonaut and then parse the stringified value. The result is a Test class.

	public class Test
	{
		public var hello:String;
		public var value:int;
	}

	var test:Test = new Test();
	test.hello = "world";
	test.value = 5;

	var argonaut:Argonaut = new Argonaut();
	var stringified:String = argonaut.stringify(test);
	var recreated:Test = argonaut.parse(stringified);

	assertThat(recreated.hello, equalTo("world"));			// true
	assertThat(recreated.value, equalTo(5));				// true

