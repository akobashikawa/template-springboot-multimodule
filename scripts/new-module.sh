#!/bin/bash

# Uso: ./new-module.sh <nombre-nuevo-módulo> [nombre-template]
NEW_NAME=$1
TEMPLATE_BASE=${2:-template-simple} # Si $2 está vacío, usa template-simple

# Validaciones básicas
if [ -z "$NEW_NAME" ]; then
    echo "Error: Debes proporcionar un nombre para el nuevo módulo."
    echo "Uso: ./new-module.sh mi-servicio [mi-template-base]"
    exit 1
fi

if [ ! -d "$TEMPLATE_BASE" ]; then
    echo "Error: El template base '$TEMPLATE_BASE' no existe."
    exit 1
fi

echo "🚀 Creando nuevo módulo: $NEW_NAME (Basado en: $TEMPLATE_BASE)..."

# 1. Copiar la carpeta del template elegido
cp -r "$TEMPLATE_BASE" "$NEW_NAME"

# 2. Renombrar el artifactId en el pom.xml
# Usamos una variable para el nombre del template origen en el sed
# Nota: Asumimos que el artifactId del template coincide con el nombre de su carpeta
sed -i "s/<artifactId>$TEMPLATE_BASE<\/artifactId>/<artifactId>$NEW_NAME<\/artifactId>/g" "$NEW_NAME/pom.xml"
sed -i "s/<name>$TEMPLATE_BASE<\/name>/<name>$NEW_NAME<\/name>/g" "$NEW_NAME/pom.xml"

# 3. Actualizar el application.yml (Ruta estándar)
if [ -f "$NEW_NAME/src/main/resources/application.yml" ]; then
    sed -i "s/name: .*/name: $NEW_NAME/g" "$NEW_NAME/src/main/resources/application.yml"
fi

# 4. Actualizar el index.html si existe
if [ -f "$NEW_NAME/src/main/resources/static/index.html" ]; then
    sed -i "s/name: .*/name: $NEW_NAME/g" "$NEW_NAME/src/main/resources/static/index.html"
fi

# 5. Agregar el nuevo módulo al POM agregador raíz
if [ -f "pom.xml" ]; then
    # Evita duplicados si ejecutas el script dos veces con el mismo nombre
    if ! grep -q "<module>$NEW_NAME</module>" pom.xml; then
        sed -i "/<modules>/a \ \ \ \ \ \ \ \ <module>$NEW_NAME</module>" pom.xml
    fi
fi

# 6. Limpiar restos de compilación del nuevo módulo
rm -rf "$NEW_NAME/target" "$NEW_NAME/build"

echo "✅ Módulo '$NEW_NAME' listo."
echo "💡 Template utilizado: $TEMPLATE_BASE"