# Directorio deployments/

Deposita aquí el artefacto de la aplicación compilado (`scsp.war`).

Durante la construcción Source-to-Image (S2I) con JBoss Web Server (JWS 5.4), el ensamblador copiará automáticamente todos los archivos `.war` presentes en esta carpeta a la ruta `/opt/jws-5.4/tomcat/webapps/` del contenedor resultante.
