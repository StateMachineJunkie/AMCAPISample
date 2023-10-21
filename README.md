# AMCAPISample
#### A sample app for use with AMCAPI.
This SwiftUI app fetches data from AMC for now-playing and coming-soon movies. It then displays the associated movie posters in their respective tab-views using `LazyVGrid`. By tapping on a movie poster, the user can playback the associated movie-trailer if one exists. I included a search (filtering) feature for the contents in either tab-view. This app also demonstrates local caching of the downloaded movie models and their associated thumbnail images.

The model cache is stored on the disk. The image cache is stored in RAM. Note that we do not use `CoreData` for the model cache. Instead I chose a simple implementation based on `Codable` and property lists. The cache file itself is stored in the `Caches` directory of the user file-system.

Performance is reasonable and, since this is a sample app, I did not bother to perform any analysis or optimization using `Instruments`.

Before you can run the app, you will have to acquire your own vendor key from AMC's developer website. See [this](https://github.com/StateMachineJunkie/AMCAPI#setting-your-authorization-key) link for details.

## License
AMCAPI is released under an MIT license. See [License.md](https://github.com/StateMachineJunkie/AMCAPISample/blob/main/License.md) for more information.
