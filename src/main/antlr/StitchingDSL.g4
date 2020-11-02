grammar StitchingDSL;
import GraphqlSDL;

@lexer::members {
    public boolean isDigit(int c) {
        return c >= '0' && c <= '9';
    }
    public boolean isNameStart(int c) {
        return '_' == c ||
          (c >= 'A' && c <= 'Z') ||
          (c >= 'a' && c <= 'z');
    }
    public boolean isDot(int c) {
        return '.' == c;
    }
}

@header {
    package graphql.nadel.parser.antlr;
}

stitchingDSL:
   commonDefinition? serviceDefinition+ ;

commonDefinition: 'common' '{' (typeSystemDefinition|typeSystemExtension)* '}';

serviceDefinition:
   SERVICE name '{' (typeSystemDefinition|typeSystemExtension)* '}' ;

objectTypeDefinition : description? TYPE name implementsInterfaces? directives? typeTransformation?  fieldsDefinition? ;

interfaceTypeDefinition : description? INTERFACE name implementsInterfaces? directives? typeTransformation? fieldsDefinition?;

unionTypeDefinition : description? UNION name directives? typeTransformation? unionMembership?;

inputObjectTypeDefinition : description? INPUT name directives? typeTransformation? inputObjectValueDefinitions?;

enumTypeDefinition : description? ENUM name directives? typeTransformation? enumValueDefinitions?;

scalarTypeDefinition : description? SCALAR name directives? typeTransformation?;


fieldDefinition : description? name argumentsDefinition? ':' type directives? addFieldInfo? fieldTransformation?;
addFieldInfo: defaultBatchSize;
defaultBatchSize:'default batch size' intValue;
fieldTransformation : '=>' (fieldMappingDefinition | underlyingServiceHydration);

typeTransformation : '=>' typeMappingDefinition;

//
// renames
//
typeMappingDefinition : 'renamed from' name;

fieldMappingDefinition : 'renamed from' name ('.'name)?;

//
// hydration

underlyingServiceHydration: 'hydrated from' serviceName '.' (syntheticField '.')? topLevelField remoteCallDefinition? objectIdentifier? batchSize?;

objectIdentifier: 'object identified by' name;

batchSize: 'batch size ' intValue;

remoteArgumentSource :  sourceObjectReference | fieldArgumentReference | contextArgumentReference;

remoteCallDefinition : '(' remoteArgumentPair+ ')' ;

remoteArgumentPair : name ':' remoteArgumentSource ;

sourceObjectReference : '$source' '.' name ('.'name)*;

fieldArgumentReference : '$argument' '.' name ;

contextArgumentReference : '$context' '.' name ;

intValue: IntValue;

serviceName: NAME;

topLevelField: NAME;

syntheticField: NAME;

baseName: NAME | FRAGMENT | QUERY | MUTATION | SUBSCRIPTION | SCHEMA | SCALAR | TYPE | INTERFACE | IMPLEMENTS | ENUM | UNION | INPUT | EXTEND | DIRECTIVE | SERVICE;

SERVICE: 'service';
