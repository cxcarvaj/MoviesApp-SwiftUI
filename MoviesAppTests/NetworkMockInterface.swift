//
//  NetworkMockInterface.swift
//  MyLibraryTDD
//
//  Created by Carlos Xavier Carvajal Villegas on 23/4/25.
//

import Foundation
@testable import MoviesApp

final class NetworkMockInterface: URLProtocol {
    private var urlGenres: URL {
        Bundle.main.url(forResource: "genres", withExtension: "json")!
    }
    
    private var urlNowPlaying: URL {
        Bundle.main.url(forResource: "now_playing", withExtension: "json")!
    }
    
    private var urlUpcoming: URL {
        Bundle.main.url(forResource: "upcoming", withExtension: "json")!
    }
        
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let url = request.url,
              let response = HTTPURLResponse(url: url,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: ["Content-Type": "application/json; charset=utf-8"]) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        
        var data: Data?
        
        if url.lastPathComponent == "now_playing" {
            data = try? Data(contentsOf: urlNowPlaying)
        } else if url.lastPathComponent == "upcoming" {
            data = try? Data(contentsOf: urlUpcoming)
        } else if url.absoluteString.contains("genre") {
            data = try? Data(contentsOf: urlGenres)
        }
            
        guard let data else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
