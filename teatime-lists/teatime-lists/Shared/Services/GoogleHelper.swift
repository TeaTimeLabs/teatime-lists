//
//  GoogleHelper.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/16/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

import Foundation
import GooglePlaces
import Alamofire
import SwiftyJSON

final class GoogleHelper: NSObject {
    static let singleton = GoogleHelper()

    
    private var googlePlacesClient : GMSPlacesClient!
    private let GOOGLE_PLACES_SDK_API_KEY = "AIzaSyBr4D7SOxkwhUj-6qACVv5HI4K4Tn_yhMM"
    private let GOOGLE_PLACE_WEB_API_KEY = "AIzaSyAjKKL-7L-W2g1ub3caWRRDn4qK80suNjw"
    private let GOOGLE_PLACEDETAILS_URL = "https://maps.googleapis.com/maps/api/place/details/json"
    private let GOOGLE_PLACEAUTOCOMPLETE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    
    override private init(){
        super.init()
        
        //Initializing the Google Places SDK
//        GMSPlacesClient.provideAPIKey(GOOGLE_PLACES_SDK_API_KEY)
        googlePlacesClient = GMSPlacesClient.shared()
        
    }
    
    //MARK: - Google Current Place Search VIA SDK
    /***************************************************************/
    
    func fetchNearbyPlacesList(completion: @escaping ((_ error: Error?, _ results: [Place]?)-> Void)){
        
        googlePlacesClient.currentPlace { [weak self] (placeLikelihoodList, error) -> Void in
            
            guard let wself = self else { return }
            if let error = error {
                print("Google SDK Current Place error: \(error.localizedDescription)")
                completion(error, nil)
                return
            }
            
            var nearbyPlaceSearchResults = [Place]()
            
            guard let placeLikelihoodList = placeLikelihoodList else { return }
            print("GOOGLE CURRENT PLACE: \(placeLikelihoodList.likelihoods.count) RESULTS RECEIVED")
            
            for likelihood in placeLikelihoodList.likelihoods {
                let googlePlace = likelihood.place
                
                let googlePlaceCoordinates = CLLocation(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
//                let distanceInMeters = googlePlaceCoordinates.distance(from: LocationServicesHelper.singleton.currentLocation)
                let city = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                    addressComponent.type.lowercased() == "locality"
                }).first?.name ?? ""
                
                nearbyPlaceSearchResults.append(Place(
                    googleID: googlePlace.placeID,
                    name: googlePlace.name,
                    category: googlePlace.types.first ?? "",
                    formattedAddress: googlePlace.formattedAddress ?? "",
                    shortAddress: wself.getShortAddress(googlePlace: googlePlace, includeNeighborhood: false),
                    city: city,
                    lat: googlePlace.coordinate.latitude,
                    long: googlePlace.coordinate.longitude,
                    imageURL: ""
                ))
                //print(googlePlace.name, " | ADDR: ", googlePlace.formattedAddress ?? "No formattedAddress", " | CITY: ", city, "DIST: ", distanceInMeters)
            }
            completion(nil, nearbyPlaceSearchResults)
        }
    }
    
  
    func getPlaceAutoCompletePredictions(userQuery: String, queryID: Int, completion: @escaping ((_ queryID: Int, _ error: Error?, _ results: [Place]?)-> Void)) {
        
        let googleParam : [String : String] = [
            "key" : GOOGLE_PLACE_WEB_API_KEY,
            "input" : userQuery
        ]
        
        Alamofire.request(GOOGLE_PLACEAUTOCOMPLETE_URL, method: .get, parameters: googleParam).responseJSON { [weak self] response in
            guard let wself = self else { return }
            if !response.result.isSuccess, let error = response.result.error {
                completion(queryID, error, nil)
                return
            }
            guard let jsonData = response.result.value else { completion(queryID, nil, nil); return}
            let json = JSON(jsonData)
            
            //Checking whether the JSON content defines an error
            if json["status"] != "OK"{
                print("Error when trying to get the Google Autocomplete results for query: ", userQuery, " : ", json["status"])
                return
            }
            
            let predictions = json["predictions"]
            print("PREDICTIONS.COUNT = ", predictions.count)
            var predictionArray = [Place]()
            
            for i in 0...predictions.count{
                let prediction = predictions[i]
                print("PREDICTION \(i) = ", prediction)
                if let name = prediction["description"].string, let id = prediction["place_id"].string, let category = prediction["types"][0].string{
                    let place = Place()
                    place.googleID = id
                    place.name = name
                    place.category = category
                    predictionArray.append(place)
                }
            }
            guard !predictionArray.isEmpty else {
                completion(queryID, nil, nil)
                return
            }
            var results = [Place]()
            //Getting the place details for each prediction (since predications do not include the actual place type, nor other needed info (clean name, etc.))
            //Also Google Place details fails to return details for each placeID, which is why a second array is used to filter only the predications that received details
            for i in 0...predictionArray.count-1{
                wself.getPlaceDetails(googleID: predictionArray[i].googleID) { (error, placeResult) in
                    if let error = error{
                        print("ERROR OCCURED WHILE RETRIEVING PLACE DETAILS FOR PLACE \(predictionArray[i].name): ", error)
                    } else if let placeResult = placeResult{
                        results.append(placeResult)
                    }
                    if i == predictionArray.count-1{
                        completion(queryID, nil, results)
                    }
                }
            }
            //completion(queryID, nil, results)
        }
    }
    
    func getPlaceDetails(googleID: String, completion: @escaping ((_ error: Error?, _ result: Place?)-> Void)) {
       
        googlePlacesClient.lookUpPlaceID(googleID) { [weak self] (googlePlace, error) -> Void in
            guard let wself = self else { return }
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                completion(error, nil)
                return
            }
            
            guard let googlePlace = googlePlace else {
                print("No place details found for \(googleID)")
                completion(nil, nil)
                return
            }
            
            //Converting the Google Place to a Place object
            let place = Place()
            place.googleID = googleID
            place.name = googlePlace.name
            place.category = googlePlace.types[0]
            place.formattedAddress = googlePlace.formattedAddress ?? ""
            
//            print("\n\nFORMATTED ADDRESS = ", place.formattedAddress)
//            if let components = googlePlace.addressComponents{
//                for comp in components{
//                    print("COMPONENTS = [", comp.type, ",", comp.name, "]\n\n")
//                }
//            }
            
            place.shortAddress = wself.getShortAddress(googlePlace: googlePlace, includeNeighborhood: false)
          
            let city = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                addressComponent.type.lowercased() == "locality"}).first?.name ?? ""
            place.city = city
            
            let country = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                addressComponent.type.lowercased() == "country"}).first?.name ?? ""
            place.country = country
            
            place.lat = googlePlace.coordinate.latitude
            place.long = googlePlace.coordinate.longitude
            completion(nil, place)
        }
    }
        
