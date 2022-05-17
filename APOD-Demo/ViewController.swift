//
//  ViewController.swift
//  APOD-Demo
//
//  Created by Hanna Chen on 2022/5/11.
//

import UIKit
import Combine

class ViewController: UIViewController {
    // MARK: - Properties

    let method: LoadingMethod
    let url: URL = {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "DEMO_KEY")
        ]

        return urlComponents.url!
    }()

    var subscriptions = Set<AnyCancellable>()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Life Cycle

    init?(coder: NSCoder, method: LoadingMethod) {
        self.method = method
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetch()
    }

    // MARK: - Methods

    func fetch() {
        switch method {
        case .completionHandler:
            completionHandlerAPI()
        case .asyncFunction:
            asyncFunctionAPI()
        case .combine:
            combineAPI()
        case .genericService:
            genericService()
        }
    }

    func updateUI(with info: PictureInfo, image: UIImage?) {
        titleLabel.text = info.title
        descriptionTextView.text = info.description
        imageView.image = image
        activityIndicator.stopAnimating()
    }
}

// MARK: - APIs

extension ViewController {
    func completionHandlerAPI() {
        CompletionHandlerAPI.fetchPicture(from: url) { result in
            switch result {
            case .success(let info):
                CompletionHandlerAPI.loadImage(from: info.url) { image in
                    DispatchQueue.main.async {
                        self.updateUI(with: info, image: image)
                    }
                }
            case .failure(let error):
                print("Error fetching picture info:", error.localizedDescription)
            }
        }
    }

    func asyncFunctionAPI() {
        Task {
            do {
                let info = try await AsyncFunctionAPI.fetchPicture(from: url)
                let image = try await AsyncFunctionAPI.loadImage(from: info.url)
                updateUI(with: info, image: image)
            } catch {
                print("Error fetching picture info:", error.localizedDescription)
            }
        }
    }

    func combineAPI() {
        CombineAPI.picturePublisher(from: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("Error fetching picture info:", error.localizedDescription)
                }
            },receiveValue: { info in
                CombineAPI.imagePublisher(from: info.url)
                    .receive(on: DispatchQueue.main)
                    .sink { image in
                        self.updateUI(with: info, image: image)
                    }
                    .store(in: &self.subscriptions)
            })
            .store(in: &subscriptions)
    }

    func genericService() {
        Task {
            do {
                let info = try await PictureInfoService(url: url).fetch()
                let image = try await ImageService(url: info.url).fetch()
                updateUI(with: info, image: image)
            } catch {
                print("Error fetching picture info:", error.localizedDescription)
            }
        }
    }
}
