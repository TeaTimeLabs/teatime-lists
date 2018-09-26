//
//  GoogleHelper.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/16/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

import Foundation
import Parse
import GooglePlaces
import Alamofire
import SwiftyJSON

class GoogleHelper: NSObject{
    static let singleton = GoogleHelper()
    //The list of place categories ignored in the search results
    private var googlePlaceCategoryBlackList = [
        "administrative_area_level_1",
        "administrative_area_level_2",
        "administrative_area_level_3",
        "administrative_area_level_4",
        "administrative_area_level_5",
        "colloquial_area",
        "floor",
        "geocode",
        "post_box",
        "postal_code",
        "postal_code_prefix",
        "postal_code_suffix",
        "postal_town",
        "sublocality",
        "sublocality_level_1",
        "sublocality_level_2",
        "sublocality_level_3",
        "sublocality_level_4",
        "sublocality_level_5"
    ]
    
    private var googlePlacesClient : GMSPlacesClient!
    private let GOOGLE_PLACES_SDK_API_KEY = "AIzaSyBr4D7SOxkwhUj-6qACVv5HI4K4Tn_yhMM"
    private let GOOGLE_PLACE_WEB_API_KEY = "AIzaSyAjKKL-7L-W2g1ub3caWRRDn4qK80suNjw"
    private let GOOGLE_PLACEDETAILS_URL = "https://maps.googleapis.com/maps/api/place/details/json"
    private let GOOGLE_PLACEAUTOCOMPLETE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    override init(){
        super.init()
        
        //Initializing the Google Places SDK
        GMSPlacesClient.provideAPIKey(GOOGLE_PLACES_SDK_API_KEY)
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
                
                let country = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                    addressComponent.type.lowercased() == "country"}).first?.name ?? ""
                
                
                let city = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                    addressComponent.type.lowercased() == "locality"}).first?.name ?? ""
                
                let category = googlePlace.types.first ?? ""
                
                if !wself.googlePlaceCategoryBlackList.contains(category){
                    nearbyPlaceSearchResults.append(Place(
                        googleID: googlePlace.placeID,
                        name: googlePlace.name,
                        category: category,
                        formattedAddress: googlePlace.formattedAddress ?? "",
                        shortAddress: wself.getShortAddress(googlePlace: googlePlace, includeNeighborhood: false),
                        city: city,
                        country: country,
                        lat: googlePlace.coordinate.latitude,
                        long: googlePlace.coordinate.longitude,
                        imageURL: ""
                    ))
                }//print(googlePlace.name, " | ADDR: ", googlePlace.formattedAddress ?? "No formattedAddress", " | CITY: ", city, "DIST: ", distanceInMeters)
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
            var predictionArray = [Place]()
            
            for i in 0...predictions.count{
                let prediction = predictions[i]
                if let name = prediction["description"].string, let id = prediction["place_id"].string, let category = prediction["types"][0].string, !wself.googlePlaceCategoryBlackList.contains(category){
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
                print("No place details found for Google Place ID \(googleID)")
                completion(nil, nil)
                return
            }
            
            //Converting the Google Place to a Place object
            let place = Place()
            place.googleID = googleID
            place.name = googlePlace.name
            place.category = googlePlace.types[0]
            place.formattedAddress = googlePlace.formattedAddress ?? ""
            place.shortAddress = wself.getShortAddress(googlePlace: googlePlace, includeNeighborhood: false)
            
            let city = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                addressComponent.type.lowercased() == "locality"}).first?.name ?? ""
            place.city = city
            
            let country = googlePlace.addressComponents?.filter({ (addressComponent) -> Bool in
                addressComponent.type.lowercased() == "country"}).first?.name ?? ""
            place.country = country
            
            let coordinates = PFGeoPoint(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            place.coordinates = coordinates
            completion(nil, place)
        }
    }
    
    
    
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
    
    
    func getPlacePhotos(googleID: String, completion: @escaping ((_ error: Error?, _ photo: UIImage?)-> Void)) {
        
        googlePlacesClient.lookUpPhotos(forPlaceID: googleID) { [weak self] (photoMetadata, error) -> Void in
            guard let wself = self else { return }
            
            if let error = error {
                print("lookup place photo error: \(error.localizedDescription)")
                completion(error, nil)
                return
            }
            
            guard let photoData = photoMetadata, let firstPhotoData = photoData.results.first else {
                print("No photos found for Google Place ID \(googleID)")
                completion(nil, nil)
                return
            }
            
            wself.loadImageForPhotoMetadata(photoMetadata: firstPhotoData) { (error, image) in
                if let error = error {
                    print("Failed to retrieve photos for Google Place ID \(googleID)")
                    completion(error, nil)
                    return
                }
                if let image = image{
                    completion(nil, image)
                } else{
                    completion(nil, nil)
                }
            }
        }
    }
    
    private func loadImageForPhotoMetadata(photoMetadata: GMSPlacePhotoMetadata, completion: @escaping ((_ error: Error?, _ photo: UIImage?)-> Void)) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata) { (photo, error) -> Void in
            if let error = error {
                completion(error, nil)
                return
            }
            if let photo = photo{
                completion(nil, photo)
            } else{
                completion(nil, nil)
            }
            
            //self.attributionTextView.attributedText = photoMetadata.attributions;
        }
    }
    
}

