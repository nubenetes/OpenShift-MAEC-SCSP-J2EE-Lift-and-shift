<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%
    Integer accessCount = (Integer) session.getAttribute("accessCount");
    if (accessCount == null) {
        accessCount = 0;
    }
    accessCount++;
    session.setAttribute("accessCount", accessCount);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MAEC - Cliente Ligero SCSP</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 40px; background: #f8fafc; }
        .card { background: white; padding: 24px; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); max-width: 650px; }
        h1 { color: #b91c1c; margin-top: 0; }
        .badge { background: #dbeafe; color: #1e40af; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
        .ok { color: #15803d; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🏛️ MAEC - Cliente Ligero SCSP (Mock)</h1>
        <p><strong>Plataforma:</strong> Red Hat OpenShift 4.x (NubeSARA Air-Gapped)</p>
        <p><strong>Servidor de Aplicaciones:</strong> Red Hat JBoss Web Server 5.4 / Tomcat 9 / Java 8</p>
        <p><strong>ID de Sesión (Infinispan Cache):</strong> <code><%= session.getId() %></code></p>
        <p><strong>Contador de Peticiones en Sesión:</strong> <span class="badge"><%= accessCount %></span></p>
        <p><strong>Hora Servidor:</strong> <%= new Date() %></p>
        <hr/>
        <p class="ok">✅ Estado: Operativo y replicado mediante HotRod en Red Hat Data Grid.</p>
    </div>
</body>
</html>
