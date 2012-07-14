package net.sfmultimedia.argonaut.type
{
    import flash.display.BitmapData;
    import flash.utils.getDefinitionByName;

    import net.sfmultimedia.argonaut.ArgonautConfig;

    import org.flexunit.assertThat;
    import org.hamcrest.collection.hasItem;
    import org.hamcrest.core.isA;

    import org.hamcrest.object.sameInstance;

    public class VectorTypeTest
    {
        private var config:ArgonautConfig;
        private var typeFactory:DataTypeFactory;
        private var type:VectorType;

        [Before]
        public function before():void
        {
            config = new ArgonautConfig();
            typeFactory = new DataTypeFactory(config);

            type = new VectorType();
            var classType:DataType = typeFactory.getTypeFromDefinition("net.sfmultimedia.argonaut.type::MockStringWrapper");
            type.setElementType(classType);
        }

        [Test]
        public function roundtripPreservesElementClass():void
        {
            var stringWrapper:MockStringWrapper = new MockStringWrapper();
            stringWrapper.value = "hello";

            var vector:Vector.<MockStringWrapper> = new <MockStringWrapper>[stringWrapper];
            var encoded:String = type.encode(vector);
            var decoded:* = type.decode(JSON.parse(encoded));

            assertThat(decoded, hasItem(isA(MockStringWrapper)));
        }

        [Test]
        public function genericVectorActsAsAVector():void
        {
            var vectorClassOfBitmapData:Class = getDefinitionByName("__AS3__.vec::Vector.<flash.display::BitmapData>") as Class;
            var bitmapDataVector:* = new vectorClassOfBitmapData();
            var bitmap:BitmapData = new BitmapData(1,1,true,0);
            bitmapDataVector.push(bitmap);

            assertThat(bitmapDataVector[0], sameInstance(bitmap));
        }

        [Test]
        public function genericVectorCanBeAssignedToAVectorOfBitmaps():void
        {
            var vectorClassOfBitmapData:Class = getDefinitionByName("__AS3__.vec::Vector.<flash.display::BitmapData>") as Class;
            var bitmapDataVector:* = new vectorClassOfBitmapData();
            var object:VectorOfBitmapDataWrapper = new VectorOfBitmapDataWrapper();
            object.list = bitmapDataVector;

            assertThat(object.list, isA(Vector.<BitmapData>));
        }
    }
}

import flash.display.BitmapData;

class VectorOfBitmapDataWrapper
{
    public var list:Vector.<BitmapData>;
}