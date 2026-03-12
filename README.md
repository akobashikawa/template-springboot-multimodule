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
./scripts/new-module.sh nombre-del-modulo
```

- El script se encargará de:
1. Clonar template-simple.
2. Renombrar el artifactId y el name en el `pom.xml`.
3. Configurar el `spring.application.name` en el archivo de propiedades.
4. (Opcional) Registrar el módulo en el POM agregador raíz.

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
mvn spring-boot:run -Dspring-boot.run.profiles=local -pl nombre-del-modulo
mvn -Dmaven.test.skip=true spring-boot:run -Dspring-boot.run.profiles=local -pl nombre-del-modulo
```

## 🛠️ Build
```sh
 mvn install -pl template-simple
 mvn clean install -pl template-simple
 mvn clean package -pl template-simple
 mvn -DskipTests clean package -pl template-simple
 mvn -Dmaven.test.skip=true clean package -pl template-simple
```

## 🐳 Notas de Despliegue
- Al generar el JAR, puedes sobrescribir la versión en tiempo de ejecución sin recompilar usando variables de entorno:
```sh
export APP_VERSION=260312-custom && java -jar app.jar
```
