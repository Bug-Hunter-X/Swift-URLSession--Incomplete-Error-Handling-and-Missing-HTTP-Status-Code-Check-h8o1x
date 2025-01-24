func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let response = response as? HTTPURLResponse {
                let error = NSError(domain: "HTTP Status Code Error", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP status code: "
                    + String(response.statusCode)])
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
            }
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from the server"] )))
            return
        }
        completion(.success(data))
    }.resume()
}