//        func loadFirstPhotoForPlace(placeID: String) {
//            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
//                if let error = error {
//                    // TODO: handle the error.
//                    print("Error: \(error.localizedDescription)")
//                } else {
//                    if let firstPhoto = photos?.results.first {
//                        self.loadImageForMetadata(photoMetadata: firstPhoto)
//                    }
//                }
//            }
//        }
//
//        func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
//            GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
//                (photo, error) -> Void in
//                if let error = error {
//                    // TODO: handle the error.
//                    print("Error: \(error.localizedDescription)")
//                } else {
//                    self.imageView.image = photo;
//                    self.attributionTextView.attributedText = photoMetadata.attributions;
//                }
//            })
//        }
    
    //Returns the address info to display in cells for a place based on the address components returned by Google
    func getShortAddress(googlePlace: GMSPlace, includeNeighborhood: Bool) -> String{
        
        let category = googlePlace.types[0]
        
        if category == "locality" || category == "country"{
            if let country = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                addressComponent.type.lowercased() == "country"
            }).first?.name{
                return country
            }
        }
        
        let streetNumber = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
            addressComponent.type.lowercased() == "street_number"
        }).first?.name ?? ""
        
        let route = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
            addressComponent.type.lowercased() == "route"
        }).first?.name ?? ""
        
        let neighborhood = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
            addressComponent.type.lowercased() == "neighborhood"
        }).first?.name ?? ""
        
        let city = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
            addressComponent.type.lowercased() == "locality"
        }).first?.name ?? ""
        
        var shortAddress = ""
        
        if !neighborhood.isEmpty && includeNeighborhood{
            shortAddress = neighborhood
        }
        
        if !shortAddress.isEmpty{
            shortAddress += " • "
        }
        
        var streetAddress = ""
        if !streetNumber.isEmpty{
            streetAddress += "\(streetNumber) \(route)"
        } else if !route.isEmpty{
            streetAddress += route
        }
        
        if !streetAddress.isEmpty{
            shortAddress += streetAddress
            if !city.isEmpty{
                shortAddress += ", \(city)"
            }
        } else{
            shortAddress.isEmpty ? (shortAddress += city) : (shortAddress += " • \(city)")
        }
        if shortAddress.isEmpty{
            shortAddress = googlePlace.formattedAddress ?? ""
        }
        
        return shortAddress
    }
    
    
    
    
}

