//
//  NetworkService.swift
//  ToDo-App
//
//  Created by Jadson on 22/04/22.
//

import Foundation

//it's possible to use typealias to replace a bunch of code:
//typealias onAPISuccess = (Todos) -> Void (this would go to the func like so: getTodos(onSuccess: @escaping onAPISuccess))

class NetworkService {
    static let shared = NetworkService() //using singleton
    
    let URL_BASE = "http://localhost:3003"
    let URL_ADD_TODO = "/add"
    
    let session = URLSession(configuration: .default)
    
    //func with closure able to escape (leave the function) and won't return anything
    func getTodos(onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void) {
        let url = URL(string: "\(URL_BASE)")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            
            //bring the request from the background to the main thread once it's finished (dispach...)
            DispatchQueue.main.async {
                
                //handling the error message
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                //checking the data
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    //checking the status code from the server/API
                    if response.statusCode == 200 {
                        //parse successful result (todos)
                        let items = try JSONDecoder().decode(Todos.self, from: data) //reference to the model file
                        //passing using the closure
                        onSuccess(items)
                        //handle sucess:
                    } else {
                        //show error to user
                        let err = try JSONDecoder().decode(APIError.self, from: data) //reference to the model file
                        //handle error using the closure
                        onError(err.message)
                    }
                }
                catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
        
    }
    
    func addTodo(todo: Todo, onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void) {
        let url = URL(string: "\(URL_BASE)\(URL_ADD_TODO)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // (new item) | GET, PUT, POST, DELETE
        //setting the type of data that is being sending to the api (json / xml / others)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let body = try JSONEncoder().encode(todo)
            request.httpBody = body
            
            let task = session.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    
                    if let error = error {
                        onError(error.localizedDescription)
                        return
                    }
                    guard let data = data, let response = response  as? HTTPURLResponse else {
                        onError("Failed to get data from server")
                        return
                    }
                    
                    do {
                        if response.statusCode == 200 {
                            let items = try JSONDecoder().decode(Todos.self, from: data)
                            onSuccess(items)
                        } else {
                            let err = try JSONDecoder().decode(APIError.self, from: data)
                            onError(err.message)
                        }
                        
                    } catch {
                        onError(error.localizedDescription)
                    }
                }
                
            }
            
            task.resume()
        } catch {
            onError(error.localizedDescription)
        }
    }
}
