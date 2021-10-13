//
//  SpaceXLaunchFetcher.swift
//  SpaceX Latest Launch
//
//  Created by Kaan Yıldız on 13.10.2021.
//

import Foundation
import Alamofire
import UIKit // For managing images
class SpaceXLaunchFetcher : ObservableObject {
    
    @Published var launch : SpaceXLaunch!
    
    
    
    
    @Published var patchImageResponse : (image: UIImage?,error: String?) = (nil,nil) //
    
    @Published var error : String!
    
    init() {
        fetchRandomLaunch()
//        fetchLaunch()
    }
    
    
    func fetchLaunch() {
        AF.request("https://api.spacexdata.com/v4/launches/latest").response(queue: .main) { [self] response in
            
            guard response.data != nil else {
                objectWillChange.send()
                error = response.error?.localizedDescription
                return
            }
            objectWillChange.send()
            do {
                let newLaunch = try JSONDecoder().decode(SpaceXLaunch.self, from: (response.data!))
                error = nil
                launch = newLaunch
                
                
                
                guard let smallPatchURL = launch.links.patch.small else {
                    self.patchImageResponse.1 = "Image URL does not exist"
                    return
                }
                
                fetchImage(url: smallPatchURL) { image, error in
                    objectWillChange.send()
                    if image != nil {
                        patchImageResponse.0 = image
                        patchImageResponse.1 = nil
                        print("Patch Image changed")
                    } else {
                        self.patchImageResponse.1 = error?.localizedDescription ?? "Image could not be retrieved"
                    }
                }
                    
                
            } catch {
                self.error = error.localizedDescription
            }
            
        }
        
    }
    
    
    //Can be used for details and patch image tabs
    func fetchRandomLaunch() {
        AF.request("https://api.spacexdata.com/v4/launches").response(queue: .main) { [self] response in
            
            guard response.data != nil else {
                objectWillChange.send()
                error = response.error?.localizedDescription
                return
            }
            objectWillChange.send()
            do {
                let newLaunch = try! JSONDecoder().decode([SpaceXLaunch].self, from: (response.data!))
                error = nil
                launch = newLaunch.randomElement()
                
                
                
                guard let smallPatchURL = launch.links.patch.small else {
                    self.patchImageResponse.1 = "Image URL does not exist"
                    return
                }
                
                fetchImage(url: smallPatchURL) { image, error in
                    objectWillChange.send()
                    if image != nil {
                        patchImageResponse.0 = image
                        patchImageResponse.1 = nil
                        print("Patch Image changed")
                    } else {
                        self.patchImageResponse.1 = error?.localizedDescription ?? "Image could not be retrieved"
                    }
                }
                    
                
            } catch {
                self.error = error.localizedDescription
            }
            
        }
        
    }
    
    private func fetchImage(url: String, completion : @escaping (UIImage?,Error?)->()) {
        AF.request(url).response(queue: .main) { response in
            print("Image response data \(response.data)")
            if response.data != nil, let image = UIImage(data: response.data!) {
                completion(image,nil)
            }
            completion(nil,response.error)
        }
    }
}

public struct AnyDecodable: Decodable {
  public var value: Any

  private struct CodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    init?(intValue: Int) {
      self.stringValue = "\(intValue)"
      self.intValue = intValue
    }
    init?(stringValue: String) { self.stringValue = stringValue }
  }

  public init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: CodingKeys.self) {
      var result = [String: Any]()
      try container.allKeys.forEach { (key) throws in
        result[key.stringValue] = try container.decode(AnyDecodable.self, forKey: key).value
      }
      value = result
    } else if var container = try? decoder.unkeyedContainer() {
      var result = [Any]()
      while !container.isAtEnd {
        result.append(try container.decode(AnyDecodable.self).value)
      }
      value = result
    } else if let container = try? decoder.singleValueContainer() {
      if let intVal = try? container.decode(Int.self) {
        value = intVal
      } else if let doubleVal = try? container.decode(Double.self) {
        value = doubleVal
      } else if let boolVal = try? container.decode(Bool.self) {
        value = boolVal
      } else if let stringVal = try? container.decode(String.self) {
        value = stringVal
      } else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
      }
    } else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
    }
  }
}
