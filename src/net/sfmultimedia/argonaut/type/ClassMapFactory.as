package net.sfmultimedia.argonaut.type
{
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;

    public class ClassMapFactory
    {
        private const DONT_SERIALIZE:String = "DontSerialize";

        public var typeFactory:DataTypeFactory;

        private var cached:Object;

        public function ClassMapFactory(typeFactory:DataTypeFactory)
        {
            this.typeFactory = typeFactory;
            cached = {};
        }

        public function makeClassMap(definition:String):ClassTypeMap
        {
            return cached[definition] || generateClassMap(definition);
        }

        private function generateClassMap(definition:String):ClassTypeMap
        {
            var map:ClassTypeMap = new ClassTypeMap();
            cached[definition] = map;
            populateClassMap(definition, map);
            return map;
        }

        private function populateClassMap(definition:String, map:ClassTypeMap):void
        {
            var klass:Class = getDefinitionByName(definition) as Class;
            var xmlDescriptionOfClass:XML = describeType(klass);
            addMappings(xmlDescriptionOfClass.factory.variable, map);
            addMappings(xmlDescriptionOfClass.factory.accessor, map);
            addMappings(xmlDescriptionOfClass.factory.constant, map);
        }

        private function addMappings(xmlList:XMLList, map:ClassTypeMap):void
        {
            for each (var node:XML in xmlList)
                addMapping(node, map);
        }

        private function addMapping(node:XML, map:ClassTypeMap):void
        {
            if (isSerializable(node) && isReadable(node))
            {
                var name:String = node.@name;
                var type:String = node.@type;
                var dataType:DataType = typeFactory.getTypeFromDefinition(type);
                map.setType(name, dataType);
            }
        }

        private function isSerializable(node:XML):Boolean
        {
            return node..metadata.(@name == DONT_SERIALIZE).length() == 0;
        }

        private function isReadable(node:XML):Boolean
        {
            return node.localName() != "accessor" || node.@access != "writeonly";
        }

    }
}
