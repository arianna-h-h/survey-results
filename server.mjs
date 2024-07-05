import express from "express";

const app = express();
const port = 3000;

const mockSurveyData = { "data":
    [
        {
            "employee_id": "1", 
            "overall_satisfaction": "2",
            "company_mission": "3", 
            "team_name": "platform",
            "recomend_to_friend": "yes",
            "comments_for_leadership": "Less meetings"
        },
        {
            "employee_id": "2", 
            "overall_satisfaction": "5",
            "company_mission": "7", 
            "team_name": "HR",
            "recomend_to_friend": "maybe",
            "comments_for_leadership": "Less meetings"
        },
        {   "employee_id": "3", 
            "overall_satisfaction": "2",
            "company_mission": "3", 
            "team_name": "PLATFORM",
            "recomend_to_friend": "no",
            "comments_for_leadership": "null"
        }
    ]
}

app.get('/survey-data', (req, res) => {
  res.json(mockSurveyData);
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});