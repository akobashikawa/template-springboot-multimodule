# Template Multimodule

- Este repositorio es un **Agregador de Módulos Independientes**.
  - Está diseñado para servir como base para nuevos microservicios, garantizando consistencia en el versionado, estructura y despliegue.
- Los módulos son proyectos spring boot completos o proyectos de frontend completos.
- La idea es facilitar la comunicación y también las operaciones de desarrollo y despliegue.

## ⭐ Filosofía del Proyecto
- **Desacoplamiento Total:** Los módulos no heredan de un proyecto padre común. Cada uno es autónomo (tiene su propio `parent` de Spring Boot).
- **Versionado CalVer:** Uso de fechas (`YYMMDD-SemVer`) para una trazabilidad clara en despliegues y contenedores.
- **Configuración Externa:** Prioridad de carga diseñada para facilitar el despliegue sin modificar el artefacto (JAR).

## 🚀 Crear Nuevo Módulo
Para replicar el template y crear un nuevo servicio, utiliza el script automatizado:

```bash
# Uso por defecto (basado en template-simple)
./scripts/new-module.sh nombre-del-modulo

# Uso especificando un template base diferente
./scripts/new-module.sh nombre-del-modulo nombre-del-template
```

- El script se encargará de:
1. El clonado del template elegido (por defecto template-simple).
2. El renombrado del artifactId y el name en el pom.xml.
3. La configuración del spring.application.name en los archivos de propiedades.
4. El registro automático del nuevo módulo en el pom.xml agregador de la raíz.

## 📈 Versiones
- El proyecto utiliza filtrado de recursos de Maven para sincronizar la versión del pom.xml con la aplicación:
  - En pom.xml: Define `<version>260312-0.1.0</version>`.
  - En la App: Se accede mediante `@project.version@` (Maven) o `${spring.application.version}` (Spring).
- Para actualizar la versión en todo el sistema antes de un despliegue:

```sh
mvn clean compile
```

## ⚙️ Configuración
- La aplicación busca configuraciones en este orden (el último sobrescribe):

1. default: `src/main/resources/application.yml`
2. perfil: `src/main/resources/application-local.yml`
3. externo: `/config/application.yml`

## 🖥️ Ejecución en Desarrollo
- Para levantar un módulo con el perfil local activo y ver el banner personalizado:

```sh
# Ejecución estándar
mvn spring-boot:run -Dspring-boot.run.profiles=local -pl nombre-del-modulo

# Ejecución rápida saltando tests
mvn -Dmaven.test.skip=true spring-boot:run -Dspring-boot.run.profiles=local -pl nombre-del-modulo
```

## 🛠️ Build
- Comandos útiles para empaquetar módulos individuales desde la raíz:
```sh
# Instalar en el repositorio local
mvn clean install -pl nombre-del-modulo

# Generar el JAR ejecutable saltando tests
mvn -DskipTests clean package -pl nombre-del-modulo
```

## 🐳 Notas de Despliegue
- Al generar el JAR, puedes sobrescribir la versión en tiempo de ejecución sin recompilar usando variables de entorno:
```sh
export APP_VERSION=260312-custom && java -jar target/nombre-del-modulo.jar
```
