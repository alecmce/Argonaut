package net.sfmultimedia.argonaut.type
{
    import net.sfmultimedia.argonaut.*;
    import net.sfmultimedia.argonaut.type.ClassTypeMap;
    import net.sfmultimedia.argonaut.type.DataType;
    import net.sfmultimedia.argonaut.type.DataTypeFactory;
    import net.sfmultimedia.argonaut.type.NativeType;
    import net.sfmultimedia.argonaut.type.ObjectType;

    import org.flexunit.assertThat;
    import org.hamcrest.collection.hasItem;
    import org.hamcrest.object.sameInstance;

    public class ClassMapTest
    {
        private var config:ArgonautConfig;
        private var typeFactory:DataTypeFactory;
        private var map:ClassTypeMap;

        [Before]
        public function before():void
        {
            config = new ArgonautConfig();
            typeFactory = new DataTypeFactory(config);
            map = new ClassTypeMap();
        }

        [Test]
        public function canSetMapping():void
        {
            var type:DataType = new NativeType(String);
            map.setType("test", type);
            assertThat(map.getType("test"), sameInstance(type));
        }

        [Test]
        public function setMappingNameIsIncludedInPropertyList():void
        {
            var type:DataType = new ObjectType(typeFactory);
            map.setType("test", type);
            assertThat(map.getProperties(), hasItem("test"));
        }

    }
}
