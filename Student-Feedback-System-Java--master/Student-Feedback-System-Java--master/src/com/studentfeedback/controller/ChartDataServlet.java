package com.studentfeedback.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.studentfeedback.dao.QuestionDAO;
import com.studentfeedback.dao.ResponseDAO;
import com.studentfeedback.dto.ChartDataDTO;
import com.studentfeedback.model.Question;

/**
 * API Servlet to provide aggregated JSON data for frontend Chart.js components.
 * GET /admin/api/chart-data?formId=X
 */
public class ChartDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ResponseDAO responseDAO = new ResponseDAO();
    private QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formIdStr = request.getParameter("formId");
        if (formIdStr == null || formIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int formId = Integer.parseInt(formIdStr);

        // Fetch Data
        Map<String, Double> avgRatings = responseDAO.getAverageRatings(formId);
        
        List<Question> questions = questionDAO.findByFormId(formId);
        Map<String, Integer> categoryDistribution = new LinkedHashMap<String, Integer>();
        for (Question q : questions) {
            String qType = q.getQuestionType();
            categoryDistribution.put(qType, categoryDistribution.getOrDefault(qType, 0) + 1);
        }

        // Build DTO
        ChartDataDTO chartData = new ChartDataDTO();
        chartData.setAverageRatings(avgRatings);
        chartData.setCategoryDistribution(categoryDistribution);

        // Return JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(chartData.toJson());
        out.flush();
    }
}
