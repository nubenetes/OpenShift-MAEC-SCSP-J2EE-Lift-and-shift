# Directorio lib/

Deposita aquí los conectores y librerías de terceros con licencia cerrada, especialmente el controlador JDBC de Microsoft SQL Server compatible con Java 8:
- `mssql-jdbc-8.4.1.jre8.jar`

El ensamblador S2I trasladará automáticamente los archivos `.jar` a `/opt/jws-5.4/tomcat/lib/`, integrándolos en el ClassLoader del servidor Tomcat.
