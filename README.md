# UFC Fight Forecast Predicting Winners Methods and Rounds
## Project Overview
The UFC Fight Predictor project aims to analyse UFC fight statistics and video footage to make better informed decisions for mathces and betting predictions. The predictions will include the fight winner, method of victory, round, and real-time analysis during fights. This project will be developed through several iterations, each adding more functionality and improving accuracy.

## Iterations
### Iteration 1: Web Scraping and Initial Prediction 
#### Objective: Scrape fighter statistics for upcoming bouts and use that data to predict the fight winner.
#### Tasks:
- Implement web scraping scripts to collect data on fighters involved in upcoming UFC fights.
- Clean and preprocess the scraped data.
- Use simple statistical methods to predict the winner.
- Set a baseline for model performance.

### Iteration 2: Method and Round Prediction
#### Objective: Enhance the prediction model to include the method of victory and the round.
#### Tasks:
- Expand the feature set to include factors influencing the method and round.
- Develop and train models to predict the method of victory (e.g., KO, submission) and the round.
- Evaluate the performance of these predictions and refine as needed.

### Iteration 3: Accumulator Style Prediction
#### Objective: Implement accumulator-style predictions for an entire fight card.
#### Tasks: 
- Develop a system to predict outcomes for all fights on a UFC card.
- Calculate and display accumulator predictions.
- Ensure the model can handle multiple predictions accurately and efficiently.

### Iteration 4: Computer Vision for Boxing Analysis
#### Objective: Implement computer vision to analyse fights and derive custom statistics, starting with boxing.
#### Tasks: 
- Train a computer vision model on fight footage of four fighters.
- Extract and analyze striking data from videos.
- Combine these custom statistics with previously scraped data for predictions.
- Integrate these enhanced predictions into the existing model.

### Iteration 5: Computer Vision for Clinch and Submissions
#### Objective: Extend computer vision capabilities to analyze clinch and submission techniques.
#### Tasks: 
- Train the computer vision model to recognize and analyze clinch and submission moves.
- Increase the number of fighters analyzed.
- Incorporate these new data points into the prediction model.

### Iteration 6: Comprehensive Computer Vision Analysis
#### Objective: Implement computer vision for transitions and combos, providing real-time predictions.
#### Tasks: 
- Train the model to analyze transitions from striking to groundwork and vice versa, and recognize combo patterns.
- Enable real-time analysis and predictions during fights.
- Integrate these dynamic predictions with static fight statistics.

### Iteration 7: Advanced Computer Vision and Live Data Visualization
#### Objective: Implement advanced computer vision to predict conditional combos and visualize data live.
#### Tasks: 
- Train the model to predict subsequent combos if a fighter is caught with a specific strike.
- Develop live data visualization tools to display predictions and analysis in real-time.
- Ensure the system can handle real-time data flow and visualization during live events.

