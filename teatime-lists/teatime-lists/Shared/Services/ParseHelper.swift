//
//  ParseHelper.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/20/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

//TODO:
//Complete helper with missing functions
//Optimize the AddPlaceToList function so that it only requires a single calls vs. 2, by using a server-side script
//Configure a server side Chron job that deletes all the place items that are no longer associated with lists (e.g., after a list gets deleted)



import Foundation
import Parse


final class ParseHelper: NSObject{
    static let singleton = ParseHelper()
    static var currentUser : UserModel? {
        return PFUser.current() as? UserModel
    }

    private override init() {}
    

    
    func resisterTestUser(email: String, password: String, completion: @escaping ((_ error: Error?, _ user: UserModel?)->Void)){
        
        let gmailUser = UserModel(facebookID: "345", email: email, fullname: "Benjamin Vigier", firstname: "Benjamin", lastname: "Vigier", photoURL: "")
        let benUser = UserModel(facebookID: "456", email: email, fullname: "Johnny Appleseed", firstname: "Johnny", lastname: "Appleseed", photoURL: "")
        
        let userToRegister : UserModel = email == "benjamin.vigier@gmail.com" ? gmailUser : benUser
        userToRegister.password = password
        
        // Saving the new user in Parse
        print("USER ID BEFORE REGISTRATION = ", userToRegister.objectId ?? "None")
        
        userToRegister.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                completion(error, nil)
                
            } else {
                //userToRegister.saveEventually()
                print("USER ID AFET REGISTRATION = ", userToRegister.objectId ?? "None")
                completion(nil, userToRegister)
            }
        }
        
    }
    
    
    //Logs a user in and delivers the corresponding UserModel object in the callback if successful
    func login(email: String, password: String, completion: ((_ error: Error?, _ user: UserModel?)-> Void)? = nil){
        //Signing the user in
        PFUser.logInWithUsername(inBackground: email, password: password) { (user: PFUser?, error: Error?) in
        
            if let err = error {
                UserModel.currentUser = nil
                completion?(err, nil)
                return
            }
            
            guard let parseUser = user as? UserModel  else { completion?(nil, nil); return }
            completion?(nil, parseUser)
        }
    }
    
    
    //Logs the current user out locally
    func logOut(){
        guard let _ = PFUser.current() else {
            print("No user logged in")
            return
        }
        //Logging the user out on the server
        PFUser.logOut()
        print("LOGOUT COMPLETED")
    }
    
    
    //Logs the current user out on the Parse server
    func logOut(completion: ((_ success: Bool, _ error: Error?)-> Void)? = nil){
        guard let _ = PFUser.current() else {
            print("No user logged in")
            completion?(false, nil)
            return
        }
        //Logging the user out on the server
        PFUser.logOutInBackground { (error) in
            if let error = error{
                completion?(false, error)
            } else{
                completion?(true, nil)
            }
        }
    }
    
    
    //MARK: LIST MANAGEMENT
    //Saves a list in Parse
    func createList(list: ListModel, completion: ((_ success: Bool, _ error: Error?)-> Void)? = nil){
        guard let currentUser = ParseHelper.currentUser else{
            print("UPDATE LIST - ERROR: USER IS NOT LOGGED IN")
            completion?(false, nil)
            return
        }
        list.user = currentUser
        list.saveInBackground { (success, error) in
            completion?(success, error)
        }
    }
    
    
    //Updates an existing list (i.e., that has already been created using CreateList()), including its placeItems
    func updateList(list: ListModel, completion: @escaping ((_ success: Bool, _ error: Error?)-> Void)){
        guard let _ = ParseHelper.currentUser else{
            print("UPDATE LIST - ERROR: USER IS NOT LOGGED IN")
            completion(false, nil)
            return
        }
        
        guard let _ = list.objectId else {
            print("UPDATE LIST - ERROR: LIST \(list.title)MUST BE CREATED BEFORE BEING UPDATED")
            completion(false, nil)
            return
        }
        
        //Ensuring that all the placeItems have the right position value for the current sorting
        if !list.placeItems.isEmpty{
            for i in 0...list.placeItems.count-1{
                list.placeItems[i].position = i
            }
        }
        
        list.saveInBackground { (success, error) in
            completion(success, error)
        }
    }
    
    //Deletes a list in Parse
    func deleteList(list: ListModel, completion: @escaping ((_ success: Bool, _ error: Error?)->Void)){
        print("DELETING LIST: ", list.title)
        guard let _ = list.objectId else {
            print("REFRESH LIST - ERROR: THIS LIST IS NOT SAVED IN PARSE")
            completion(false, nil)
            return
        }
        list.deleteInBackground { (success, error) in
            completion(success, error)
            return
        }
    }
    

    //Fetches one or multiple place records based on Google IDs
    func fetchPlaces(googleIDs: [String], completion: @escaping ((_ success: Bool, _ error: Error?, _ places: [Place]?)-> Void)){
        
        guard !googleIDs.isEmpty else {
            completion(true, nil, nil)
            return
        }
        
        let query = Place.query()
        query?.whereKey("googleID", containedIn: googleIDs)
        query?.includeKey("followers")
        
        query?.findObjectsInBackground { (places, error) in
            if let error = error{
                completion(false, error, nil)
                return
            }
            
            guard let places = places as? [Place], !places.isEmpty else {
                completion(true, nil, nil)
                return
            }
            
            print("SUCCESSFULLY RETRIEVED \(places.count) PLACES FROM PARSE")
            completion(true, nil, places)
            return
        }
    }

    

    //Saves a new Place in Parse if it does not already exist
    func createPlace(place: Place, completion: @escaping ((_ success: Bool, _ error: Error?)-> Void)){
        
        guard let _ = ParseHelper.currentUser else{
            print("CREATE PLACE - ERROR: USER IS NOT LOGGED IN")
            completion(false, nil)
            return
        }
        
        guard place.objectId == nil else {
            print("PLACE \(place.name) ALREADY HAS A PARSE ID")
            completion(false, nil)
            return
        }
        
        //Checking whether this place already exists
        let query = Place.query()
        query?.whereKey("googleID", equalTo: place.googleID)
        
        query?.findObjectsInBackground { (places, error) in
            if let error = error{
                completion(false, error)
                return
            }
            
            if let places = places, !places.isEmpty{
                print("PLACE \(place.name) ALREADY EXISTS IN PARSE")
                completion(false, nil)
                return
            }
            
            //Saving the place in Parse
            place.saveInBackground { (success, error) in
                if let error = error{
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        }
    }

    
    //Adds a place to a list in Parse
    //The corresponding placeItem MUST already have been added to the placeItems array of the list. Its position value will be assigned based on its current position in the array
    //1) Create new place record for that place if it does not already exist TODO: the check of whether it exists or not should be made by a JS script server side
    //2) Creates new PlaceItem records for that list and place
    //3) Adds the user as a follower of the place by updating the corresponding Relation in the Place record (needed for categories)
    //Currently requires 2 server queries. TODO: optimize by defining a server JS script that combines the 2 queries (check if a place exists and create it otherwise)
    func addPlaceToList(list: ListModel, placeItem: PlaceItem, completion: @escaping ((_ success: Bool, _ error: Error?)-> Void)){
        
        guard let currentUser = ParseHelper.currentUser else{
            print("ADD PLACE TO LIST - ERROR: USER IS NOT LOGGED IN")
            completion(false, nil)
            return
        }
        
        //Verifying that the placeItem is already in the ListModel's placeItems array
        guard list.placeItems.contains(where: {$0.place.googleID == placeItem.place.googleID}) else{
           print("ADD PLACE TO LIST - ERROR: THE PLACEITEM MUST BE INCLUDED TO THE LIST BEFORE CALLING ADD PLACE TO LIST")
            completion(false, nil)
            return
        }
        
        //Ensuring that all the placeItems have the right position value for the current sorting
        for i in 0...list.placeItems.count-1{
            list.placeItems[i].position = i
        }
        
        
        if placeItem.place.objectId == nil{
            //Creating a new place if needed
            
            //Checking whether this place already exists
            let query = Place.query()
            query?.whereKey("googleID", equalTo: placeItem.place.googleID)
            
            query?.findObjectsInBackground { (places, error) in
                if let error = error{
                    completion(false, error)
                    return
                }
                
                if let places = places, !places.isEmpty{
                    //The place already exists in Parse
                    guard let place = places.last as? Place else {
                        completion(false, nil)
                        return
                    }
                   placeItem.place = place
                }
                //Adding the current user as a follower of the place if not already one
                if !placeItem.place.followers.contains(where: {$0.objectId == currentUser.objectId}){
                    placeItem.place.followers.append(currentUser)
                }
        
                //Saving the list
                list.saveInBackground { (success, error) in
                    if let error = error{
                        completion(false, error)
                        return
                    }
                    if !success{
                        completion(false, nil)
                        return
                    }
                    completion(true, nil)
                    return
                }
            }
            return
        }
        
        //Adding the current user as a follower of the place if not already one and saving the PlaceItem (single query)
        if !placeItem.place.followers.contains(where: {$0.objectId == currentUser.objectId}){
            placeItem.place.followers.append(currentUser)
        }
        //Saving the list
        list.saveInBackground { (success, error) in
            if let error = error{
                completion(false, error)
                return
            }
            if !success{
                completion(false, nil)
                return
            }
            completion(true, nil)
            return
        }
    }
    
    
    //Fetches the lists of one or multiple users.
    //If users parameter is nil or empty, then fetches all lists
    func fetchUserLists(users: [UserModel]?, completion: @escaping ((_ success: Bool, _ error: Error?, _ lists: [ListModel]?)->Void)){
        
        if let userArray = users, !userArray.isEmpty{
            //Loading the lists for the specified users
            print("FETCHING LISTS FOR USERS: ", userArray)
            let query = ListModel.query()?.whereKey("user", containedIn: userArray)
            query?.includeKey("user")
            query?.includeKey("placeItems")
            query?.includeKey("placeItems.place")
            query?.includeKey("placeItems.place.followers")
            
            query?.findObjectsInBackground { (lists, error) in
                if let error = error{
                    completion(false, error, nil)
                    return
                }
                
                guard let lists = lists as? [ListModel], !lists.isEmpty else {
                    completion(true, nil, nil)
                    return
                }
                
                print("SUCCESSFULLY RETRIEVED \(lists.count) LISTS FROM PARSE")
                completion(true, nil, lists)
                return
            }
            return
        }
        //Loading all lists
        print("FETCHING ALL LISTS")
        let query = ListModel.query()
        query?.includeKey("user")
        query?.includeKey("placeItems")
        query?.includeKey("placeItems.place.followers")
        
        query?.findObjectsInBackground { (lists, error) in
            if let error = error{
                completion(false, error, nil)
                return
            }
            
            guard let lists = lists as? [ListModel], !lists.isEmpty else {
                completion(true, nil, nil)
                return
            }
            
            print("SUCCESSFULLY RETRIEVED \(lists.count) LISTS FROM PARSE")
            completion(true, nil, lists)
            return
        }
    }
    
    //Refreshes the content of one or multiple lists
    func refreshLists(lists: [ListModel], completion: @escaping ((_ success: Bool, _ error: Error?, _ list: ListModel?)->Void)){
         guard !lists.isEmpty else {
            completion(true, nil, nil)
            return
        }
        //Ensuring that all the lists in the array already exists in Parse
        for list in lists{
            if list.objectId == nil{
                print("REFRESH LISTS - ERROR: LIST \(list.title) IS NOT SAVED IN PARSE")
                completion(false, nil, nil)
                return
            }
        }

        let objectIDArray = lists.map( {$0.objectId!})
        
        let query = ListModel.query()?.whereKey("objectId", containedIn: objectIDArray)
        query?.includeKey("user")
        query?.includeKey("placeItems")
        query?.includeKey("placeItems.place")
        query?.includeKey("placeItems.place.followers")
        
        query?.findObjectsInBackground { (lists, error) in
            if let error = error{
                completion(false, error, nil)
                return
            }
            
            guard let lists = lists as? [ListModel], !lists.isEmpty else {
                completion(true, nil, nil)
                return
            }
            
            print("SUCCESSFULLY RETRIEVED \(lists.count) LISTS FROM PARSE")
            completion(true, nil, lists.first)
            return
        }
    }

    
    
    
    
}
