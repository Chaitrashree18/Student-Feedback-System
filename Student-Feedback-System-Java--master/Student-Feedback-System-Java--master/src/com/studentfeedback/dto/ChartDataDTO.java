package com.studentfeedback.dto;

import java.util.Map;

/**
 * Data Transfer Object for carrying aggregated feedback data to the frontend for Chart.js.
 */
public class ChartDataDTO {

    private Map<String, Double> averageRatings;
    private Map<String, Integer> categoryDistribution;

    public ChartDataDTO() {}

    public Map<String, Double> getAverageRatings() {
        return averageRatings;
    }

    public void setAverageRatings(Map<String, Double> averageRatings) {
        this.averageRatings = averageRatings;
    }

    public Map<String, Integer> getCategoryDistribution() {
        return categoryDistribution;
    }

    public void setCategoryDistribution(Map<String, Integer> categoryDistribution) {
        this.categoryDistribution = categoryDistribution;
    }
    
    /**
     * Helper to manually serialize this object into a simple JSON string.
     */
    public String toJson() {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        
        // Serialize Average Ratings (Bar Chart)
        sb.append("\"averageRatings\": {");
        if (averageRatings != null && !averageRatings.isEmpty()) {
            boolean first = true;
            for (Map.Entry<String, Double> entry : averageRatings.entrySet()) {
                if (!first) sb.append(",");
                sb.append("\"").append(escapeJson(entry.getKey())).append("\":").append(entry.getValue());
                first = false;
            }
        }
        sb.append("},");
        
        // Serialize Category Distribution (Pie Chart)
        sb.append("\"categoryDistribution\": {");
        if (categoryDistribution != null && !categoryDistribution.isEmpty()) {
            boolean first = true;
            for (Map.Entry<String, Integer> entry : categoryDistribution.entrySet()) {
                if (!first) sb.append(",");
                sb.append("\"").append(escapeJson(entry.getKey())).append("\":").append(entry.getValue());
                first = false;
            }
        }
        sb.append("}");
        
        sb.append("}");
        return sb.toString();
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
