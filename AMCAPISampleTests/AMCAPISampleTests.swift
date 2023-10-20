//
//  AMCAPISampleTests.swift
//  AMCAPISampleTests
//
//  Created by Michael A. Crawford on 9/29/21.
//

import XCTest
import Combine
@testable import AMCAPI
@testable import AMCAPISample

struct TestAPI: AMCMovieAPI {
    private static let dateDecoder = AMCAPI.DateDecoder()

    /// AMC API dates are all supposed to be in ISO8601 format but some of them do not meet the input standards for
    /// Apple's built-in formatter.
    private static let dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom({ decoder -> Date in
        // Fetch the date string from the container.
        var dateString = try decoder.singleValueContainer().decode(String.self)
        // Test to see if dateString is in iso8601 format. If so, use the iso8601 formatter. If not, use a custom date formatter.
        return try dateDecoder.decode(dateString: dateString)
    })

    /// Returns the common JSON decoder configure for use with the *Movies* endpoint.
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }()

    let modelJSON = """
    {
        "pageSize": 10,
        "pageNumber": 1,
        "count": 30,
        "_links": {
            "self": {
                "href": "https://api.sandbox.amctheatres.com/v2/movies/views/now-playing?ids=55831,66593,66596,66056,50281,66458,66451,66365,66594,58175,66827,65421,66792,66408,66362,66487,65756,56472,66108,66107,61921,66559&exclude-attributes=VR&page-number=1&page-size=10",
                "templated": false
            },
            "next": {
                "href": "https://api.sandbox.amctheatres.com/v2/movies/views/now-playing?ids=55831,66593,66596,66056,50281,66458,66451,66365,66594,58175,66827,65421,66792,66408,66362,66487,65756,56472,66108,66107,61921,66559&exclude-attributes=VR&page-number=2&page-size=10",
                "templated": false
            }
        },
        "_embedded": {
            "movies": [{
                "id": 55831,
                "name": "Snake Eyes",
                "sortableName": "Snake Eyes",
                "starringActors": "",
                "directors": "ROBERT SCHWENTKE",
                "genre": "ACTION",
                "mpaaRating": "PG13",
                "wwmReleaseNumber": 264076,
                "runTime": 121,
                "score": 0.02484,
                "slug": "snake-eyes-55831",
                "releaseDateUtc": "2021-07-23T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-23T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/snake-eyes-55831",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/snake-eyes-55831/showtimes",
                "synopsisTagLine": "A legendary warrior. His epic origin story.",
                "distributorId": 2337,
                "distributorCode": "PAR",
                "availableForAList": true,
                "imdbId": "tt8404256",
                "preferredMediaType": "Theatrical",
                "attributes": [{
                    "code": "AMCPRIME",
                    "name": "PRIME at AMC",
                    "description": "Enhanced sensory technology and premium comfort blend promoting total emersion in a film."
                }, {
                    "code": "BIGD",
                    "name": "BigD",
                    "description": "BigD PLF"
                }, {
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DBOX",
                    "name": "D-Box",
                    "description": "Technology allowing theatre seats to move in sync with the action in a film."
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "DOLBYCINEMAATAMCPRIME",
                    "name": "Dolby Cinema at AMC",
                    "description": "Dolby Cinema at AMC"
                }, {
                    "code": "GDX",
                    "name": "GDX",
                    "description": "Premium large format theater experience, crystal clear picture, and Dolby Atmos sound."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "IMAX",
                    "name": "IMAX at AMC",
                    "description": "Film format/projection standards for recording/displaying images of greater size and resolution."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6259874471001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6259874471001.mp4",
                    "primaryTrailerExternalVideoId": "6259874471001",
                    "primaryTrailerVideoId": "12083",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1621023322/amc-cdn/production/2/movies/55800/55831/HeroDesktopDynamic/124212.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1621023322/amc-cdn/production/2/movies/55800/55831/HeroDesktopDynamic/124212.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1624285046/amc-cdn/production/2/movies/55800/55831/PosterDynamic/125156.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "",
                    "onDemandTrailerExternalVideoId": "",
                    "onDemandPosterDynamic": "",
                    "onDemandTrailerMp4Dynamic": "",
                    "onDemandTrailerHdDynamic": ""
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/55831",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/55831/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/55831/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/55831/cast-crew",
                        "templated": false
                    }
                }
            }, {
                "id": 66593,
                "name": "Old",
                "sortableName": "Old",
                "starringActors": "Gael Garcia Bernal, Rufus Sewell, VICKY KRIEPS",
                "directors": "M. Night Shyamalan",
                "genre": "SUSPENSE",
                "mpaaRating": "PG13",
                "wwmReleaseNumber": 312800,
                "runTime": 108,
                "score": 0.01850625,
                "slug": "old-66593",
                "synopsis": "Visionary filmmaker M. Night Shyamalan unveils a chilling, mysterious new thriller about a family on a tropical holiday who discover that the secluded beach where they are relaxing for a few hours is somehow causing them to age rapidly … reducing their entire lives into a single day.",
                "releaseDateUtc": "2021-07-23T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-23T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/old-66593",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/old-66593/showtimes",
                "synopsisTagLine": "It's only a matter of time.",
                "distributorId": 2284,
                "distributorCode": "UI",
                "availableForAList": true,
                "imdbId": "tt10954652",
                "preferredMediaType": "Theatrical",
                "attributes": [{
                    "code": "AMCPRIME",
                    "name": "PRIME at AMC",
                    "description": "Enhanced sensory technology and premium comfort blend promoting total emersion in a film."
                }, {
                    "code": "BIGD",
                    "name": "BigD",
                    "description": "BigD PLF"
                }, {
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "DOLBYCINEMAATAMCPRIME",
                    "name": "Dolby Cinema at AMC",
                    "description": "Dolby Cinema at AMC"
                }, {
                    "code": "GDX",
                    "name": "GDX",
                    "description": "Premium large format theater experience, crystal clear picture, and Dolby Atmos sound."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6256275815001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6256275815001.mp4",
                    "primaryTrailerExternalVideoId": "6256275815001",
                    "primaryTrailerVideoId": "12035",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1625137361/amc-cdn/production/2/movies/66600/66593/MovieStills/312800R8.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1625137361/amc-cdn/production/2/movies/66600/66593/MovieStills/312800R8.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1622133477/amc-cdn/production/2/movies/66600/66593/PosterDynamic/124542.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "",
                    "onDemandTrailerExternalVideoId": "",
                    "onDemandPosterDynamic": "",
                    "onDemandTrailerMp4Dynamic": "",
                    "onDemandTrailerHdDynamic": ""
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66593",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/66593/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/66593/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/66593/cast-crew",
                        "templated": false
                    }
                }
            }, {
                "id": 66596,
                "name": "Space Jam: A New Legacy",
                "sortableName": "Space Jam: A New Legacy",
                "starringActors": "Don Cheadle, LeBron James",
                "directors": "Malcolm D. Lee",
                "genre": "COMEDY",
                "mpaaRating": "PG",
                "wwmReleaseNumber": 288404,
                "runTime": 115,
                "score": 0.0216,
                "slug": "space-jam-a-new-legacy-66596",
                "synopsis": "Synopsis goes here!",
                "releaseDateUtc": "2021-07-16T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-16T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/space-jam-a-new-legacy-66596",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/space-jam-a-new-legacy-66596/showtimes",
                "synopsisTagLine": "They're all Tuned up for a rematch.",
                "distributorId": 2429,
                "distributorCode": "WB",
                "availableForAList": true,
                "imdbId": "tt3554046",
                "preferredMediaType": "Theatrical",
                "attributes": [{
                    "code": "AMCPRIME",
                    "name": "PRIME at AMC",
                    "description": "Enhanced sensory technology and premium comfort blend promoting total emersion in a film."
                }, {
                    "code": "BIGD",
                    "name": "BigD",
                    "description": "BigD PLF"
                }, {
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "DOLBYCINEMAATAMCPRIME",
                    "name": "Dolby Cinema at AMC",
                    "description": "Dolby Cinema at AMC"
                }, {
                    "code": "GDX",
                    "name": "GDX",
                    "description": "Premium large format theater experience, crystal clear picture, and Dolby Atmos sound."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }, {
                    "code": "SENSORYFRIENDLY",
                    "name": "Sensory Friendly Film",
                    "description": "Sensory Friendly Film."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6258089683001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6258089683001.mp4",
                    "primaryTrailerExternalVideoId": "6258089683001",
                    "primaryTrailerVideoId": "12065",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1624359761/amc-cdn/production/2/movies/66600/66596/MovieStills/288404R7.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1624359761/amc-cdn/production/2/movies/66600/66596/MovieStills/288404R7.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1623247396/amc-cdn/production/2/movies/66600/66596/PosterDynamic/124778.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "",
                    "onDemandTrailerExternalVideoId": "",
                    "onDemandPosterDynamic": "",
                    "onDemandTrailerMp4Dynamic": "",
                    "onDemandTrailerHdDynamic": ""
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66596",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/66596/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/66596/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/66596/cast-crew",
                        "templated": false
                    }
                }
            }, {
                "id": 66056,
                "name": "Black Widow",
                "sortableName": "Black Widow",
                "starringActors": "Scarlett Johansson",
                "directors": "CATE SHORTLAND",
                "genre": "ACTION",
                "mpaaRating": "PG13",
                "wwmReleaseNumber": 287637,
                "runTime": 133,
                "score": 0.099876,
                "slug": "black-widow-66056",
                "synopsis": "In Marvel Studios’ action-packed spy thriller “Black Widow,” Natasha Romanoff aka Black Widow confronts the darker parts of her ledger when a dangerous conspiracy with ties to her past arises. Pursued by a force that will stop at nothing to bring her down, Natasha must deal with her history as a spy and the broken relationships left in her wake long before she became an Avenger.",
                "releaseDateUtc": "2021-07-09T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-09T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/black-widow-66056",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/black-widow-66056/showtimes",
                "synopsisTagLine": "She's Done Running From Her Past.",
                "distributorId": 2369,
                "distributorCode": "BVD",
                "availableForAList": true,
                "imdbId": "tt3480822",
                "preferredMediaType": "Theatrical",
                "attributes": [{
                    "code": "AMCPRIME",
                    "name": "PRIME at AMC",
                    "description": "Enhanced sensory technology and premium comfort blend promoting total emersion in a film."
                }, {
                    "code": "BIGD",
                    "name": "BigD",
                    "description": "BigD PLF"
                }, {
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DBOX",
                    "name": "D-Box",
                    "description": "Technology allowing theatre seats to move in sync with the action in a film."
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "DOLBY3D",
                    "name": "Dolby Cinema 3D"
                }, {
                    "code": "DOLBYCINEMAATAMCPRIME",
                    "name": "Dolby Cinema at AMC",
                    "description": "Dolby Cinema at AMC"
                }, {
                    "code": "GDX",
                    "name": "GDX",
                    "description": "Premium large format theater experience, crystal clear picture, and Dolby Atmos sound."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "IMAX",
                    "name": "IMAX at AMC",
                    "description": "Film format/projection standards for recording/displaying images of greater size and resolution."
                }, {
                    "code": "IMAX3D",
                    "name": "IMAX3D"
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }, {
                    "code": "PRIME3D",
                    "name": "PRIME 3D"
                }, {
                    "code": "REALD3D",
                    "name": "RealD 3D",
                    "description": "3 Dimensional."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6246715986001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6246715986001.mp4",
                    "primaryTrailerExternalVideoId": "6246715986001",
                    "primaryTrailerVideoId": "11902",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1626174188/amc-cdn/production/2/movies/66100/66056/MovieStills/317709R9.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1626174188/amc-cdn/production/2/movies/66100/66056/MovieStills/317709R9.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1625062614/amc-cdn/production/2/movies/66100/66056/PosterDynamic/125371.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "",
                    "onDemandTrailerExternalVideoId": "",
                    "onDemandPosterDynamic": "",
                    "onDemandTrailerMp4Dynamic": "",
                    "onDemandTrailerHdDynamic": ""
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66056",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/66056/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/66056/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/66056/cast-crew",
                        "templated": false
                    }
                }
            }, {
                "id": 50281,
                "name": "F9 The Fast Saga",
                "sortableName": "F9 The Fast Saga",
                "starringActors": "JOHN CENA, Vin Diesel",
                "directors": "Justin Lin",
                "genre": "ACTION",
                "mpaaRating": "PG13",
                "wwmReleaseNumber": 226644,
                "runTime": 145,
                "score": 0.08379,
                "slug": "ninth-chapter-in-fast-furious-saga-50281",
                "synopsis": "F9 is the ninth chapter in the saga that has endured for almost two decades and has earned more than $5 billion around the world. Vin Diesel's Dom Toretto is leading a quiet life off the grid with Letty and his son, little Brian, but they know that danger always lurks just over their peaceful horizon. This time, that threat will force Dom to confront the sins of his past if he's going to save those he loves most. His crew joins together to stop a world-shattering plot led by the most skilled assassin and high-performance driver they've ever encountered: a man who also happens to be Dom's forsaken brother, Jakob (John Cena, next year's The Suicide Squad). F9 sees the return of Justin Lin as director, who helmed the third, fourth, fifth and sixth chapters of the series when it transformed into a global blockbuster.",
                "releaseDateUtc": "2021-06-25T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-06-25T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/ninth-chapter-in-fast-furious-saga-50281",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/ninth-chapter-in-fast-furious-saga-50281/showtimes",
                "synopsisTagLine": "Fast Family Forever",
                "distributorId": 2284,
                "distributorCode": "UI",
                "availableForAList": true,
                "imdbId": "tt5433138",
                "preferredMediaType": "OnDemand",
                "attributes": [{
                    "code": "AMCPRIME",
                    "name": "PRIME at AMC",
                    "description": "Enhanced sensory technology and premium comfort blend promoting total emersion in a film."
                }, {
                    "code": "BIGD",
                    "name": "BigD",
                    "description": "BigD PLF"
                }, {
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DBOX",
                    "name": "D-Box",
                    "description": "Technology allowing theatre seats to move in sync with the action in a film."
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "DOLBYCINEMAATAMCPRIME",
                    "name": "Dolby Cinema at AMC",
                    "description": "Dolby Cinema at AMC"
                }, {
                    "code": "GDX",
                    "name": "GDX",
                    "description": "Premium large format theater experience, crystal clear picture, and Dolby Atmos sound."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "IMAX",
                    "name": "IMAX at AMC",
                    "description": "Film format/projection standards for recording/displaying images of greater size and resolution."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6257101417001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6257101417001.mp4",
                    "primaryTrailerExternalVideoId": "6257101417001",
                    "primaryTrailerVideoId": "12051",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1626976507/amc-cdn/production/2/movies/50300/50281/MovieStillDynamic/126928.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1626976507/amc-cdn/production/2/movies/50300/50281/MovieStillDynamic/126928.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1618414618/amc-cdn/production/2/movies/50300/50281/PosterDynamic/123362.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "12151",
                    "onDemandTrailerExternalVideoId": "6264078429001",
                    "onDemandPosterDynamic": "https://amc-theatres-res.cloudinary.com/v1626523351/amc-cdn/production/2/movies/50300/50281/Poster/p_800x1200_F9TheFastSaga_En_071421.jpg",
                    "onDemandTrailerMp4Dynamic": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6264078429001.mp4",
                    "onDemandTrailerHdDynamic": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6264078429001.mp4"
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/50281",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/50281/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/50281/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/50281/cast-crew",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v1/on-demand-products": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movies/50281/on-demand-products",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/movie/on-demand/similar": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/50281/on-demand/similar",
                        "templated": false
                    }
                }
            }, {
                "id": 66458,
                "name": "Escape Room: Tournament of Champions",
                "sortableName": "Escape Room: Tournament of Champions",
                "starringActors": "INDYA MOORE, Logan Miller, TAYLOR RUSSELL",
                "directors": "Adam Robitel",
                "genre": "HORROR",
                "mpaaRating": "PG13",
                "wwmReleaseNumber": 288543,
                "runTime": 88,
                "score": 0.0104,
                "slug": "escape-room-tournament-of-champions-66458",
                "synopsis": "Escape Room: Tournament of Champions is the sequel to the box office hit psychological thriller that terrified audiences around the world. In this installment, six people unwittingly find themselves locked in another series of escape rooms, slowly uncovering what they have in common to survive…and discovering they’ve all played the game before.",
                "releaseDateUtc": "2021-07-16T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-16T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/escape-room-tournament-of-champions-66458",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/escape-room-tournament-of-champions-66458/showtimes",
                "distributorId": 2420,
                "distributorCode": "SON",
                "availableForAList": true,
                "imdbId": "tt9844522",
                "preferredMediaType": "Theatrical",
                "attributes": [{
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6260719935001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6260719935001.mp4",
                    "primaryTrailerExternalVideoId": "6260719935001",
                    "primaryTrailerVideoId": "12096",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1624705311/amc-cdn/production/2/movies/66500/66458/MovieStills/288543R5.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1624705311/amc-cdn/production/2/movies/66500/66458/MovieStills/288543R5.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1623694024/amc-cdn/production/2/movies/66500/66458/PosterDynamic/124946.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "",
                    "onDemandTrailerExternalVideoId": "",
                    "onDemandPosterDynamic": "",
                    "onDemandTrailerMp4Dynamic": "",
                    "onDemandTrailerHdDynamic": ""
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66458",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/66458/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/66458/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/66458/cast-crew",
                        "templated": false
                    }
                }
            }, {
                "id": 66451,
                "name": "Roadrunner: A Film About Anthony Bourdain",
                "sortableName": "Roadrunner: A Film About Anthony Bourdain",
                "starringActors": "ANTHONY BOURDAIN",
                "directors": "Morgan Neville",
                "genre": "DOCUMENTARY",
                "mpaaRating": "R",
                "wwmReleaseNumber": 318210,
                "runTime": 119,
                "score": 0.00189,
                "slug": "roadrunner-a-film-about-anthony-bourdain-66451",
                "synopsis": "It’s not where you go.  It’s what you leave behind . . . Chef, writer, adventurer, provocateur: Anthony Bourdain lived his life unabashedly. Roadrunner: A Film About Anthony Bourdain is an intimate, behind-the-scenes look at how an anonymous chef became a world-renowned cultural icon. From Academy Award®-winning filmmaker Morgan Neville (20 Feet From Stardom, Won’t You Be My Neighbor?), this unflinching look at Bourdain reverberates with his presence, in his own voice and in the way he indelibly impacted the world around him.",
                "releaseDateUtc": "2021-07-16T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-16T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/roadrunner-a-film-about-anthony-bourdain-66451",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/roadrunner-a-film-about-anthony-bourdain-66451/showtimes",
                "synopsisTagLine": "The Journey Changes You",
                "distributorId": 2180,
                "distributorCode": "FCS",
                "availableForAList": true,
                "imdbId": "tt14512538",
                "preferredMediaType": "Theatrical",
                "attributes": [{
                    "code": "AMCARTISANFILMS",
                    "name": "AMC Artisan Films",
                    "description": "AMC Artisan Films"
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6257520993001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6257520993001.mp4",
                    "primaryTrailerExternalVideoId": "6257520993001",
                    "primaryTrailerVideoId": "12061",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1622890969/amc-cdn/production/2/movies/66500/66451/MovieStills/318210RA.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1622890969/amc-cdn/production/2/movies/66500/66451/MovieStills/318210RA.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1624034594/amc-cdn/production/2/movies/66500/66451/PosterDynamic/125116.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "",
                    "onDemandTrailerExternalVideoId": "",
                    "onDemandPosterDynamic": "",
                    "onDemandTrailerMp4Dynamic": "",
                    "onDemandTrailerHdDynamic": ""
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66451",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/66451/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/66451/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/66451/cast-crew",
                        "templated": false
                    }
                }
            }, {
                "id": 66365,
                "name": "The Boss Baby: Family Business",
                "sortableName": "Boss Baby: Family Business, The",
                "starringActors": "Alec Baldwin, Eva Longoria, James Marsden",
                "directors": "Tom McGrath",
                "genre": "ANIMATION",
                "mpaaRating": "PG",
                "wwmReleaseNumber": 251727,
                "runTime": 107,
                "score": 0.0188266875,
                "slug": "the-boss-baby-family-business-66365",
                "synopsis": "Synopsis goes here!",
                "releaseDateUtc": "2021-07-02T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-02T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/the-boss-baby-family-business-66365",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/the-boss-baby-family-business-66365/showtimes",
                "synopsisTagLine": "Playtime is over.",
                "distributorId": 2284,
                "distributorCode": "UI",
                "availableForAList": true,
                "imdbId": "tt6932874",
                "preferredMediaType": "Theatrical",
                "attributes": [{
                    "code": "AMCPRIME",
                    "name": "PRIME at AMC",
                    "description": "Enhanced sensory technology and premium comfort blend promoting total emersion in a film."
                }, {
                    "code": "BIGD",
                    "name": "BigD",
                    "description": "BigD PLF"
                }, {
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "DOLBY3D",
                    "name": "Dolby Cinema 3D"
                }, {
                    "code": "DOLBYCINEMAATAMCPRIME",
                    "name": "Dolby Cinema at AMC",
                    "description": "Dolby Cinema at AMC"
                }, {
                    "code": "GDX",
                    "name": "GDX",
                    "description": "Premium large format theater experience, crystal clear picture, and Dolby Atmos sound."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }, {
                    "code": "PRIME3D",
                    "name": "PRIME 3D"
                }, {
                    "code": "REALD3D",
                    "name": "RealD 3D",
                    "description": "3 Dimensional."
                }, {
                    "code": "SENSORYFRIENDLY",
                    "name": "Sensory Friendly Film",
                    "description": "Sensory Friendly Film."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6257378919001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6257378919001.mp4",
                    "primaryTrailerExternalVideoId": "6257378919001",
                    "primaryTrailerVideoId": "12060",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1624705298/amc-cdn/production/2/movies/66400/66365/MovieStills/319576R7.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1624705298/amc-cdn/production/2/movies/66400/66365/MovieStills/319576R7.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1622146633/amc-cdn/production/2/movies/66400/66365/PosterDynamic/124543.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "",
                    "onDemandTrailerExternalVideoId": "",
                    "onDemandPosterDynamic": "",
                    "onDemandTrailerMp4Dynamic": "",
                    "onDemandTrailerHdDynamic": ""
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66365",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/66365/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/66365/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/66365/cast-crew",
                        "templated": false
                    }
                }
            }, {
                "id": 66594,
                "name": "The Forever Purge",
                "sortableName": "Forever Purge, The",
                "starringActors": "Ana de la Reguera, TENOCH HUERTA, Will Patton",
                "directors": "EVERARDO VALERIO GOUT",
                "genre": "HORROR",
                "mpaaRating": "R",
                "wwmReleaseNumber": 309994,
                "runTime": 103,
                "score": 0.022725,
                "slug": "the-forever-purge-66594",
                "synopsis": "Following the record-breaking success of 2018's The First Purge, which became the highest-grossing film in the notorious horror series, Blumhouse Productions and Platinum Dunes returns with a terrifying new chapter, written by franchise creator and narrative mastermind James DeMonaco (writer/director of The Purge, The Purge: Anarchy and The Purge: Election Year). The Forever Purge is directed by Everardo Gout, writer-director of the award-winning thriller Days of Grace. The film is produced by the series' founding producers: Jason Blum for his Blumhouse Productions; Platinum Dunes partners Michael Bay, Andrew Form and Brad Fuller; and Man in a Tree duo James DeMonaco and his longtime producing partner Sebastien K. Lemercier. The film's executive producers are Marcei A. Brown, Couper Samuelson and Jeanette Volturno.",
                "releaseDateUtc": "2021-07-02T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-07-02T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/the-forever-purge-66594",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/the-forever-purge-66594/showtimes",
                "synopsisTagLine": "The rules are broken.",
                "distributorId": 2284,
                "distributorCode": "UI",
                "availableForAList": true,
                "imdbId": "tt10327252",
                "preferredMediaType": "OnDemand",
                "attributes": [{
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6255976656001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6255976656001.mp4",
                    "primaryTrailerExternalVideoId": "6255976656001",
                    "primaryTrailerVideoId": "12027",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1626392056/amc-cdn/production/2/movies/66600/66594/MovieStillDynamic/125771.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1626392056/amc-cdn/production/2/movies/66600/66594/MovieStillDynamic/125771.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1621973819/amc-cdn/production/2/movies/66600/66594/PosterDynamic/124471.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "12133",
                    "onDemandTrailerExternalVideoId": "6263516949001",
                    "onDemandPosterDynamic": "https://amc-theatres-res.cloudinary.com/v1626178098/amc-cdn/production/2/movies/66600/66594/Poster/p_800x1200_AMC_ForeverPurgeThe_071221.jpg",
                    "onDemandTrailerMp4Dynamic": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6263516949001.mp4",
                    "onDemandTrailerHdDynamic": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6263516949001.mp4"
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66594",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/66594/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/66594/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/66594/cast-crew",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v1/on-demand-products": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movies/66594/on-demand-products",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/movie/on-demand/similar": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/66594/on-demand/similar",
                        "templated": false
                    }
                }
            }, {
                "id": 58175,
                "name": "A Quiet Place Part II",
                "sortableName": "Quiet Place Part II, A",
                "starringActors": "Emily Blunt",
                "directors": "John Krasinski",
                "genre": "SUSPENSE",
                "mpaaRating": "PG13",
                "wwmReleaseNumber": 295508,
                "runTime": 97,
                "score": 0.064625,
                "slug": "a-quiet-place-part-ii-58175",
                "synopsis": "Following the deadly events at home, the Abbott family (Emily Blunt, Millicent Simmonds, Noah Jupe) must now face the terrors of the outside world as they continue their fight for survival in silence. Forced to venture into the unknown, they quickly realize that the creatures that hunt by sound are not the only threats that lurk beyond the sand path in this terrifyingly suspenseful thriller written and directed by John Krasinski.",
                "releaseDateUtc": "2021-05-28T05:00:00Z",
                "earliestShowingUtc": "1900-01-01T00:00:00",
                "hasScheduledShowtimes": false,
                "onlineTicketAvailabilityDateUtc": "2021-05-28T05:00:00Z",
                "websiteUrl": "https://sandbox.amctheatres.com/movies/a-quiet-place-part-ii-58175",
                "showtimesUrl": "https://sandbox.amctheatres.com/movies/a-quiet-place-part-ii-58175/showtimes",
                "synopsisTagLine": "Silence is Not Enough",
                "distributorId": 2337,
                "distributorCode": "PAR",
                "availableForAList": true,
                "imdbId": "tt8332922",
                "preferredMediaType": "OnDemand",
                "attributes": [{
                    "code": "AMCPRIME",
                    "name": "PRIME at AMC",
                    "description": "Enhanced sensory technology and premium comfort blend promoting total emersion in a film."
                }, {
                    "code": "BIGD",
                    "name": "BigD",
                    "description": "BigD PLF"
                }, {
                    "code": "CLOSEDCAPTION",
                    "name": "Closed Caption",
                    "description": "Closed Caption"
                }, {
                    "code": "DBOX",
                    "name": "D-Box",
                    "description": "Technology allowing theatre seats to move in sync with the action in a film."
                }, {
                    "code": "DESCRIPTIVEVIDEO",
                    "name": "Audio Description",
                    "description": "Audio Description."
                }, {
                    "code": "DOLBYCINEMAATAMCPRIME",
                    "name": "Dolby Cinema at AMC",
                    "description": "Dolby Cinema at AMC"
                }, {
                    "code": "GDX",
                    "name": "GDX",
                    "description": "Premium large format theater experience, crystal clear picture, and Dolby Atmos sound."
                }, {
                    "code": "GXL",
                    "name": "GXL",
                    "description": "Immense screens, 4K super HD projection, extra-wide rows, and superior sound."
                }, {
                    "code": "IMAX",
                    "name": "IMAX at AMC",
                    "description": "Film format/projection standards for recording/displaying images of greater size and resolution."
                }, {
                    "code": "OPENCAPTION",
                    "name": "Open Caption (On-screen Subtitles)",
                    "description": "A film printed with subtitles."
                }],
                "media": {
                    "posterThumbnail": "",
                    "posterStandard": "",
                    "posterLarge": "",
                    "trailerFlv": "",
                    "trailerHd": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6252924172001.mp4",
                    "trailerMp4": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6252924172001.mp4",
                    "primaryTrailerExternalVideoId": "6252924172001",
                    "primaryTrailerVideoId": "11979",
                    "heroDesktopDynamic": "https://amc-theatres-res.cloudinary.com/v1625164412/amc-cdn/production/2/movies/58200/58175/MovieStillDynamic/125455.jpg",
                    "heroMobileDynamic": "https://amc-theatres-res.cloudinary.com/v1625164412/amc-cdn/production/2/movies/58200/58175/MovieStillDynamic/125455.jpg",
                    "posterDynamic": "https://amc-theatres-res.cloudinary.com/v1620406013/amc-cdn/production/2/movies/58200/58175/PosterDynamic/124043.jpg",
                    "posterAlternateDynamic": "",
                    "poster3DDynamic": "",
                    "posterIMAXDynamic": "",
                    "trailerTeaserDynamic": "",
                    "trailerAlternateDynamic": "",
                    "onDemandTrailerVideoId": "9508",
                    "onDemandTrailerExternalVideoId": "6140799018001",
                    "onDemandPosterDynamic": "https://amc-theatres-res.cloudinary.com/v1624626694/amc-cdn/production/2/movies/58200/58175/Poster/p_800x1200_AMC_AQuietPlacePartII_06242021.jpg",
                    "onDemandTrailerMp4Dynamic": "https://graph.amctheatres.com/assets/video/mobile/1655482053001/6140799018001.mp4",
                    "onDemandTrailerHdDynamic": "https://graph.amctheatres.com/assets/video/hd/1655482053001/6140799018001.mp4"
                },
                "_links": {
                    "self": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/58175",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/media": {
                        "href": "https://api.sandbox.amctheatres.com/v2/media/movies/58175/{media-type}",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v2/earliest-showtime": {
                        "href": "https://api.sandbox.amctheatres.com/v2/theatres/{theatre-id}/movies/58175/earliest-showtime",
                        "templated": true
                    },
                    "https://api.amctheatres.com/rels/v1/cast-crew": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movie/58175/cast-crew",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v1/on-demand-products": {
                        "href": "https://api.sandbox.amctheatres.com/v1/movies/58175/on-demand-products",
                        "templated": false
                    },
                    "https://api.amctheatres.com/rels/v2/movie/on-demand/similar": {
                        "href": "https://api.sandbox.amctheatres.com/v2/movies/58175/on-demand/similar",
                        "templated": false
                    }
                }
            }]
        }
    }
    """.data(using: .utf8)!

    func decodeModel() -> AnyPublisher<AMCAPI.MoviesModel, Swift.Error> {
        do {
            let model = try decoder.decode(AMCAPI.MoviesModel.self, from: modelJSON)
            return Result.Publisher(model).eraseToAnyPublisher()
        } catch {
            let localError = error
            print("Failed to decode modelJSON with error: \(localError.localizedDescription)")
            return Fail<AMCAPI.MoviesModel, Swift.Error>(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }

    func fetchAllMovies(pageNumber: Int = 1, pageSize: Int = 10) -> AnyPublisher<AMCAPI.MoviesModel, Error> {
        return decodeModel()
    }

    func fetchComingSoonMovies(pageNumber: Int = 1, pageSize: Int = 10) -> AnyPublisher<AMCAPI.MoviesModel, Error> {
        return decodeModel()
    }

    func fetchNowPlayingMovies(pageNumber: Int = 1, pageSize: Int = 10) -> AnyPublisher<AMCAPI.MoviesModel, Error> {
        return decodeModel()
    }
}

class AMCAPISampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCachedMovies() {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Active Movies")
        let testAPI = TestAPI()
        testAPI.fetchAllMovies().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Failed to fetch all movies with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        } receiveValue: { model in
            let cachedMovies = ModelCache<[AMCAPI.MovieModel]>(model: model.embedded.movies, timestamp: Date())
            // let cachedMovies = CachedMovies(movies: model.embedded.movies, timestamp: Date())
            let path = NSTemporaryDirectory() + "/CachedMovies.plist"
            do {
                try cachedMovies.store(at: path)
            } catch {
                XCTFail("Failed to write cached movies to \(path) with error: \(error.localizedDescription)")
            }
            do {
                let readbackCachedMovies = try ModelCache<[AMCAPI.MovieModel]>.fetch(from: path)
                XCTAssertEqual(cachedMovies, readbackCachedMovies)
            } catch {
                XCTFail("Failed to read back cached movies from \(path) with error: \(error.localizedDescription)")
            }
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 60.0)
    }

    @MainActor
    func testMovieList() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Active Movies")
        let testAPI = TestAPI()
        let movieList = MovieList(pageSize: 10, filter: .nowPlaying, movieAPI: testAPI)
        movieList.$items.sink { model in
            XCTAssertEqual(model.count, 10)
            expectation.fulfill()
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 600.0)
    }

    @MainActor
    func testMovieListWithLiveAPI() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Active Movies")
        let testAPI = AMCAPI.shared
        let movieList = MovieList(pageSize: 10, filter: .nowPlaying, movieAPI: testAPI)
        movieList.$items.sink { model in
            XCTAssertEqual(model.count, 10)
            expectation.fulfill()
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 600.0)
    }
}
