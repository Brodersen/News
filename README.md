# News app based on NewsAPI
App Project developed for a Tech Interview challenge.

## Features

This simple news app uses [NewsAPI](https://newsapi.org) to fetch articles from various news sources.

The apps main screen is initially populated with articles from the **[Top Headlines](https://newsapi.org/docs/endpoints/top-headlines)**-endpoint and whenever the search query is reset (is empty).

Use the search field in the top bar to search for articles by typing a query. Searching for articles this way uses the **[Everything](https://newsapi.org/docs/endpoints/everything)**-endpoint.

The app features pagination and _infinite scroll_ to load five articles at a time. Scrolling down the list loads the next five articles.

***Note: The API Key used in this demo app is exposed and likely is out of free API requests. You can get one for free [here](https://newsapi.org/register).***

For questions, contact [brodersen@me.com](mailto:brodersen@me.com).
