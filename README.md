# NASA-Project
Swift-written iOS application that exposes the search functionality of the NASA Image and Video Library API.

## Libraries Used:
  In this application, I used the library **KingFisher** to handle asynchronous image downloading and caching. I used it to set the UIImageView per cell in the TableView, which simplified the code down to a single line.
  Assuming the search is done more than once, these images load near-instantly as they are cached and don't need to be downloaded again.

## Architecture:
This app follows an **MVC** architecture, where all UI is handled in the **SearchViewController** and data is fetched based on the codable data models and transformed in the **NASSAAPIHelper**  based on the data model **SearchResultModel** used to display the data. All models are declared in **DataModels.swift**

  - **SearchViewController**: Contains a textField used for searching and a tableView to present the data in custom **SearchResultCells** that display each results image, title, and description. Searches entered in the text field call the ViewController's instance of **NASAAPIHelper** to retrieve results.

  - **NASAAPIHelper**: This class is used for calling the image search endpoint, decoding the JSON response, and transforming the data into the expected model to be presented on the table view. Using the search term and other passed parameters, the endpoint URL is constructed and NASA image search endpoint is called yielding the data in JSON format. This data is then decoded based on the declared codable structs matching the response and then handled/transformed into an array of SearchResultModel (data model used to store the href, title, and description for each result). This array is then passed back to the SearchViewController through a completionHandler leading to the tableView reload that displays a SearchResultCell per SearchResultModel.

 - **SearchResultCell**: Custom table view cell made for displaying image, title, and description of each result. The SearchResultCell UI components are configured when the tableView cellForRowAt method sets the SearchResultCell's associated SearchResultModel object. The imageView is set using the KingFisher library .setImage method, taking in the href of the image.
 
 - **DataModels**: File that contains declarations of all structs used for fetching/decoding JSON from the API call as well as the data model, SearchResultModel, used to model data to be shown in the tableView.

## Building/running the app:
  - One can build and run this app using Xcode. To navigate and use the app, simply run the app, enter a search  term in the textField marked "Search here", hit the return key, and results will be displayed.


## Additional Comments:

  ### Pagination:
  Pagination is implemented in this app. While results are defaulted to 100 entries per page, a user is able to view more results by scrolling to the   bottom-most cell and dragging the content upwards. This will trigger an API call to fetch and load results of the following page.

  ### Potential Improvements:
  - Scroll to top upon new search
  - Loading indicator for pagination load
  - Scroll bar
  - Tappable cells to modally present more detailed view of image, title and description
