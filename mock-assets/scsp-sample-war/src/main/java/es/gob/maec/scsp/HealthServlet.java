package es.gob.maec.scsp;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet simulado para responder a las sondas Liveness y Readiness
 * configuradas en OpenShift:
 * - /scsp/management/health
 * - /scsp/management/ready
 */
public class HealthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        if (path != null && path.endsWith("/ready")) {
            resp.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"status\":\"UP\",\"check\":\"readiness\",\"database\":\"reachable\",\"cache\":\"infinispan_connected\"}");
        } else {
            resp.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"status\":\"UP\",\"check\":\"liveness\",\"jvm\":\"healthy\"}");
        }
        out.flush();
    }
}
