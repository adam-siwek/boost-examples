global with sharing class BoostPlugin implements forvendi.BoostPlugins.BaseApexPlugin {
    global Object createInstance(String className) {
        if (String.isBlank(className)) {
            return null;
        }

        Type classType = Type.forName(className);
        return classType?.newInstance();
    }

    global Boolean hasCustomPermission(String permissionName) {
        return FeatureManagement.checkPermission(permissionName);
    }

    global forvendi.ApexTypeInfo[] searchForClassImplementation(
            String searchText,
            String interfaceName,
            Integer numberOfRecord) {
        forvendi.ApexTypeInfo[] classInfo = new forvendi.ApexTypeInfo[]{};
        for (ApexTypeImplementor apexType : [SELECT ClassName, ClassNamespacePrefix
                FROM ApexTypeImplementor
                WHERE ClassName LIKE :( '%' + searchText + '%') AND IsConcrete=TRUE AND InterfaceName =:interfaceName
                ORDER BY ClassName ASC
                LIMIT :numberOfRecord]) {
            forvendi.ApexTypeInfo typeInfo = new forvendi.ApexTypeInfo();
            typeInfo.className = apexType.ClassName;
            typeInfo.classNamespacePrefix = apexType.ClassNamespacePrefix;
            classInfo.add(typeInfo);
        }

        return classInfo;
    }
}