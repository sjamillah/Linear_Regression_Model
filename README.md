# Feel Heal: Mental Health Prediction System

## Project Overview
Feel Heal is a machine learning-based system designed to predict anxiety and depression levels using various health and lifestyle metrics. The system analyzes sleep patterns, physical activity, and other health indicators to provide early risk assessments for mental health conditions.

## Mission Statement
To create an accessible and accurate prediction system that helps identify potential mental health risks through the analysis of daily health metrics and lifestyle patterns.

## Project Aims
1. Develop an accurate prediction model for anxiety and depression risk levels
2. Identify key health indicators that correlate with mental health conditions
3. Create a user-friendly interface for health metric input and risk assessment
4. Provide data-driven insights and personalized recommendations for mental health monitoring

### Demo Video
[![Feel Heal Demo](https://www.loom.com/share/0109f7f72b2a4f3d8dfca7f68443f8df?sid=1f9421e7-2506-44b3-81fb-15aee091db07)]

### Figma Design
[![Feel Heal Figma Design](https://www.figma.com/design/8KZoT9tvQNFQPdTGCoUyk2/Feel-%26-Heal?node-id=0-1)]

## Features

### Health Metrics Analysis
The system analyzes various health indicators including:
- Sleep quality and duration
- Physical activity levels
- Daily steps count
- Calories burned
- Heart rate
- Social interaction levels
- Medication usage

### Prediction Capabilities
- Anxiety level assessment (Low/Medium/High)
- Depression risk evaluation (Low/Medium/High)
- Confidence scoring for predictions
- Personalized risk factor analysis

### Recommendations
- Category-based recommendations:
  - Mental Well-being
  - Physical Health
  - Social Connection
  - Lifestyle Changes
- Links to credible mental health resources
- Professional guidance references

## Technical Implementation

### Backend Development
- **Framework**: FastAPI
- **ML Model**: Scikit-learn based prediction model
- **Data Processing**: Pandas, NumPy
- **API Features**:
  - Health metrics validation
  - Prediction generation
  - Error handling
  - Swagger documentation

### Frontend Application
- **Framework**: Flutter
- **Key Components**:
  - Daily Check-in Page
  - Loading Animation
  - Results Visualization
  - Recommendations Interface
- **Features**:
  - Intuitive metric input
  - Real-time validation
  - Interactive UI elements
  - Resource linking

## API Documentation

### Base URL
[![link](https://feel-heal-api.onrender.com)]

### Swagger UI
[![link](https://feel-heal-api.onrender.com/docs#/default/predict_mental_health_predict_post)]

### Prediction Endpoint
```http
POST /predict

Request Body:
{
    "Age": int,
    "Sleep_Quality": float,
    "Daily_Steps": int,
    "Calories_Burned": float,
    "Physical_Activity_Level": string,
    "Heart_Rate": int,
    "Social_Interaction": int,
    "Medication_Usage": string,
    "Sleep_Duration": float
}

Response:
{
    "anxiety_level": float,
    "depression_level": float,
    "prediction_details": {
        "anxiety_risk": string,
        "depression_risk": string,
        "confidence_score": float
    }
}
```

## Project Setup

### Prerequisites
- Python 3.9+
- Flutter SDK
- Required Python packages in requirements.txt

### Installation

1. Backend Setup
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run API
uvicorn main:app --host 0.0.0.0 --port 8000
```

2. Frontend Setup
```bash
# Get dependencies
flutter pub get

# Add url_launcher package
flutter pub add url_launcher

# Run the app
flutter run
```

### Additional Setup Requirements
- For iOS, add to ios/Runner/Info.plist:
```plist
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
</array>
```

## Results & Impact

### Model Performance
- Prediction accuracy for anxiety and depression risk levels
- Reliable confidence scoring
- Effective risk factor identification

### User Benefits
1. Early Risk Detection
   - Identification of potential mental health concerns
   - Proactive intervention opportunities

2. Personalized Recommendations
   - Category-specific guidance
   - Evidence-based resources
   - Professional support references

3. Accessible Mental Health Monitoring
   - User-friendly interface
   - Regular health metric tracking
   - Progress visualization

## Future Developments
1. Enhanced prediction accuracy through expanded data collection
2. Integration of additional health metrics and wearable device data
3. Real-time monitoring and alert system
4. Expanded resource database and recommendation engine
5. Integration with mental health professional networks

## Author
- **Developer**: Jamillah Ssozi
- **Institution**: African Leadership University
- **Project Type**: Mental Health Technology Initiative

## Disclaimer
This system is designed as a supportive tool and should not be used as a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of qualified health providers with questions regarding medical conditions.
